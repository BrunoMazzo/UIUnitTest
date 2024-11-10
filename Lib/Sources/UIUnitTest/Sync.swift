import Foundation
import os
import XCTest

class Box {
    var value: Any?
    var success: Bool = false

    var finished: Bool = false

    func success(value: Any?) {
        self.value = value
        success = true
        finished = true
    }

    func error(error: Any) {
        value = error
        success = false
        finished = true
    }
}

@globalActor
struct UIUnitTestExecutorActor {
    actor MyActor {}
    static let shared = MyActor()
}

enum ExecutorError: Error {
    case unknownReturnType
    case unknownServerError
}

public struct Executor: @unchecked Sendable {
    private var box = Box()

    public static func execute<T: Sendable>(
        function: String = #function,
        _ block: @escaping @Sendable () async throws -> T
    ) -> Result<T, Error> {
        let executor = Executor()
        return executor.execute(function: function, block)
    }

    func execute<T: Sendable>(
        function: String = #function,
        _ block: @escaping @Sendable () async throws -> T
    ) -> Result<T, Error> {
        let expectation = XCTestExpectation(description: function)
        Task { @UIUnitTestExecutorActor in
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
            if let value = box.value as? T {
                return .success(value)
            }
            return .failure(ExecutorError.unknownReturnType)
        } else {
            return .failure((box.value as? Error) ?? ExecutorError.unknownServerError)
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
