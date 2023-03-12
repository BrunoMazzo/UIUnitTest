import Foundation

public class App {

    public init(appId: String) async throws {
        let activateRequestData = ActivateRequest(appId: appId)
        
        let _: Bool = try await callServer(path: "Activate", request: activateRequestData)
    }
    
    public func activityIndicators(identifier: String) -> Query {
        Query(matchers: [.activityIndicators(identifier: identifier)])
    }
    
    public func button(identifier: String) -> Query {
        Query(matchers: [.button(identifier: identifier)])
    }
    
    public func cells(identifier: String) -> Query {
        Query(matchers: [.cells(identifier: identifier)])
    }
    
    public func checkBoxes(identifier: String) -> Query {
        Query(matchers: [.checkBoxes(identifier: identifier)])
    }
    
    public func collectionViews(identifier: String) -> Query {
        Query(matchers: [.collectionViews(identifier: identifier)])
    }
    
    public func colorWells(identifier: String) -> Query {
        Query(matchers: [.colorWells(identifier: identifier)])
    }
    
    public func comboBoxes(identifier: String) -> Query {
        Query(matchers: [.comboBoxes(identifier: identifier)])
    }
    
    public func datePickers(identifier: String) -> Query {
        Query(matchers: [.datePickers(identifier: identifier)])
    }
    
    public func decrementArrows(identifier: String) -> Query {
        Query(matchers: [.decrementArrows(identifier: identifier)])
    }
    
    public func dialogs(identifier: String) -> Query {
        Query(matchers: [.dialogs(identifier: identifier)])
    }
    
    public func disclosureTriangles(identifier: String) -> Query {
        Query(matchers: [.disclosureTriangles(identifier: identifier)])
    }
    
    public func disclosedChildRows(identifier: String) -> Query {
        Query(matchers: [.disclosedChildRows(identifier: identifier)])
    }
    
    public func dockItems(identifier: String) -> Query {
        Query(matchers: [.dockItems(identifier: identifier)])
    }
    
    public func drawers(identifier: String) -> Query {
        Query(matchers: [.drawers(identifier: identifier)])
    }
    
    public func grids(identifier: String) -> Query {
        Query(matchers: [.grids(identifier: identifier)])
    }
    
    public func groups(identifier: String) -> Query {
        Query(matchers: [.groups(identifier: identifier)])
    }
    
    public func handles(identifier: String) -> Query {
        Query(matchers: [.handles(identifier: identifier)])
    }
    
    public func helpTags(identifier: String) -> Query {
        Query(matchers: [.helpTags(identifier: identifier)])
    }
    
    public func icons(identifier: String) -> Query {
        Query(matchers: [.icons(identifier: identifier)])
    }
    
    public func images(identifier: String) -> Query {
        Query(matchers: [.images(identifier: identifier)])
    }
    
    public func tables(identifier: String) -> Query {
        Query(matchers: [.tables(identifier: identifier)])
    }
    
    public func staticText(label: String) -> Query {
        Query(matchers: [.staticText(label: label)])
    }
    
    public func textField(identifier: String) -> Query {
        Query(matchers: [.textField(identifier: identifier)])
    }
}

public enum Response {
    case error(error: ErrorResponse)
    case success(data: Codable)
}

public struct ErrorResponse: Codable {
    var error: String
}

public struct UIResponse<T: Codable>: Codable {

    public let response: Response
    
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

internal func callServer<RequestData: Codable, ResponseData: Codable>(path: String, request: RequestData) async throws -> ResponseData {
    let encoder = JSONEncoder()
    
    let activateUrl = URL(string: "http://localhost:22087/\(path)")!
    var activateRequest = URLRequest(url: activateUrl)
    activateRequest.httpMethod = "POST"
    activateRequest.httpBody = try encoder.encode(request)
    
    let (data, _) = try await URLSession.shared.data(for: activateRequest)
    
    let decoder = JSONDecoder()
    
    let result = try decoder.decode(UIResponse<ResponseData>.self, from: data)
    
    switch result.response {
    case .success(data: let response):
        return response as! ResponseData
    case .error(error: let error):
        
        print(error.error)
        
        throw NSError(domain: "Test", code: 1, userInfo: ["reason": error])
    }
}

public struct ActivateRequest: Codable {
    public var appId: String
    
    public init(appId: String) {
        self.appId = appId
    }
}

public enum ElementMatcher: Codable {
    case activityIndicators(identifier: String)
    case button(identifier: String)
    case cells(identifier: String)
    case checkBoxes(identifier: String)
    case collectionViews(identifier: String)
    case colorWells(identifier: String)
    case comboBoxes(identifier: String)
    case datePickers(identifier: String)
    case decrementArrows(identifier: String)
    case dialogs(identifier: String)
    case disclosureTriangles(identifier: String)
    case disclosedChildRows(identifier: String)
    case dockItems(identifier: String)
    case drawers(identifier: String)
    case grids(identifier: String)
    case groups(identifier: String)
    case handles(identifier: String)
    case helpTags(identifier: String)
    case icons(identifier: String)
    case images(identifier: String)
    case tables(identifier: String)
    case staticText(label: String)
    case textField(identifier: String)
}

public struct EnterTextRequest: Codable {
    public var matchers: [ElementMatcher]
    
    public var textToEnter: String
    
    public init(matchers: [ElementMatcher], textToEnter: String) {
        self.matchers = matchers
        self.textToEnter = textToEnter
    }
}
