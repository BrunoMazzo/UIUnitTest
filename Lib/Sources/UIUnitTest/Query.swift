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
    
    public func tables(identifier: String) -> Query {
        Query(matchers: self.matchers + [.tables(identifier: identifier)])
    }
    
    public func staticText(label: String) -> Query {
        Query(matchers: self.matchers + [.staticText(label: label)])
    }
    
    public func textField(identifier: String) -> Query {
        Query(matchers: self.matchers + [.textField(identifier: identifier)])
    }
}
