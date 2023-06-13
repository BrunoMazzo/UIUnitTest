import Foundation


public struct ExistsResponse: Codable {
    public var exists: Bool
    
    public init(exists: Bool) {
        self.exists = exists
    }
}

public struct ValueResponse: Codable {
    public var value: String?
    
    public init(value: String?) {
        self.value = value
    }
}

public struct ElementRequest: Codable {
    public var elementServerId: UUID
    
    init(elementServerId: UUID) {
        self.elementServerId = elementServerId
    }
}

public struct IsHittableResponse: Codable {
    public var isHittable: Bool
    
    public init(isHittable: Bool) {
        self.isHittable = isHittable
    }
}
