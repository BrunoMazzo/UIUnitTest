import Synchronization

final class Logger: Sendable {

    let context: Mutex<[String: String]>

    static let shared: Logger = .init()

    init(context: [String: String] = [:]) {
        self.context = Mutex(context)
    }

    func addToContext(_ key: String, value: String) {
        context.withLock {
            $0[key] = value
        }
    }

    func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        context.withLock { context in
            let contextString = context.map { key, value in
                "[\(key): \(value)]"
            }.joined()

            print(contextString, terminator: " ")
            print(items, separator: separator, terminator: terminator)
        }
    }

    func childLogger(mergeContext: [String: String] = [:]) -> Logger {
        return self.context.withLock { context in
            Logger(context: context.merging(mergeContext, uniquingKeysWith: { $1 }))
        }
    }
}
