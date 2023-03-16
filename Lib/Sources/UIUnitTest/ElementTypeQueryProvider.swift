import Foundation

public protocol ElementTypeQueryProvider {
    var queryServerId: UUID? { get }
}

public extension ElementTypeQueryProvider {
    
    subscript(dynamicMember: Element.ElementType) -> Query {
        get async throws {
            try await Query(queryRoot: self.queryServerId, elementType: dynamicMember)
        }
    }
    
    var activityIndicators: Query {
        get async throws {
            try await self[.activityIndicators]
        }
    }
    
    var alerts: Query {
        get async throws {
            try await self[.alerts]
        }
    }
    
    var browsers: Query {
        get async throws {
            try await self[.browsers]
        }
    }
    
    var buttons: Query {
        get async throws {
            try await self[.buttons]
        }
    }
    
    var cells: Query {
        get async throws {
            try await self[.cells]
        }
    }
    
    var checkBoxes: Query {
        get async throws {
            try await self[.checkBoxes]
        }
    }
    
    var collectionViews: Query {
        get async throws {
            try await self[.collectionViews]
        }
    }
    
    var colorWells: Query {
        get async throws {
            try await self[.colorWells]
        }
    }
    
    var comboBoxes: Query {
        get async throws {
            try await self[.comboBoxes]
        }
    }
    
    var datePickers: Query {
        get async throws {
            try await self[.datePickers]
        }
    }
    
    var decrementArrows: Query {
        get async throws {
            try await self[.decrementArrows]
        }
    }
    
    var dialogs: Query {
        get async throws {
            try await self[.dialogs]
        }
    }
    
    var disclosureTriangles: Query {
        get async throws {
            try await self[.disclosureTriangles]
        }
    }
    
    var disclosedChildRows: Query {
        get async throws {
            try await self[.disclosedChildRows]
        }
    }
    
    var dockItems: Query {
        get async throws {
            try await self[.dockItems]
        }
    }
    
    var drawers: Query {
        get async throws {
            try await self[.drawers]
        }
    }
    
    var grids: Query {
        get async throws {
            try await self[.grids]
        }
    }
    
    var groups: Query {
        get async throws {
            try await self[.groups]
        }
    }
    
    var handles: Query {
        get async throws {
            try await self[.handles]
        }
    }
    
    var helpTags: Query {
        get async throws {
            try await self[.helpTags]
        }
    }
    
    var icons: Query {
        get async throws {
            try await self[.icons]
        }
    }
    
    var images: Query {
        get async throws {
            try await self[.images]
        }
    }
    
    var incrementArrows: Query {
        get async throws {
            try await self[.incrementArrows]
        }
    }
    
    var keyboards: Query {
        get async throws {
            try await self[.keyboards]
        }
    }
    
    var keys: Query {
        get async throws {
            try await self[.keys]
        }
    }
    
    var layoutAreas: Query {
        get async throws {
            try await self[.layoutAreas]
        }
    }
    
    var layoutItems: Query {
        get async throws {
            try await self[.layoutItems]
        }
    }
    
    var levelIndicators: Query {
        get async throws {
            try await self[.levelIndicators]
        }
    }
    
    var links: Query {
        get async throws {
            try await self[.links]
        }
    }
    
    var maps: Query {
        get async throws {
            try await self[.maps]
        }
    }
    
    var mattes: Query {
        get async throws {
            try await self[.mattes]
        }
    }
    
    var menuBarItems: Query {
        get async throws {
            try await self[.menuBarItems]
        }
    }
    
    var menuBars: Query {
        get async throws {
            try await self[.menuBars]
        }
    }
    
    var menuButtons: Query {
        get async throws {
            try await self[.menuButtons]
        }
    }
    
    var menuItems: Query {
        get async throws {
            try await self[.menuItems]
        }
    }
    
    var menus: Query {
        get async throws {
            try await self[.menus]
        }
    }
    
    var navigationBars: Query {
        get async throws {
            try await self[.navigationBars]
        }
    }
    
    var otherElements: Query {
        get async throws {
            try await self[.otherElements]
        }
    }
    
    var outlineRows: Query {
        get async throws {
            try await self[.outlineRows]
        }
    }
    
