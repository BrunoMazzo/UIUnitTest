import Foundation

public struct ScrollRequest: Codable, Sendable {
    public var serverId: UUID
    public var deltaX: CGFloat
    public var deltaY: CGFloat
    
    public init(serverId: UUID, deltaX: CGFloat, deltaY: CGFloat) {
        self.serverId = serverId
        self.deltaX = deltaX
        self.deltaY = deltaY
    }
}

public struct ByIdRequest: Codable, Sendable {
    public var queryRoot: UUID
    public var identifier: String
    
    public init(queryRoot: UUID, identifier: String) {
        self.queryRoot = queryRoot
        self.identifier = identifier
    }
}

public struct ElementResponse: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct ElementArrayResponse: Codable, Sendable {
    public var serversId: [UUID]
    
    public init(serversId: [UUID]) {
        self.serversId = serversId
    }
}

public struct RemoveServerItemRequest: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct WaitForExistenceRequest: Codable, Sendable {
    
    public var serverId: UUID
    public var timeout: TimeInterval
    
    public init(serverId: UUID, timeout: TimeInterval) {
        self.serverId = serverId
        self.timeout = timeout
    }
}

public struct WaitForExistenceResponse: Codable, Sendable {
    public var elementExists: Bool
    
    public init(elementExists: Bool) {
        self.elementExists = elementExists
    }
}

public struct ElementTypeRequest: Codable, Sendable {
    public let serverId: UUID
    public let elementType: UInt
    public let identifier: String?
    
    public init(serverId: UUID, elementType: UInt, identifier: String? = nil) {
        self.serverId = serverId
        self.elementType = elementType
        self.identifier = identifier
    }
}

public struct ChildrenMatchinType: Codable, Sendable {
    public let serverId: UUID
    public let elementType: UInt
    
    public init(serverId: UUID, elementType: UInt) {
        self.serverId = serverId
        self.elementType = elementType
    }
}
public struct ExistsResponse: Codable, Sendable {
    public var exists: Bool
    
    public init(exists: Bool) {
        self.exists = exists
    }
}

public struct ValueResponse: Codable, Sendable {
    public var value: String?
    
    public init(value: String?) {
        self.value = value
    }
}

public struct ElementRequest: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct IsHittableResponse: Codable, Sendable {
    public var isHittable: Bool
    
    public init(isHittable: Bool) {
        self.isHittable = isHittable
    }
}
public struct PinchRequest: Codable, Sendable {
    
    public var serverId: UUID
    public var scale: CGFloat
    public var velocity: CGFloat
    
    public init(serverId: UUID, scale: CGFloat, velocity: CGFloat) {
        self.serverId = serverId
        self.scale = scale
        self.velocity = velocity
    }
}

public struct RotateRequest: Codable, Sendable {
    
    public var serverId: UUID
    public var rotation: CGFloat
    public var velocity: CGFloat
    
    public init(serverId: UUID, rotation: CGFloat, velocity: CGFloat) {
        self.serverId = serverId
        self.rotation = rotation
        self.velocity = velocity
    }
}

public enum SwipeDirection: Int, Codable, Sendable {
    case up = 1
    case down = 2
    case left = 3
    case right = 4
}

public struct SwipeRequest: Codable, Sendable {
    
    public var serverId: UUID
    public var swipeDirection: SwipeDirection
    public var velocity: GestureVelocityAPI
    
    public init(serverId: UUID, direction: SwipeDirection, velocity: GestureVelocityAPI) {
        self.serverId = serverId
        self.swipeDirection = direction
        self.velocity = velocity
    }
}

public enum GestureVelocityAPI: Hashable, Equatable, Sendable, Codable {
    case `default`, slow, fast
    case custom(CGFloat)
    
    public init(_ value: CGFloat) {
        self = .custom(value)
    }
}

extension GestureVelocityAPI : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self = .custom(CGFloat(value))
    }
    
    public typealias IntegerLiteralType = Int
}

extension GestureVelocityAPI : ExpressibleByFloatLiteral {
    
