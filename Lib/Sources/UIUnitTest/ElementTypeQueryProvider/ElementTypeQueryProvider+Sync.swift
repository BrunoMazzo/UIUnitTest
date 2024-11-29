import Foundation
import UIUnitTestAPI

public extension SyncElementTypeQueryProvider {
    @available(*, noasync)
    var firstMatch: SyncElement {
        Executor.execute {
            try await SyncElement(element: self.queryProvider.firstMatch)
        }.valueOrFailWithFallback(.EmptyElement)
    }

    @available(*, noasync)
    subscript(dynamicMember: QueryType) -> SyncQuery {
        Executor.execute {
            try await SyncQuery(query: Query(serverId: self.queryProvider.serverId, queryType: dynamicMember))
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var activityIndicators: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.activityIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var alerts: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.alerts)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var browsers: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.browsers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var buttons: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.buttons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var cells: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.cells)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var checkBoxes: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.checkBoxes)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var collectionViews: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.collectionViews)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var colorWells: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.colorWells)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var comboBoxes: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.comboBoxes)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var datePickers: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.datePickers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var decrementArrows: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.decrementArrows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var dialogs: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.dialogs)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var disclosureTriangles: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.disclosureTriangles)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var disclosedChildRows: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.disclosedChildRows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var dockItems: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.dockItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var drawers: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.drawers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var grids: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.grids)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var groups: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.groups)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var handles: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.handles)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var helpTags: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.helpTags)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var icons: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.icons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var images: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.images)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var incrementArrows: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.incrementArrows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var keyboards: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.keyboards)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var keys: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.keys)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var layoutAreas: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.layoutAreas)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var layoutItems: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.layoutItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var levelIndicators: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.levelIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var links: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.links)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var maps: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.maps)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var mattes: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.mattes)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menuBarItems: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.menuBarItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menuBars: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.menuBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menuButtons: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.menuButtons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menuItems: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.menuItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menus: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.menus)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var navigationBars: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.navigationBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var otherElements: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.otherElements)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var outlineRows: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.outlineRows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var outlines: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.outlines)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var pageIndicators: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.pageIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var pickerWheels: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.pickerWheels)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var pickers: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.pickers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var popUpButtons: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.popUpButtons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var popovers: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.popovers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var progressIndicators: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.progressIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var radioButtons: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.radioButtons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var radioGroups: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.radioGroups)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var ratingIndicators: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.ratingIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var relevanceIndicators: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.relevanceIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var rulerMarkers: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.rulerMarkers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var rulers: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.rulers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var scrollBars: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.scrollBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var scrollViews: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.scrollViews)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var searchFields: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.searchFields)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var secureTextFields: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.secureTextFields)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var segmentedControls: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.segmentedControls)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var sheets: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.sheets)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var sliders: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.sliders)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var splitGroups: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.splitGroups)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var splitters: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.splitters)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var staticTexts: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.staticTexts)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var statusBars: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.statusBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var statusItems: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.statusItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var steppers: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.steppers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var switches: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.switches)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tabBars: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.tabBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tabGroups: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.tabGroups)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tableColumns: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.tableColumns)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tableRows: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.tableRows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tables: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.tables)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var textFields: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.textFields)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var textViews: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.textViews)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var timelines: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.timelines)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var toggles: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.toggles)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var toolbarButtons: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.toolbarButtons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var toolbars: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.toolbars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var touchBars: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.touchBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var valueIndicators: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.valueIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var webViews: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.webViews)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var windows: SyncQuery {
        Executor.execute {
            try await SyncQuery(query: self.queryProvider.windows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
}
