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
    public var serverId: UUID
    
    init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct IsHittableResponse: Codable {
    public var isHittable: Bool
    
    public init(isHittable: Bool) {
        self.isHittable = isHittable
    }
}
