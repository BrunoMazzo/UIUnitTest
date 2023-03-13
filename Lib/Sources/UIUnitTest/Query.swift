//
//  File 2.swift
//  
//
//  Created by Bruno Mazzo on 9/3/2023.
//

import Foundation

public struct Query {
    internal var matchers: [ElementMatcher] = []
    
    public func activityIndicators(identifier: String) -> Query {
        Query(matchers: self.matchers + [.activityIndicators(identifier: identifier)])
    }
    
    public func alert(identifier: String) -> Query {
        Query(matchers: self.matchers + [.alerts(identifier: identifier)])
    }
    
    public func browser(identifier: String) -> Query {
        Query(matchers: self.matchers + [.browsers(identifier: identifier)])
    }
    
    public func button(identifier: String) -> Query {
        Query(matchers: self.matchers + [.button(identifier: identifier)])
    }
    
    public func cells(identifier: String) -> Query {
        Query(matchers: self.matchers + [.cells(identifier: identifier)])
    }
    
    public func checkBoxes(identifier: String) -> Query {
        Query(matchers: self.matchers + [.checkBoxes(identifier: identifier)])
    }
    
    public func collectionViews(identifier: String) -> Query {
        Query(matchers: self.matchers + [.collectionViews(identifier: identifier)])
    }
    
    public func colorWells(identifier: String) -> Query {
        Query(matchers: self.matchers + [.colorWells(identifier: identifier)])
    }
    
    public func comboBoxes(identifier: String) -> Query {
        Query(matchers: self.matchers + [.comboBoxes(identifier: identifier)])
    }
    
    public func datePickers(identifier: String) -> Query {
        Query(matchers: self.matchers + [.datePickers(identifier: identifier)])
    }
    
    public func decrementArrows(identifier: String) -> Query {
        Query(matchers: self.matchers + [.decrementArrows(identifier: identifier)])
    }
    
    public func dialogs(identifier: String) -> Query {
        Query(matchers: self.matchers + [.dialogs(identifier: identifier)])
    }
    
    public func disclosureTriangles(identifier: String) -> Query {
        Query(matchers: self.matchers + [.disclosureTriangles(identifier: identifier)])
    }
    
    public func disclosedChildRows(identifier: String) -> Query {
        Query(matchers: self.matchers + [.disclosedChildRows(identifier: identifier)])
    }
    
    public func dockItems(identifier: String) -> Query {
        Query(matchers: self.matchers + [.dockItems(identifier: identifier)])
    }
    
    public func drawers(identifier: String) -> Query {
        Query(matchers: self.matchers + [.drawers(identifier: identifier)])
    }
    
    public func grids(identifier: String) -> Query {
        Query(matchers: self.matchers + [.grids(identifier: identifier)])
    }
    
    public func groups(identifier: String) -> Query {
        Query(matchers: self.matchers + [.groups(identifier: identifier)])
    }
    
    public func handles(identifier: String) -> Query {
        Query(matchers: self.matchers + [.handles(identifier: identifier)])
    }
    
    public func helpTags(identifier: String) -> Query {
        Query(matchers: self.matchers + [.helpTags(identifier: identifier)])
    }
    
    public func icons(identifier: String) -> Query {
        Query(matchers: self.matchers + [.icons(identifier: identifier)])
    }
    
    public func images(identifier: String) -> Query {
        Query(matchers: self.matchers + [.images(identifier: identifier)])
    }
    
    public func incrementArrows(identifier: String) -> Query {
        Query(matchers: self.matchers + [.incrementArrows(identifier: identifier)])
    }
    
    public func keyboards(identifier: String) -> Query {
        Query(matchers: self.matchers + [.keyboards(identifier: identifier)])
    }
    
    public func keys(identifier: String) -> Query {
        Query(matchers: self.matchers + [.keys(identifier: identifier)])
    }
    
    public func layoutAreas(identifier: String) -> Query {
        Query(matchers: self.matchers + [.layoutAreas(identifier: identifier)])
    }
    
    public func layoutItems(identifier: String) -> Query {
        Query(matchers: self.matchers + [.layoutItems(identifier: identifier)])
    }
    
    public func levelIndicators(identifier: String) -> Query {
        Query(matchers: self.matchers + [.levelIndicators(identifier: identifier)])
    }
    
    public func links(identifier: String) -> Query {
        Query(matchers: self.matchers + [.links(identifier: identifier)])
    }
    
    public func maps(identifier: String) -> Query {
        Query(matchers: self.matchers + [.maps(identifier: identifier)])
    }
    
    public func mattes(identifier: String) -> Query {
        Query(matchers: self.matchers + [.mattes(identifier: identifier)])
    }
    
