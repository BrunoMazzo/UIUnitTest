import Foundation
import XCTest
import os

class Box {
    var value: Any?
    var success: Bool = false
    
    var finished: Bool = false
    
    func success(value: Any?) {
        self.value = value
        self.success = true
        self.finished = true
    }
    
    func error(error: Any) {
        self.value = error
        self.success = false
        self.finished = true
    }
}

@globalActor
public struct UIUnitTestActor {
    public actor MyActor {}
    public static let shared = MyActor()
}

public struct Executor: @unchecked Sendable {
    private var box = Box()
    
    public static func execute<T: Sendable>(function: String = #function, _ block: @escaping @Sendable () async throws -> T) -> Result<T, Error> {
        let executor = Executor()
        return executor.execute(function: function, block)
    }
    
    // TODO: Think about a better way to handle errors. Maybe just fail the test?
    func execute<T: Sendable>(function: String = #function, _ block: @escaping @Sendable () async throws -> T) -> Result<T, Error> {
        let expectation = XCTestExpectation(description: function)
        Task { @UIUnitTestActor in
            defer {
                expectation.fulfill()
            }
            do {
                self.box.value = try await block()
                self.box.success = true
            } catch {
                self.box.value = error
            }
        }
        _ = XCTWaiter.wait(for: [expectation])
        
        if box.success {
            return .success(box.value as! T)
        } else {
            return .failure(box.value as! Error)
        }
    }
}

extension Result {
    func valueOrFailWithFallback(
        _ fallback: Success,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) -> Success {
        switch self {
        case let .success(result):
            return result
        case let .failure(error):
            fail(error.localizedDescription, fileID: fileID, filePath: filePath, line: line, column: column)
            return fallback
        }
    }
}
