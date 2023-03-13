import Foundation

public class App {

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
    
    public func activityIndicators(identifier: String) -> Query {
        Query(matchers: [.activityIndicators(identifier: identifier)])
    }
    
    public func alerts(identifier: String) -> Query {
        Query(matchers: [.alerts(identifier: identifier)])
    }
    
    public func browsers(identifier: String) -> Query {
        Query(matchers: [.browsers(identifier: identifier)])
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
    
    public func incrementArrows(identifier: String) -> Query {
        Query(matchers: [.incrementArrows(identifier: identifier)])
    }
    
    public func keyboards(identifier: String) -> Query {
        Query(matchers: [.keyboards(identifier: identifier)])
    }
    
    public func keys(identifier: String) -> Query {
        Query(matchers: [.keys(identifier: identifier)])
    }
    
    public func layoutAreas(identifier: String) -> Query {
        Query(matchers: [.layoutAreas(identifier: identifier)])
    }
    
    public func layoutItems(identifier: String) -> Query {
        Query(matchers: [.layoutItems(identifier: identifier)])
    }
    
    public func levelIndicators(identifier: String) -> Query {
        Query(matchers: [.levelIndicators(identifier: identifier)])
    }
    
    public func links(identifier: String) -> Query {
        Query(matchers: [.links(identifier: identifier)])
    }
    
    public func maps(identifier: String) -> Query {
        Query(matchers: [.maps(identifier: identifier)])
    }
    
    public func mattes(identifier: String) -> Query {
        Query(matchers: [.mattes(identifier: identifier)])
    }
    
    public func menuBarItems(identifier: String) -> Query {
        Query(matchers: [.menuBarItems(identifier: identifier)])
    }
    
    public func menuBars(identifier: String) -> Query {
        Query(matchers: [.menuBars(identifier: identifier)])
    }
    
    public func menuButtons(identifier: String) -> Query {
        Query(matchers: [.menuButtons(identifier: identifier)])
    }
    
    public func menuItems(identifier: String) -> Query {
        Query(matchers: [.menuItems(identifier: identifier)])
    }
    
    public func menus(identifier: String) -> Query {
        Query(matchers: [.menus(identifier: identifier)])
    }
    
    public func navigationBars(identifier: String) -> Query {
        Query(matchers: [.navigationBars(identifier: identifier)])
    }
    
    public func otherElements(identifier: String) -> Query {
        Query(matchers: [.otherElements(identifier: identifier)])
    }
    
    public func outlineRows(identifier: String) -> Query {
        Query(matchers: [.outlineRows(identifier: identifier)])
    }
    
    public func outlines(identifier: String) -> Query {
        Query(matchers: [.outlines(identifier: identifier)])
    }
    
    public func pageIndicators(identifier: String) -> Query {
        Query(matchers: [.pageIndicators(identifier: identifier)])
    }
    
    public func pickerWheels(identifier: String) -> Query {
        Query(matchers: [.pickerWheels(identifier: identifier)])
    }
    
    public func pickers(identifier: String) -> Query {
        Query(matchers: [.pickers(identifier: identifier)])
    }
    
    public func popUpButtons(identifier: String) -> Query {
        Query(matchers: [.popUpButtons(identifier: identifier)])
    }
    
    public func popovers(identifier: String) -> Query {
        Query(matchers: [.popovers(identifier: identifier)])
    }
    
    public func progressIndicators(identifier: String) -> Query {
        Query(matchers: [.progressIndicators(identifier: identifier)])
    }
    
    public func radioButtons(identifier: String) -> Query {
        Query(matchers: [.radioButtons(identifier: identifier)])
    }
    
    public func radioGroups(identifier: String) -> Query {
        Query(matchers: [.radioGroups(identifier: identifier)])
    }
    
    public func ratingIndicators(identifier: String) -> Query {
        Query(matchers: [.ratingIndicators(identifier: identifier)])
    }
    
    public func relevanceIndicators(identifier: String) -> Query {
        Query(matchers: [.relevanceIndicators(identifier: identifier)])
    }
    
    public func rulerMarkers(identifier: String) -> Query {
        Query(matchers: [.rulerMarkers(identifier: identifier)])
    }
    
    public func rulers(identifier: String) -> Query {
        Query(matchers: [.rulers(identifier: identifier)])
    }
    
    public func scrollBars(identifier: String) -> Query {
        Query(matchers: [.scrollBars(identifier: identifier)])
    }
    
    public func scrollViews(identifier: String) -> Query {
        Query(matchers: [.scrollViews(identifier: identifier)])
    }
    
    public func searchFields(identifier: String) -> Query {
        Query(matchers: [.searchFields(identifier: identifier)])
    }
    
    public func secureTextFields(identifier: String) -> Query {
        Query(matchers: [.secureTextFields(identifier: identifier)])
    }
    
    public func segmentedControls(identifier: String) -> Query {
        Query(matchers: [.segmentedControls(identifier: identifier)])
    }
    
    public func sheets(identifier: String) -> Query {
        Query(matchers: [.sheets(identifier: identifier)])
    }
    
    public func sliders(identifier: String) -> Query {
        Query(matchers: [.sliders(identifier: identifier)])
    }
    
    public func splitGroups(identifier: String) -> Query {
        Query(matchers: [.splitGroups(identifier: identifier)])
    }
    
    public func splitters(identifier: String) -> Query {
        Query(matchers: [.splitters(identifier: identifier)])
    }
    
    public func statusBars(identifier: String) -> Query {
        Query(matchers: [.statusBars(identifier: identifier)])
    }
    
    public func statusItems(identifier: String) -> Query {
        Query(matchers: [.statusItems(identifier: identifier)])
    }
    
    public func switches(identifier: String) -> Query {
        Query(matchers: [.switches(identifier: identifier)])
    }
    
    public func tabBars(identifier: String) -> Query {
        Query(matchers: [.tabBars(identifier: identifier)])
    }
    
    public func tabGroups(identifier: String) -> Query {
        Query(matchers: [.tabGroups(identifier: identifier)])
    }
    
    public func tableColumns(identifier: String) -> Query {
        Query(matchers: [.tableColumns(identifier: identifier)])
    }
    
    public func tableRows(identifier: String) -> Query {
        Query(matchers: [.tableRows(identifier: identifier)])
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
}

public struct EnterTextRequest: Codable {
    public var matchers: [ElementMatcher]
    
    public var textToEnter: String
    
    public init(matchers: [ElementMatcher], textToEnter: String) {
        self.matchers = matchers
        self.textToEnter = textToEnter
    }
}
