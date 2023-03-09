//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 9/3/2023.
//

import Foundation

extension Query {
    public func enterText(_ textToEnter: String) async throws {
        let activateRequestData = EnterTextRequest(matchers: self.matchers, textToEnter: textToEnter)
        let _: Bool = try await callServer(path: "enterText", request: activateRequestData)
    }
}
