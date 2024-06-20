import Foundation

public protocol ElementTypeQueryProvider: Sendable {
    var serverId: UUID { get }
}

public extension ElementTypeQueryProvider {
    
    func firstMatch() async throws -> Element  {
        let elementResponse: FirstMatchResponse = try await callServer(path: "firstMatch", request: FirstMatchRequest(serverId: self.serverId))
        return Element(serverId: elementResponse.serverId)
    }
    
    func callAsFunction(_ dynamicMember: Query.QueryType) async throws -> Query {
        try await Query(serverId: self.serverId, queryType: dynamicMember)
    }
    
    func activityIndicators() async throws -> Query  {
        try await self(.activityIndicators)
    }
    
    func activityIndicators(_ identifier: String) async throws -> Element {
        try await self(.activityIndicators)(identifier: identifier)
    }
    
    func alerts() async throws -> Query  {
        try await self(.alerts)
    }
    
    func browsers() async throws -> Query{
        try await self(.browsers)
    }
    
    func browsers(_ identifier: String) async throws -> Element {
        try await self(.browsers)(identifier: identifier)
    }
    
    func buttons() async throws -> Query{
        try await self(.buttons)
    }
    
    func buttons(_ identifier: String) async throws -> Element {
        try await self(.buttons)(identifier: identifier)
    }
    
    func cells() async throws -> Query{
        try await self(.cells)
    }
    
    func cells(_ identifier: String) async throws -> Element {
        try await self(.cells)(identifier: identifier)
    }
    
    func checkBoxes() async throws -> Query {
        try await self(.checkBoxes)
    }
    
    func checkBoxes(_ identifier: String) async throws -> Element {
        try await self(.checkBoxes)(identifier: identifier)
    }
    
    func collectionViews() async throws -> Query{
        try await self(.collectionViews)
    }
    
    func collectionViews(_ identifier: String) async throws -> Element {
        try await self(.collectionViews)(identifier: identifier)
    }
    
    func colorWells() async throws -> Query{
        try await self(.colorWells)
    }
    
    func colorWells(_ identifier: String) async throws -> Element {
        try await self(.colorWells)(identifier: identifier)
    }
    
    func comboBoxes() async throws -> Query{
        try await self(.comboBoxes)
    }
    
    func comboBoxes(_ identifier: String) async throws -> Element {
        try await self(.comboBoxes)(identifier: identifier)
    }
    
    func datePickers() async throws -> Query{
        try await self(.datePickers)
    }
    
    func datePickers(_ identifier: String) async throws -> Element {
        try await self(.datePickers)(identifier: identifier)
    }
    
    func decrementArrows() async throws -> Query{
        try await self(.decrementArrows)
    }
    
    func decrementArrows(_ identifier: String) async throws -> Element {
        try await self(.decrementArrows)(identifier: identifier)
    }
    
    func dialogs() async throws -> Query{
        try await self(.dialogs)
    }
    
    func dialogs(_ identifier: String) async throws -> Element {
        try await self(.dialogs)(identifier: identifier)
    }
    
    func disclosureTriangles() async throws -> Query{
        try await self(.disclosureTriangles)
    }
    
    func disclosureTriangles(_ identifier: String) async throws -> Element {
        try await self(.disclosureTriangles)(identifier: identifier)
    }
    
    func disclosedChildRows() async throws -> Query{
        try await self(.disclosedChildRows)
    }
    
    func disclosedChildRows(_ identifier: String) async throws -> Element {
        try await self(.disclosedChildRows)(identifier: identifier)
    }
    
    func dockItems() async throws -> Query{
        try await self(.dockItems)
    }
    
    func dockItems(_ identifier: String) async throws -> Element {
        try await self(.dockItems)(identifier: identifier)
    }
    
    func drawers() async throws -> Query{
        try await self(.drawers)
    }
    
    func drawers(_ identifier: String) async throws -> Element {
        try await self(.drawers)(identifier: identifier)
    }
    
    func grids() async throws -> Query{
        try await self(.grids)
    }
    
    func grids(_ identifier: String) async throws -> Element {
        try await self(.grids)(identifier: identifier)
    }
    
    func groups() async throws -> Query{
        try await self(.groups)
    }
    
    func groups(_ identifier: String) async throws -> Element {
        try await self(.groups)(identifier: identifier)
    }
    