    public func menuBarItems(identifier: String) -> Query {
        Query(matchers: self.matchers + [.menuBarItems(identifier: identifier)])
    }
    
    public func menuBars(identifier: String) -> Query {
        Query(matchers: self.matchers + [.menuBars(identifier: identifier)])
    }
    
    public func menuButtons(identifier: String) -> Query {
        Query(matchers: self.matchers + [.menuButtons(identifier: identifier)])
    }
    
    public func menuItems(identifier: String) -> Query {
        Query(matchers: self.matchers + [.menuItems(identifier: identifier)])
    }
    
    public func menus(identifier: String) -> Query {
        Query(matchers: self.matchers + [.menus(identifier: identifier)])
    }
    
    public func tables(identifier: String) -> Query {
        Query(matchers: self.matchers + [.tables(identifier: identifier)])
    }
    
    public func staticText(label: String) -> Query {
        Query(matchers: self.matchers + [.staticText(label: label)])
    }
    
    public func textField(identifier: String) -> Query {
        Query(matchers: self.matchers + [.textField(identifier: identifier)])
    }
    
    public func navigationBars(identifier: String) -> Query {
        Query(matchers: self.matchers + [.navigationBars(identifier: identifier)])
    }
    
    public func otherElements(identifier: String) -> Query {
        Query(matchers: self.matchers + [.otherElements(identifier: identifier)])
    }
    
    public func outlineRows(identifier: String) -> Query {
        Query(matchers: self.matchers + [.outlineRows(identifier: identifier)])
    }
    
    public func outlines(identifier: String) -> Query {
        Query(matchers: self.matchers + [.outlines(identifier: identifier)])
    }
    
    public func pageIndicators(identifier: String) -> Query {
        Query(matchers: self.matchers + [.pageIndicators(identifier: identifier)])
    }
    
    public func pickerWheels(identifier: String) -> Query {
        Query(matchers: self.matchers + [.pickerWheels(identifier: identifier)])
    }
    
    public func pickers(identifier: String) -> Query {
        Query(matchers: self.matchers + [.pickers(identifier: identifier)])
    }
    
    public func popUpButtons(identifier: String) -> Query {
        Query(matchers: self.matchers + [.popUpButtons(identifier: identifier)])
    }
    
    public func popovers(identifier: String) -> Query {
        Query(matchers: self.matchers + [.popovers(identifier: identifier)])
    }
    
    public func progressIndicators(identifier: String) -> Query {
        Query(matchers: self.matchers + [.progressIndicators(identifier: identifier)])
    }
    
    public func radioButtons(identifier: String) -> Query {
        Query(matchers: self.matchers + [.radioButtons(identifier: identifier)])
    }
    
    public func radioGroups(identifier: String) -> Query {
        Query(matchers: self.matchers + [.radioGroups(identifier: identifier)])
    }
    
    public func ratingIndicators(identifier: String) -> Query {
        Query(matchers: self.matchers + [.ratingIndicators(identifier: identifier)])
    }
    
    public func relevanceIndicators(identifier: String) -> Query {
        Query(matchers: self.matchers + [.relevanceIndicators(identifier: identifier)])
    }
    
    public func rulerMarkers(identifier: String) -> Query {
        Query(matchers: self.matchers + [.rulerMarkers(identifier: identifier)])
    }
    
    public func rulers(identifier: String) -> Query {
        Query(matchers: self.matchers + [.rulers(identifier: identifier)])
    }
    
    public func scrollBars(identifier: String) -> Query {
        Query(matchers: self.matchers + [.scrollBars(identifier: identifier)])
    }
    
    public func scrollViews(identifier: String) -> Query {
        Query(matchers: self.matchers + [.scrollViews(identifier: identifier)])
    }
    
    public func searchFields(identifier: String) -> Query {
        Query(matchers: self.matchers + [.searchFields(identifier: identifier)])
    }
    
    public func secureTextFields(identifier: String) -> Query {
        Query(matchers: self.matchers + [.secureTextFields(identifier: identifier)])
    }
    
    public func segmentedControls(identifier: String) -> Query {
        Query(matchers: self.matchers + [.segmentedControls(identifier: identifier)])
    }
    
    public func sheets(identifier: String) -> Query {
        Query(matchers: self.matchers + [.sheets(identifier: identifier)])
    }
    
    public func sliders(identifier: String) -> Query {
        Query(matchers: self.matchers + [.sliders(identifier: identifier)])
    }
    
    public func splitGroups(identifier: String) -> Query {
        Query(matchers: self.matchers + [.splitGroups(identifier: identifier)])
    }
    
    public func splitters(identifier: String) -> Query {
        Query(matchers: self.matchers + [.splitters(identifier: identifier)])
    }
}
