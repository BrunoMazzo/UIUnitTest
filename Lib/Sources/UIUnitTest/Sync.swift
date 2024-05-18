import Foundation
import XCTest

class Box {
    var value: Any?
    var success: Bool = false
}

@globalActor
public struct UIUnitTestActor {
    public actor MyActor {}
    public static let shared = MyActor()
}

public struct Executor: @unchecked Sendable {
    private var box = Box()
    
    public static func execute<T>(function: String = #function, _ block: @escaping () async throws -> T) -> Result<T, Error> {
        let executor = Executor()
        return executor.execute(function: function, block)
    }
    
    // TODO: Think about a better way to handle errors. Maybe just fail the test?
    func execute<T>(function: String = #function, _ block: @escaping () async throws -> T) -> Result<T, Error> {
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
    func valueOrFailWithFallback(_ fallback: Success, file: StaticString = #filePath, line: UInt = #line) -> Success {
        switch self {
        case let .success(result):
            return result
        case let .failure(error):
            XCTFail(error.localizedDescription, file: file, line: line)
            return fallback
        }
    }
}