    func handles() async throws -> Query{
        try await self(.handles)
    }
    
    func handles(_ identifier: String) async throws -> Element {
        try await self(.handles)(identifier: identifier)
    }
    
    func helpTags() async throws -> Query{
        try await self(.helpTags)
    }
    
    func helpTags(_ identifier: String) async throws -> Element {
        try await self(.helpTags)(identifier: identifier)
    }
    
    func icons() async throws -> Query{
        try await self(.icons)
    }
    
    func icons(_ identifier: String) async throws -> Element {
        try await self(.icons)(identifier: identifier)
    }
    
    func images() async throws -> Query{
        try await self(.images)
    }
    
    func images(_ identifier: String) async throws -> Element {
        try await self(.images)(identifier: identifier)
    }
    
    func incrementArrows() async throws -> Query{
        try await self(.incrementArrows)
    }
    
    func incrementArrows(_ identifier: String) async throws -> Element {
        try await self(.incrementArrows)(identifier: identifier)
    }
    
    func keyboards() async throws -> Query{
        try await self(.keyboards)
    }
    
    func keyboards(_ identifier: String) async throws -> Element {
        try await self(.keyboards)(identifier: identifier)
    }
    
    func keys() async throws -> Query{
        try await self(.keys)
    }
    
    func keys(_ identifier: String) async throws -> Element {
        try await self(.keys)(identifier: identifier)
    }
    
    func layoutAreas() async throws -> Query{
        try await self(.layoutAreas)
    }
    
    func layoutAreas(_ identifier: String) async throws -> Element {
        try await self(.layoutAreas)(identifier: identifier)
    }
    
    func layoutItems() async throws -> Query{
        try await self(.layoutItems)
    }
    
    func layoutItems(_ identifier: String) async throws -> Element {
        try await self(.layoutItems)(identifier: identifier)
    }
    
    func levelIndicators() async throws -> Query{
        try await self(.levelIndicators)
    }
    
    func levelIndicators(_ identifier: String) async throws -> Element {
        try await self(.levelIndicators)(identifier: identifier)
    }
    
    func links() async throws -> Query{
        try await self(.links)
    }
    
    func links(_ identifier: String) async throws -> Element {
        try await self(.links)(identifier: identifier)
    }
    
    func maps() async throws -> Query{
        try await self(.maps)
    }
    
    func maps(_ identifier: String) async throws -> Element {
        try await self(.maps)(identifier: identifier)
    }
    
    func mattes() async throws -> Query{
        try await self(.mattes)
    }
    
    func mattes(_ identifier: String) async throws -> Element {
        try await self(.mattes)(identifier: identifier)
    }
    
    func menuBarItems() async throws -> Query{
        try await self(.menuBarItems)
    }
    
    func menuBarItems(_ identifier: String) async throws -> Element {
        try await self(.menuBarItems)(identifier: identifier)
    }
    
    func menuBars() async throws -> Query{
        try await self(.menuBars)
    }
    
    func menuBars(_ identifier: String) async throws -> Element {
        try await self(.menuBars)(identifier: identifier)
    }
    
    func menuButtons() async throws -> Query{
        try await self(.menuButtons)
    }
    
    func menuButtons(_ identifier: String) async throws -> Element {
        try await self(.menuButtons)(identifier: identifier)
    }
    
    func menuItems() async throws -> Query{
        try await self(.menuItems)
    }
    
    func menuItems(_ identifier: String) async throws -> Element {
        try await self(.menuItems)(identifier: identifier)
    }
    
    func menus() async throws -> Query{
        try await self(.menus)
    }
    
    func menus(_ identifier: String) async throws -> Element {
        try await self(.menus)(identifier: identifier)
    }
    
    func navigationBars() async throws -> Query{
        try await self(.navigationBars)
    }
    
    func navigationBars(_ identifier: String) async throws -> Element {
        try await self(.navigationBars)(identifier: identifier)
    }
    
    func otherElements() async throws -> Query{
        try await self(.otherElements)
    }
    
    func otherElements(_ identifier: String) async throws -> Element {
        try await self(.otherElements)(identifier: identifier)
    }
    
    func outlineRows() async throws -> Query{
        try await self(.outlineRows)
    }
    
    func outlineRows(_ identifier: String) async throws -> Element {
        try await self(.outlineRows)(identifier: identifier)
    }
    
