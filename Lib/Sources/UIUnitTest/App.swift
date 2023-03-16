import Foundation

public class App: ElementTypeQueryProvider {
    public var queryServerId: UUID? = nil

    let appId: String
    
    public init(appId: String) async throws {
        self.appId = appId
        try await self.activate()
    }
    
    public func pressHomeButton() async throws {
        let _: Bool = try await callServer(path: "HomeButton", request: HomeButtonRequest())
    }
    
    public func activate() async throws {
        let activateRequestData = ActivateRequest(appId: appId)
        
        let _: Bool = try await callServer(path: "Activate", request: activateRequestData)
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


public struct HomeButtonRequest: Codable {
    
}

public enum ElementMatcher: Codable {
    case activityIndicators(identifier: String)
    case alerts(identifier: String)
    case browsers(identifier: String)
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
    case incrementArrows(identifier: String)
    case keyboards(identifier: String)
    case keys(identifier: String)
    case layoutAreas(identifier: String)
    case layoutItems(identifier: String)
    case levelIndicators(identifier: String)
    case links(identifier: String)
    case maps(identifier: String)
    case mattes(identifier: String)
    case menuBarItems(identifier: String)
    case menuBars(identifier: String)
    case menuButtons(identifier: String)
    case menuItems(identifier: String)
    case menus(identifier: String)
    case navigationBars(identifier: String)
    case otherElements(identifier: String)
    case outlineRows(identifier: String)
    case outlines(identifier: String)
    case pageIndicators(identifier: String)
    case pickerWheels(identifier: String)
    case pickers(identifier: String)
    case popUpButtons(identifier: String)
    case popovers(identifier: String)
    case progressIndicators(identifier: String)
    case radioButtons(identifier: String)
    case radioGroups(identifier: String)
    case ratingIndicators(identifier: String)
    case relevanceIndicators(identifier: String)
    case rulerMarkers(identifier: String)
    case rulers(identifier: String)
    case scrollBars(identifier: String)
    case scrollViews(identifier: String)
    case searchFields(identifier: String)
    case secureTextFields(identifier: String)
    case segmentedControls(identifier: String)
    case sheets(identifier: String)
    case sliders(identifier: String)
    case splitGroups(identifier: String)
    case splitters(identifier: String)
    case staticText(label: String)
    case statusBars(identifier: String)
    case statusItems(identifier: String)
    case steppers(identifier: String)
    case switches(identifier: String)
    case tabBars(identifier: String)
    case tabGroups(identifier: String)
    case tableColumns(identifier: String)
    case tableRows(identifier: String)
    case tables(identifier: String)
    case textField(identifier: String)
    case textViews(identifier: String)
    case timelines(identifier: String)
    case toggles(identifier: String)
    case toolbarButtons(identifier: String)
    case toolbars(identifier: String)
    case touchBars(identifier: String)
    case valueIndicators(identifier: String)
    case webViews(identifier: String)
    case windows(identifier: String)
}

public struct EnterTextRequest: Codable {
    
    public var elementServerId: UUID
    public var textToEnter: String
    
    public init(elementServerId: UUID, textToEnter: String) {
        self.elementServerId = elementServerId
        self.textToEnter = textToEnter
    }
}
