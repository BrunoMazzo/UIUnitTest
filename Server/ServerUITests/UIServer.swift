import FlyingFox
import XCTest
import Foundation
import UIUnitTest

@MainActor
class UIServer {
    var app: XCUIApplication!
    
    func start() async throws {
        let server = HTTPServer(address: .loopback(port: 22087))
        
        await server.appendRoute(HTTPRoute(stringLiteral: "Activate")) { request in
            
            let decoder = JSONDecoder()
            
            let activateRequest = try decoder.decode(ActivateRequest.self, from: request.body)
            
            await MainActor.run {
                self.app = XCUIApplication(bundleIdentifier: activateRequest.appId)
                
                self.app.activate()
            }
            
            
            return HTTPResponse(statusCode: .ok)
        }
        
        await server.appendRoute(HTTPRoute(stringLiteral: "Tap")) { request in
            
            let decoder = JSONDecoder()
            
            let tapRequest = try decoder.decode(TapRequest.self, from: request.body)
            
            await MainActor.run {
                let element = self.findElement(matchers: tapRequest.matchers)
                
                element?.tap()
            }
            
            return HTTPResponse(statusCode: .ok)
        }
        
        await server.appendRoute(HTTPRoute(stringLiteral: "exists")) { request in
            
            let decoder = JSONDecoder()
            
            let tapRequest = try decoder.decode(ExistsRequest.self, from: request.body)
            
            let exists = await MainActor.run {
                let element = self.findElement(matchers: tapRequest.matchers)
                
                return element?.exists ?? false
            }
            
            let encoder = JSONEncoder()
            
            return HTTPResponse(statusCode: .ok, body: try! encoder.encode(ExistsResponse(exists: exists)))
        }
                
        try await server.start()
    }
    
    func findElement(matchers: [ElementMatcher]) -> XCUIElement? {
        var matchedElement: XCUIElement? = app
        
        for matcher in matchers {
            switch matcher {
            case .button(let identifier):
                matchedElement = matchedElement?.buttons[identifier]
            case .staticText(label: let label):
                matchedElement = matchedElement?.staticTexts[label]
            }
        }
        
        return matchedElement
    }
}