    func outlines() async throws -> Query{
        try await self(.outlines)
    }
    
    func outlines(_ identifier: String) async throws -> Element {
        try await self(.outlines)(identifier: identifier)
    }
    
    func pageIndicators() async throws -> Query{
        try await self(.pageIndicators)
    }
    
    func pageIndicators(_ identifier: String) async throws -> Element {
        try await self(.pageIndicators)(identifier: identifier)
    }
    
    func pickerWheels() async throws -> Query{
        try await self(.pickerWheels)
    }
    
    func pickerWheels(_ identifier: String) async throws -> Element {
        try await self(.pickerWheels)(identifier: identifier)
    }
    
    func pickers() async throws -> Query{
        try await self(.pickers)
    }
    
    func pickers(_ identifier: String) async throws -> Element {
        try await self(.pickers)(identifier: identifier)
    }
    
    func popUpButtons() async throws -> Query{
        try await self(.popUpButtons)
    }
    
    func popUpButtons(_ identifier: String) async throws -> Element {
        try await self(.popUpButtons)(identifier: identifier)
    }
    
    func popovers() async throws -> Query{
        try await self(.popovers)
    }
    
    func popovers(_ identifier: String) async throws -> Element {
        try await self(.popovers)(identifier: identifier)
    }
    
    func progressIndicators() async throws -> Query{
        try await self(.progressIndicators)
    }
    
    func progressIndicators(_ identifier: String) async throws -> Element {
        try await self(.progressIndicators)(identifier: identifier)
    }
    
    func radioButtons() async throws -> Query{
        try await self(.radioButtons)
    }
    
    func radioButtons(_ identifier: String) async throws -> Element {
        try await self(.radioButtons)(identifier: identifier)
    }
    
    func radioGroups() async throws -> Query{
        try await self(.radioGroups)
    }
    
    func radioGroups(_ identifier: String) async throws -> Element {
        try await self(.radioGroups)(identifier: identifier)
    }
    
    func ratingIndicators() async throws -> Query{
        try await self(.ratingIndicators)
    }
    
    func ratingIndicators(_ identifier: String) async throws -> Element {
        try await self(.ratingIndicators)(identifier: identifier)
    }
    
    func relevanceIndicators() async throws -> Query{
        try await self(.relevanceIndicators)
    }
    
    func relevanceIndicators(_ identifier: String) async throws -> Element {
        try await self(.relevanceIndicators)(identifier: identifier)
    }
    
    func rulerMarkers() async throws -> Query{
        try await self(.rulerMarkers)
    }
    
    func rulerMarkers(_ identifier: String) async throws -> Element {
        try await self(.rulerMarkers)(identifier: identifier)
    }
    
    func rulers() async throws -> Query{
        try await self(.rulers)
    }
    
    func rulers(_ identifier: String) async throws -> Element {
        try await self(.rulers)(identifier: identifier)
    }
    
    func scrollBars() async throws -> Query{
        try await self(.scrollBars)
    }
    
    func scrollBars(_ identifier: String) async throws -> Element {
        try await self(.scrollBars)(identifier: identifier)
    }
    
    func scrollViews() async throws -> Query{
        try await self(.scrollViews)
    }
    
    func scrollViews(_ identifier: String) async throws -> Element {
        try await self(.scrollViews)(identifier: identifier)
    }
    func searchFields() async throws -> Query{
        try await self(.searchFields)
    }
    
    func searchFields(_ identifier: String) async throws -> Element {
        try await self(.searchFields)(identifier: identifier)
    }
    
    func secureTextFields() async throws -> Query{
        try await self(.secureTextFields)
    }
    
    func secureTextFields(_ identifier: String) async throws -> Element {
        try await self(.secureTextFields)(identifier: identifier)
    }
    
    func segmentedControls() async throws -> Query{
        try await self(.segmentedControls)
    }
    
    func segmentedControls(_ identifier: String) async throws -> Element {
        try await self(.segmentedControls)(identifier: identifier)
    }
    
    func sheets() async throws -> Query{
        try await self(.sheets)
    }
    
    func sheets(_ identifier: String) async throws -> Element {
        try await self(.sheets)(identifier: identifier)
    }
    
    func sliders() async throws -> Query{
        try await self(.sliders)
    }
    
    func sliders(_ identifier: String) async throws -> Element {
        try await self(.sliders)(identifier: identifier)
    }
    
