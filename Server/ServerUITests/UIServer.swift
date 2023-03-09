import FlyingFox
import XCTest
import Foundation
import UIUnitTest

class UIServer {
    var app: XCUIApplication!
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    var lastIssue: XCTIssue?
    
    func start() async throws {
        let server = HTTPServer(address: .loopback(port: 22087))
        
        await server.appendRoute(HTTPRoute(stringLiteral: "Activate")) { request in
            
            defer {
                self.lastIssue = nil
            }
            
            let activateRequest = try self.decoder.decode(ActivateRequest.self, from: request.body)
            
            await MainActor.run {
                self.app = XCUIApplication(bundleIdentifier: activateRequest.appId)
                
                self.app.activate()
            }
            
            
            return self.buildResponse()
        }
        
        await server.appendRoute(HTTPRoute(stringLiteral: "Tap")) { request in
            
            defer {
                self.lastIssue = nil
            }
            
            let tapRequest = try self.decoder.decode(TapRequest.self, from: request.body)
            
            await MainActor.run {
                let element = self.findElement(matchers: tapRequest.matchers)
                
                element?.tap()
            }
            
            return self.buildResponse()
        }
        
        await server.appendRoute(HTTPRoute(stringLiteral: "exists")) { request in
            
            defer {
                self.lastIssue = nil
            }
            
            let tapRequest = try self.decoder.decode(ExistsRequest.self, from: request.body)
            
            let exists = await MainActor.run {
                let element = self.findElement(matchers: tapRequest.matchers)
                
                return element?.exists ?? false
            }
            
                return self.buildResponse(ExistsResponse(exists: exists))
        }
        
        await server.appendRoute(HTTPRoute(stringLiteral: "enterText")) { request in
            
            defer {
                self.lastIssue = nil
            }
            
            let tapRequest = try self.decoder.decode(EnterTextRequest.self, from: request.body)
            
            await MainActor.run {
                let element = self.findElement(matchers: tapRequest.matchers)
                
                return element?.typeText(tapRequest.textToEnter)
            }
            
            return self.buildResponse()
        }
                
        try await server.start()
    }
    
    func buildResponse() -> HTTPResponse {
        if let lastIssue {
            return buildError(lastIssue.detailedDescription ?? lastIssue.description)
        } else {
            return buildResponse(true)
        }
    }
    
    func buildResponse(_ data: some Codable) -> HTTPResponse {
        return HTTPResponse(statusCode: .ok, body: try! self.encoder.encode(UIResponse(response: data)))
    }
    
    func buildError(_ error: String) -> HTTPResponse {
        return HTTPResponse(statusCode: .badRequest, body: try! self.encoder.encode(UIResponse<Bool>(error: error)))
    }
    
    func findElement(matchers: [ElementMatcher]) -> XCUIElement? {
        var matchedElement: XCUIElement? = app
        
        for matcher in matchers {
            switch matcher {
            case .button(let identifier):
                matchedElement = matchedElement?.buttons[identifier]
            case .staticText(label: let label):
                matchedElement = matchedElement?.staticTexts[label]
            case .textField(identifier: let identifier):
                matchedElement = matchedElement?.textFields[identifier]
            }
        }
        
        return matchedElement
    }
}
