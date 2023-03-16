import Foundation

public struct ExistsResponse: Codable {
    public var exists: Bool
    
    public init(exists: Bool) {
        self.exists = exists
    }
}

public struct ExistsRequest: Codable {
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

public struct IsHittableRequest: Codable {
    public var elementServerId: UUID
    
    init(elementServerId: UUID) {
        self.elementServerId = elementServerId
    }
}

