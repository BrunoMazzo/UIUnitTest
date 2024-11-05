import Foundation
import UIUnitTestAPI

public extension SyncElementTypeQueryProvider {

    @available(*, noasync)
    var firstMatch: SyncElement {
        Executor.execute {
            SyncElement(element: try await self.queryProvider.firstMatch())
        }.valueOrFailWithFallback(.EmptyElement)
    }
    
    @available(*, noasync)
    subscript(dynamicMember: QueryType) -> SyncQuery {
        Executor.execute {
            SyncQuery(query: try await Query(serverId: self.queryProvider.serverId, queryType: dynamicMember))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var activityIndicators: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.activityIndicators))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var alerts: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.alerts))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var browsers: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.browsers))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var buttons: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.buttons))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var cells: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.cells))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var checkBoxes: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.checkBoxes))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var collectionViews: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.collectionViews))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var colorWells: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.colorWells))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var comboBoxes: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.comboBoxes))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var datePickers: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.datePickers))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var decrementArrows: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.decrementArrows))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var dialogs: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.dialogs))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var disclosureTriangles: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.disclosureTriangles))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var disclosedChildRows: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.disclosedChildRows))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var dockItems: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.dockItems))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var drawers: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.drawers))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var grids: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.grids))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var groups: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.groups))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var handles: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.handles))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var helpTags: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.helpTags))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var icons: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.icons))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var images: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.images))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var incrementArrows: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.incrementArrows))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var keyboards: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.keyboards))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var keys: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.keys))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var layoutAreas: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.layoutAreas))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var layoutItems: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.layoutItems))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var levelIndicators: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.levelIndicators))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var links: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.links))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var maps: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.maps))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var mattes: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.mattes))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var menuBarItems: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.menuBarItems))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var menuBars: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.menuBars))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var menuButtons: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.menuButtons))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var menuItems: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.menuItems))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var menus: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.menus))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var navigationBars: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.navigationBars))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var otherElements: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.otherElements))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var outlineRows: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.outlineRows))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var outlines: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.outlines))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var pageIndicators: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.pageIndicators))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var pickerWheels: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.pickerWheels))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var pickers: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.pickers))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var popUpButtons: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.popUpButtons))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var popovers: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.popovers))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var progressIndicators: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.progressIndicators))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var radioButtons: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.radioButtons))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var radioGroups: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.radioGroups))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var ratingIndicators: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.ratingIndicators))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var relevanceIndicators: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.relevanceIndicators))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var rulerMarkers: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.rulerMarkers))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var rulers: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.rulers))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var scrollBars: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.scrollBars))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var scrollViews: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.scrollViews))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var searchFields: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.searchFields))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var secureTextFields: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.secureTextFields))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var segmentedControls: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.segmentedControls))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var sheets: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.sheets))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var sliders: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.sliders))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var splitGroups: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.splitGroups))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var splitters: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.splitters))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var staticTexts: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.staticTexts))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var statusBars: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.statusBars))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var statusItems: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.statusItems))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var steppers: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.steppers))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var switches: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.switches))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var tabBars: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.tabBars))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var tabGroups: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.tabGroups))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var tableColumns: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.tableColumns))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var tableRows: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.tableRows))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var tables: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.tables))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var textFields: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.textFields))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var textViews: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.textViews))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var timelines: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.timelines))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var toggles: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.toggles))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var toolbarButtons: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.toolbarButtons))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var toolbars: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.toolbars))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var touchBars: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.touchBars))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var valueIndicators: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.valueIndicators))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var webViews: SyncQuery {
        Executor.execute {
            SyncQuery(query:  try await self.queryProvider(.webViews))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    var windows: SyncQuery {
        Executor.execute {
            SyncQuery(query: try await self.queryProvider(.windows))
        }.valueOrFailWithFallback(.EmptyQuery)
    }
}
