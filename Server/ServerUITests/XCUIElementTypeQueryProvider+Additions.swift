import XCTest
import UIUnitTestAPI

extension XCUIElementTypeQueryProvider {
    func queryBy(_ queryType: QueryType) -> XCUIElementQuery {
        let resultQuery: XCUIElementQuery
        switch queryType {
        case .staticTexts:
            resultQuery = self.staticTexts
        case .activityIndicators:
            resultQuery = self.activityIndicators
        case .alerts:
            resultQuery = self.alerts
        case .browsers:
            resultQuery = self.browsers
        case .buttons:
            resultQuery = self.buttons
        case .cells:
            resultQuery = self.cells
        case .checkBoxes:
            resultQuery = self.staticTexts
        case .collectionViews:
            resultQuery = self.collectionViews
        case .colorWells:
            resultQuery = self.colorWells
        case .comboBoxes:
            resultQuery = self.comboBoxes
        case .datePickers:
            resultQuery = self.datePickers
        case .decrementArrows:
            resultQuery = self.decrementArrows
        case .dialogs:
            resultQuery = self.dialogs
        case .disclosureTriangles:
            resultQuery = self.disclosureTriangles
        case .disclosedChildRows:
            resultQuery = self.disclosedChildRows
        case .dockItems:
            resultQuery = self.dockItems
        case .drawers:
            resultQuery = self.drawers
        case .grids:
            resultQuery = self.grids
        case .groups:
            resultQuery = self.groups
        case .handles:
            resultQuery = self.handles
        case .helpTags:
            resultQuery = self.helpTags
        case .icons:
            resultQuery = self.icons
        case .images:
            resultQuery = self.images
        case .incrementArrows:
            resultQuery = self.incrementArrows
        case .keyboards:
            resultQuery = self.keyboards
        case .keys:
            resultQuery = self.keys
        case .layoutAreas:
            resultQuery = self.layoutAreas
        case .layoutItems:
            resultQuery = self.layoutItems
        case .levelIndicators:
            resultQuery = self.levelIndicators
        case .links:
            resultQuery = self.links
        case .maps:
            resultQuery = self.maps
        case .mattes:
            resultQuery = self.mattes
        case .menuBarItems:
            resultQuery = self.menuBarItems
        case .menuBars:
            resultQuery = self.menuBars
        case .menuButtons:
            resultQuery = self.menuButtons
        case .menuItems:
            resultQuery = self.menuItems
        case .menus:
            resultQuery = self.menus
        case .navigationBars:
            resultQuery = self.navigationBars
        case .otherElements:
            resultQuery = self.otherElements
        case .outlineRows:
            resultQuery = self.outlineRows
        case .outlines:
            resultQuery = self.outlines
        case .pageIndicators:
            resultQuery = self.pageIndicators
        case .pickerWheels:
            resultQuery = self.pickerWheels
        case .pickers:
            resultQuery = self.pickers
        case .popUpButtons:
            resultQuery = self.popUpButtons
        case .popovers:
            resultQuery = self.popovers
        case .progressIndicators:
            resultQuery = self.progressIndicators
        case .radioButtons:
            resultQuery = self.radioButtons
        case .radioGroups:
            resultQuery = self.radioGroups
        case .ratingIndicators:
            resultQuery = self.ratingIndicators
        case .relevanceIndicators:
            resultQuery = self.relevanceIndicators
        case .rulerMarkers:
            resultQuery = self.rulerMarkers
        case .rulers:
            resultQuery = self.rulers
        case .scrollBars:
            resultQuery = self.scrollBars
        case .scrollViews:
            resultQuery = self.scrollViews
        case .searchFields:
            resultQuery = self.searchFields
        case .secureTextFields:
            resultQuery = self.secureTextFields
        case .segmentedControls:
            resultQuery = self.segmentedControls
        case .sheets:
            resultQuery = self.sheets
        case .sliders:
            resultQuery = self.sliders
        case .splitGroups:
            resultQuery = self.splitGroups
        case .splitters:
            resultQuery = self.splitters
        case .statusBars:
            resultQuery = self.statusBars
        case .statusItems:
            resultQuery = self.statusItems
        case .steppers:
            resultQuery = self.steppers
        case .switches:
            resultQuery = self.switches
        case .tabBars:
            resultQuery = self.tabBars
        case .tabGroups:
            resultQuery = self.tabGroups
        case .tableColumns:
            resultQuery = self.tableColumns
        case .tableRows:
            resultQuery = self.tableRows
        case .tables:
            resultQuery = self.tables
        case .textFields:
            resultQuery = self.textFields
        case .textViews:
            resultQuery = self.textViews
        case .timelines:
            resultQuery = self.timelines
        case .toggles:
            resultQuery = self.toggles
        case .toolbarButtons:
            resultQuery = self.toolbarButtons
        case .toolbars:
            resultQuery = self.toolbars
        case .touchBars:
            resultQuery = self.touchBars
        case .valueIndicators:
            resultQuery = self.valueIndicators
        case .webViews:
            resultQuery = self.webViews
        case .windows:
            resultQuery = self.windows
        }
        
        return resultQuery
    }
}