    func splitGroups() async throws -> Query{
        try await self(.splitGroups)
    }
    
    func splitGroups(_ identifier: String) async throws -> Element {
        try await self(.splitGroups)(identifier: identifier)
    }
    
    func splitters() async throws -> Query{
        try await self(.splitters)
    }
    
    func splitters(_ identifier: String) async throws -> Element {
        try await self(.splitters)(identifier: identifier)
    }
    
    func staticTexts() async throws -> Query{
        try await self(.staticTexts)
    }
    
    func staticTexts(_ identifier: String) async throws -> Element {
        try await self(.staticTexts)(identifier: identifier)
    }
    
    func statusBars() async throws -> Query{
        try await self(.statusBars)
    }
    
    func statusBars(_ identifier: String) async throws -> Element {
        try await self(.statusBars)(identifier: identifier)
    }
    
    func statusItems() async throws -> Query{
        try await self(.statusItems)
    }
    
    func statusItems(_ identifier: String) async throws -> Element {
        try await self(.statusItems)(identifier: identifier)
    }
    
    func steppers() async throws -> Query{
        try await self(.steppers)
    }
    
    func steppers(_ identifier: String) async throws -> Element {
        try await self(.steppers)(identifier: identifier)
    }
    
    func switches() async throws -> Query{
        try await self(.switches)
    }
    
    func switches(_ identifier: String) async throws -> Element {
        try await self(.switches)(identifier: identifier)
    }
    
    func tabBars() async throws -> Query{
        try await self(.tabBars)
    }
    
    func tabBars(_ identifier: String) async throws -> Element {
        try await self(.tabBars)(identifier: identifier)
    }
    
    func tabGroups() async throws -> Query{
        try await self(.tabGroups)
    }
    
    func tabGroups(_ identifier: String) async throws -> Element {
        try await self(.tabGroups)(identifier: identifier)
    }
    
    func tableColumns() async throws -> Query{
        try await self(.tableColumns)
    }
    
    func tableColumns(_ identifier: String) async throws -> Element {
        try await self(.tableColumns)(identifier: identifier)
    }
    
    func tableRows() async throws -> Query{
        try await self(.tableRows)
    }
    
    func tableRows(_ identifier: String) async throws -> Element {
        try await self(.tableRows)(identifier: identifier)
    }
    
    func tables() async throws -> Query{
        try await self(.tables)
    }
    
    func tables(_ identifier: String) async throws -> Element {
        try await self(.tables)(identifier: identifier)
    }
    
    func textFields() async throws -> Query{
        try await self(.textFields)
    }
    
    func textFields(_ identifier: String) async throws -> Element {
        try await self(.textFields)(identifier: identifier)
    }
    
    func textViews() async throws -> Query{
        try await self(.textViews)
    }
    
    func textViews(_ identifier: String) async throws -> Element {
        try await self(.textViews)(identifier: identifier)
    }
    
    func timelines() async throws -> Query{
        try await self(.timelines)
    }
    
    func timelines(_ identifier: String) async throws -> Element {
        try await self(.timelines)(identifier: identifier)
    }
    
    func toggles() async throws -> Query{
        try await self(.toggles)
    }
    
    func toggles(_ identifier: String) async throws -> Element {
        try await self(.toggles)(identifier: identifier)
    }
    
    func toolbarButtons() async throws -> Query{
        try await self(.toolbarButtons)
    }
    
    func toolbarButtons(_ identifier: String) async throws -> Element {
        try await self(.toolbarButtons)(identifier: identifier)
    }
    
    func toolbars() async throws -> Query{
        try await self(.toolbars)
    }
    
    func toolbars(_ identifier: String) async throws -> Element {
        try await self(.toolbars)(identifier: identifier)
    }
    
    func touchBars() async throws -> Query{
        try await self(.touchBars)
    }
    
    func touchBars(_ identifier: String) async throws -> Element {
        try await self(.touchBars)(identifier: identifier)
    }
    
    func valueIndicators() async throws -> Query  {
        try await self(.valueIndicators)
    }
    
    func webViews() async throws -> Query  {
        try await self(.webViews)
    }
    
    func windows() async throws -> Query  {
        try await self(.windows)
    }
}

public struct FirstMatchRequest: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct FirstMatchResponse: Codable, Sendable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}