    var outlines: Query {
        get async throws {
            try await self[.outlines]
        }
    }
    
    var pageIndicators: Query {
        get async throws {
            try await self[.pageIndicators]
        }
    }
    
    var pickerWheels: Query {
        get async throws {
            try await self[.pickerWheels]
        }
    }
    
    var pickers: Query {
        get async throws {
            try await self[.pickers]
        }
    }
    
    var popUpButtons: Query {
        get async throws {
            try await self[.popUpButtons]
        }
    }
    
    var popovers: Query {
        get async throws {
            try await self[.popovers]
        }
    }
    
    var progressIndicators: Query {
        get async throws {
            try await self[.progressIndicators]
        }
    }
    
    var radioButtons: Query {
        get async throws {
            try await self[.radioButtons]
        }
    }
    
    var radioGroups: Query {
        get async throws {
            try await self[.radioGroups]
        }
    }
    
    var ratingIndicators: Query {
        get async throws {
            try await self[.ratingIndicators]
        }
    }
    
    var relevanceIndicators: Query {
        get async throws {
            try await self[.relevanceIndicators]
        }
    }
    
    var rulerMarkers: Query {
        get async throws {
            try await self[.rulerMarkers]
        }
    }
    
    var rulers: Query {
        get async throws {
            try await self[.rulers]
        }
    }
    
    var scrollBars: Query {
        get async throws {
            try await self[.scrollBars]
        }
    }
    
    var scrollViews: Query {
        get async throws {
            try await self[.scrollViews]
        }
    }
    var searchFields: Query {
        get async throws {
            try await self[.searchFields]
        }
    }
    
    var secureTextFields: Query {
        get async throws {
            try await self[.secureTextFields]
        }
    }
    
    var segmentedControls: Query {
        get async throws {
            try await self[.segmentedControls]
        }
    }
    
    var sheets: Query {
        get async throws {
            try await self[.sheets]
        }
    }
    
    var sliders: Query {
        get async throws {
            try await self[.sliders]
        }
    }
    
    var splitGroups: Query {
        get async throws {
            try await self[.splitGroups]
        }
    }
    
    var splitters: Query {
        get async throws {
            try await self[.splitters]
        }
    }
    
    var staticTexts: Query {
        get async throws {
            try await self[.staticTexts]
        }
    }
    
    var statusBars: Query {
        get async throws {
            try await self[.statusBars]
        }
    }
    
    var statusItems: Query {
        get async throws {
            try await self[.statusItems]
        }
    }
    
    var steppers: Query {
        get async throws {
            try await self[.steppers]
        }
    }
    
    var switches: Query {
        get async throws {
            try await self[.switches]
        }
    }
    
    var tabBars: Query {
        get async throws {
            try await self[.tabBars]
        }
    }
    
    var tabGroups: Query {
        get async throws {
            try await self[.tabGroups]
        }
    }
    
    var tableColumns: Query {
        get async throws {
            try await self[.tableColumns]
        }
    }
    
    var tableRows: Query {
        get async throws {
            try await self[.tableRows]
        }
    }
    
    var tables: Query {
        get async throws {
            try await self[.tables]
        }
    }
    
    var textFields: Query {
        get async throws {
            try await self[.textFields]
        }
    }
    
    var textViews: Query {
        get async throws {
            try await self[.textViews]
        }
    }
    
    var timelines: Query {
        get async throws {
            try await self[.timelines]
        }
    }
    
    var toggles: Query {
        get async throws {
            try await self[.toggles]
        }
    }
    
    var toolbarButtons: Query {
        get async throws {
            try await self[.toolbarButtons]
        }
    }
    
    var toolbars: Query {
        get async throws {
            try await self[.toolbars]
        }
    }
    
    var touchBars: Query {
        get async throws {
            try await self[.touchBars]
        }
    }
    
    var valueIndicators: Query {
        get async throws {
            try await self[.valueIndicators]
        }
    }
    
    var webViews: Query {
        get async throws {
            try await self[.webViews]
        }
    }
    
    var windows: Query {
        get async throws {
            try await self[.windows]
        }
    }
}