    public typealias FloatLiteralType = CGFloat.NativeType
    
    public init(floatLiteral value: GestureVelocityAPI.FloatLiteralType) {
        self = .custom(value)
    }
}

public struct TapElementRequest: Codable, Sendable {
    
    public var serverId: UUID
    public var duration: TimeInterval?
    public var numberOfTaps: Int?
    public var numberOfTouches: Int?
    
    public init(serverId: UUID, duration: TimeInterval? = nil, numberOfTaps: Int? = nil, numberOfTouches: Int? = nil) {
        self.serverId = serverId
        self.duration = duration
        self.numberOfTaps = numberOfTaps
        self.numberOfTouches = numberOfTouches
    }
}

public struct FirstMatchRequest: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct FirstMatchResponse: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}
public struct QueryRequest: Codable, Sendable {
    
    public var serverId: UUID
    public var queryType: QueryType
    
    public init(serverId: UUID, queryType: QueryType) {
        self.serverId = serverId
        self.queryType = queryType
    }
}

public struct QueryResponse: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct CountRequest: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct CountResponse: Codable, Sendable {
    public var count: Int
    
    public init(count: Int) {
        self.count = count
    }
}

public struct PredicateRequest: Codable, Sendable {
    public let serverId: UUID
    nonisolated(unsafe)
    public let predicate: NSPredicate
            
    public init(serverId: UUID, predicate: NSPredicate) {
        self.serverId = serverId
        self.predicate = predicate
    }
    
    enum CodingKeys: CodingKey {
        case serverId
        case predicate
    }
    
    public func encode(to encoder: Encoder) throws {
        let data = try NSKeyedArchiver.archivedData(
            withRootObject: predicate,
            requiringSecureCoding: true
        )
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serverId, forKey: .serverId)
        try container.encode(data, forKey: .predicate)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.serverId = try container.decode(UUID.self, forKey: .serverId)
        
        let data = try container.decode(Data.self, forKey: .predicate)

        self.predicate = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSPredicate.self], from:data) as! NSPredicate
    }
}

public struct ElementFromQuery: Codable, Sendable {
    public let serverId: UUID
    public let index: Int?
    public let elementType: UInt?
    public let identifier: String?
    
    public init(serverId: UUID, index: Int? = nil) {
        self.serverId = serverId
        self.index = index
        self.elementType = nil
        self.identifier = nil
    }
    
    public init(serverId: UUID, elementType: UInt, identifier: String? = nil) {
        self.serverId = serverId
        self.elementType = elementType
        self.identifier = identifier
        self.index = nil
    }
}

public struct DescendantsFromQuery: Codable, Sendable {
    public let serverId: UUID
    public let elementType: UInt
    
    public init(serverId: UUID, elementType: UInt) {
        self.serverId = serverId
        self.elementType = elementType
    }
}

public struct ElementsByAccessibility: Codable, Sendable {
    public let serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}
public struct CreateApplicationRequest: Codable, Sendable {
    
    public let serverId: UUID
    public let appId: String
    public let activate: Bool
    
    public init(appId: String, serverId: UUID, activate: Bool) {
        self.appId = appId
        self.serverId = serverId
        self.activate = activate
    }
}

public struct ActivateRequest: Codable, Sendable {
    
    public let serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct HomeButtonRequest: Codable, Sendable {
    public init() {}
}

public struct EnterTextRequest: Codable, Sendable {
    
    public var serverId: UUID
    public var textToEnter: String
    
    public init(serverId: UUID, textToEnter: String) {
        self.serverId = serverId
        self.textToEnter = textToEnter
    }
}


public struct TapCoordinateRequest: Codable, Sendable {
    
    public enum TapType: Codable, Sendable {
        case tap
        case doubleTap
        case press(forDuration: TimeInterval)
        case pressAndDrag(forDuration: TimeInterval, thenDragTo: UUID)
        case pressDragAndHold(forDuration: TimeInterval, thenDragTo: UUID, withVelocity: GestureVelocityAPI, thenHoldForDuration: TimeInterval)
    }
    
