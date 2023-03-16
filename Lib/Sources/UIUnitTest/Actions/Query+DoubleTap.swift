//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 10/3/2023.
//

import Foundation

extension Element {
    public func doubleTap() async throws {
        let activateRequestData = DoubleTapRequest(elementServerId: serverId)
        
        let _: Bool = try await callServer(path: "doubleTap", request: activateRequestData)
    }
}

public struct DoubleTapRequest: Codable {
    
    public var elementServerId: UUID
    
    public init(elementServerId: UUID) {
        self.elementServerId = elementServerId
    }
}
