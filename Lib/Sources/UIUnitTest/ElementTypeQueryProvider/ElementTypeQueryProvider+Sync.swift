import Foundation
import UIUnitTestAPI

public extension ElementTypeQueryProvider {
    @available(*, noasync)
    var firstMatch: Element {
        Executor.execute {
            try await self.firstMatch()
        }.valueOrFailWithFallback(.EmptyElement)
    }

    @available(*, noasync)
    subscript(dynamicMember: QueryType) -> Query {
        Executor.execute {
            try await Query(serverId: self.serverId, queryType: dynamicMember)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var activityIndicators: Query {
        Executor.execute {
            try await self(.activityIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var alerts: Query {
        Executor.execute {
            try await self(.alerts)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var browsers: Query {
        Executor.execute {
            try await self(.browsers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var buttons: Query {
        Executor.execute {
            try await self(.buttons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var cells: Query {
        Executor.execute {
            try await self(.cells)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var checkBoxes: Query {
        Executor.execute {
            try await self(.checkBoxes)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var collectionViews: Query {
        Executor.execute {
            try await self(.collectionViews)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var colorWells: Query {
        Executor.execute {
            try await self(.colorWells)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var comboBoxes: Query {
        Executor.execute {
            try await self(.comboBoxes)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var datePickers: Query {
        Executor.execute {
            try await self(.datePickers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var decrementArrows: Query {
        Executor.execute {
            try await self(.decrementArrows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var dialogs: Query {
        Executor.execute {
            try await self(.dialogs)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var disclosureTriangles: Query {
        Executor.execute {
            try await self(.disclosureTriangles)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var disclosedChildRows: Query {
        Executor.execute {
            try await self(.disclosedChildRows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var dockItems: Query {
        Executor.execute {
            try await self(.dockItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var drawers: Query {
        Executor.execute {
            try await self(.drawers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var grids: Query {
        Executor.execute {
            try await self(.grids)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var groups: Query {
        Executor.execute {
            try await self(.groups)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var handles: Query {
        Executor.execute {
            try await self(.handles)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var helpTags: Query {
        Executor.execute {
            try await self(.helpTags)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var icons: Query {
        Executor.execute {
            try await self(.icons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var images: Query {
        Executor.execute {
            try await self(.images)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var incrementArrows: Query {
        Executor.execute {
            try await self(.incrementArrows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var keyboards: Query {
        Executor.execute {
            try await self(.keyboards)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var keys: Query {
        Executor.execute {
            try await self(.keys)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var layoutAreas: Query {
        Executor.execute {
            try await self(.layoutAreas)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var layoutItems: Query {
        Executor.execute {
            try await self(.layoutItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var levelIndicators: Query {
        Executor.execute {
            try await self(.levelIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var links: Query {
        Executor.execute {
            try await self(.links)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var maps: Query {
        Executor.execute {
            try await self(.maps)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var mattes: Query {
        Executor.execute {
            try await self(.mattes)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menuBarItems: Query {
        Executor.execute {
            try await self(.menuBarItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menuBars: Query {
        Executor.execute {
            try await self(.menuBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menuButtons: Query {
        Executor.execute {
            try await self(.menuButtons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menuItems: Query {
        Executor.execute {
            try await self(.menuItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var menus: Query {
        Executor.execute {
            try await self(.menus)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var navigationBars: Query {
        Executor.execute {
            try await self(.navigationBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var otherElements: Query {
        Executor.execute {
            try await self(.otherElements)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var outlineRows: Query {
        Executor.execute {
            try await self(.outlineRows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var outlines: Query {
        Executor.execute {
            try await self(.outlines)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var pageIndicators: Query {
        Executor.execute {
            try await self(.pageIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var pickerWheels: Query {
        Executor.execute {
            try await self(.pickerWheels)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var pickers: Query {
        Executor.execute {
            try await self(.pickers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var popUpButtons: Query {
        Executor.execute {
            try await self(.popUpButtons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var popovers: Query {
        Executor.execute {
            try await self(.popovers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var progressIndicators: Query {
        Executor.execute {
            try await self(.progressIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var radioButtons: Query {
        Executor.execute {
            try await self(.radioButtons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var radioGroups: Query {
        Executor.execute {
            try await self(.radioGroups)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var ratingIndicators: Query {
        Executor.execute {
            try await self(.ratingIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var relevanceIndicators: Query {
        Executor.execute {
            try await self(.relevanceIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var rulerMarkers: Query {
        Executor.execute {
            try await self(.rulerMarkers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var rulers: Query {
        Executor.execute {
            try await self(.rulers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var scrollBars: Query {
        Executor.execute {
            try await self(.scrollBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var scrollViews: Query {
        Executor.execute {
            try await self(.scrollViews)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var searchFields: Query {
        Executor.execute {
            try await self(.searchFields)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var secureTextFields: Query {
        Executor.execute {
            try await self(.secureTextFields)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var segmentedControls: Query {
        Executor.execute {
            try await self(.segmentedControls)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var sheets: Query {
        Executor.execute {
            try await self(.sheets)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var sliders: Query {
        Executor.execute {
            try await self(.sliders)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var splitGroups: Query {
        Executor.execute {
            try await self(.splitGroups)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var splitters: Query {
        Executor.execute {
            try await self(.splitters)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var staticTexts: Query {
        Executor.execute {
            try await self(.staticTexts)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var statusBars: Query {
        Executor.execute {
            try await self(.statusBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var statusItems: Query {
        Executor.execute {
            try await self(.statusItems)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var steppers: Query {
        Executor.execute {
            try await self(.steppers)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var switches: Query {
        Executor.execute {
            try await self(.switches)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tabBars: Query {
        Executor.execute {
            try await self(.tabBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tabGroups: Query {
        Executor.execute {
            try await self(.tabGroups)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tableColumns: Query {
        Executor.execute {
            try await self(.tableColumns)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tableRows: Query {
        Executor.execute {
            try await self(.tableRows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var tables: Query {
        Executor.execute {
            try await self(.tables)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var textFields: Query {
        Executor.execute {
            try await self(.textFields)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var textViews: Query {
        Executor.execute {
            try await self(.textViews)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var timelines: Query {
        Executor.execute {
            try await self(.timelines)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var toggles: Query {
        Executor.execute {
            try await self(.toggles)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var toolbarButtons: Query {
        Executor.execute {
            try await self(.toolbarButtons)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var toolbars: Query {
        Executor.execute {
            try await self(.toolbars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var touchBars: Query {
        Executor.execute {
            try await self(.touchBars)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var valueIndicators: Query {
        Executor.execute {
            try await self(.valueIndicators)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var webViews: Query {
        Executor.execute {
            try await self(.webViews)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    var windows: Query {
        Executor.execute {
            try await self(.windows)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
}