    public var serverId: UUID
    public var type: TapType
    
    public init(serverId: UUID, type: TapType) {
        self.serverId = serverId
        self.type = type
    }
}
public struct CoordinateRequest: Codable, Sendable {
    public let serverId: UUID
    public let normalizedOffset: CGVector
    
    public init(serverId: UUID, normalizedOffset: CGVector) {
        self.serverId = serverId
        self.normalizedOffset = normalizedOffset
    }
}

public struct CoordinateOffsetRequest: Codable, Sendable {
    public let coordinatorId: UUID
    public let vector: CGVector
    
    public init(coordinatorId: UUID, vector: CGVector) {
        self.coordinatorId = coordinatorId
        self.vector = vector
    }
}

public struct CoordinateResponse: Codable, Sendable {
    public var coordinateId: UUID
    public var referencedElementId: UUID
    public var screenPoint: CGPoint

    public init(coordinateId: UUID, referencedElementId: UUID, screenPoint: CGPoint) {
        self.coordinateId = coordinateId
        self.referencedElementId = referencedElementId
        self.screenPoint = screenPoint
    }
}

extension CGVector: Codable {
    enum CodingKeys: String, CodingKey {
        case dx
        case dy
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dx, forKey: .dx)
        try container.encode(dy, forKey: .dy)
    }
    
    public init(from decoder: any Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dx = try container.decode(CGFloat.self, forKey: .dx)
        self.dy = try container.decode(CGFloat.self, forKey: .dy)
    }
}

extension CGPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
    
    public init(from decoder: any Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(CGFloat.self, forKey: .x)
        self.y = try container.decode(CGFloat.self, forKey: .y)
    }
}

public struct AccessibilityAuditRequest: Codable, Sendable {
    public var serverId: UUID
    public var accessibilityAuditType: UInt64
    
    public init(serverId: UUID, accessibilityAuditType: UInt64) {
        self.serverId = serverId
        self.accessibilityAuditType = accessibilityAuditType
    }
}

public struct AccessibilityAuditIssueData: Codable, Sendable {
    
    /// The element associated with the issue.
    public var element: UUID?
    
    /// A short description about the issue.
    public var compactDescription: String
    
    /// A longer description of the issue with more details about the failure.
    public var detailedDescription: String
    
    /// The type of audit which generated the issue.
    public var auditType: UInt64
    
    public init(element: UUID? = nil, compactDescription: String, detailedDescription: String, auditType: UInt64) {
        self.element = element
        self.compactDescription = compactDescription
        self.detailedDescription = detailedDescription
        self.auditType = auditType
    }
}

public struct AccessibilityAuditResponse: Codable, Sendable {
    public var issues: [AccessibilityAuditIssueData]
    
    public init(issues: [AccessibilityAuditIssueData]) {
        self.issues = issues
    }
}

public struct UIResponse<T: Codable>: Codable {
    
    public let response: Response<T>
    
    public init(response: T) {
        self.response = .success(data: response)
    }
    
    public init(error: String) {
        self.response = .error(error: ErrorResponse(error: error))
    }
    
    enum CodingKeys: CodingKey {
        case data
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let error = try container.decodeIfPresent(ErrorResponse.self, forKey: .error) {
            self.response = .error(error: error)
        } else if let response = try container.decodeIfPresent(T.self, forKey: .data) {
            self.response = .success(data: response)
        } else {
            fatalError("Invalid response")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self.response {
        case .error(error: let error):
            try container.encode(error, forKey: .error)
        case .success(data: let data):
            try container.encode(data, forKey: .data)
        }
    }
    
}

extension UIResponse: Sendable where T: Sendable {
    
}

public enum Response<T: Codable> {
    case error(error: ErrorResponse)
    case success(data: T)
}

extension Response: Sendable where T: Sendable {
    
}

public struct ErrorResponse: Codable, Sendable {
    public var error: String
}

public enum SizeClass: Int, Codable, Sendable {
    case unspecified = 0
    case compact     = 1
    case regular     = 2
}
