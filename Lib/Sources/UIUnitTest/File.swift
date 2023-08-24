import Foundation
import XCTest

class Box {
    var value: Any?
}

@globalActor
public struct UIUnitTestActor {
    public actor MyActor {}
    public static let shared = MyActor()
}

public class Executor {
    var box = Box()
    let xctest: XCTestCase
    
    init(xctest: XCTestCase) {
        self.xctest = xctest
    }
    
    func execute<T>(function: String = #function, _ block: @escaping () async throws -> T) -> T {
        let expectation = xctest.expectation(description: function)
        Task { @UIUnitTestActor in
            defer {
                expectation.fulfill()
            }
            self.box.value = try await block()
        }
        
        xctest.wait(for: [expectation])
        return box.value as! T
    }
}

public protocol SyncElementTypeQueryProvider {
    var elementProvider: ElementTypeQueryProvider { get }
    var executor: Executor { get }
}

public class SyncElement: SyncElementTypeQueryProvider {
    var element: Element {
        elementProvider as! Element
    }
    public var elementProvider: ElementTypeQueryProvider
    public let executor: Executor
    
    init(element: ElementTypeQueryProvider, executor: Executor) {
        self.elementProvider = element
        self.executor = executor
    }
    
    public var exists: Bool {
        self.executor.execute {
            try await self.element.exists
        }
    }
    
    /** Waits the specified amount of time for the element's exist property to be true and returns false if the timeout expires without the element coming into existence. */
    public func waitForExistence(timeout: TimeInterval) -> Bool {
        self.executor.execute {
            try await self.element.waitForExistence(timeout: timeout)
        }
    }
    
    
    /** Whether or not a hit point can be computed for the element for the purpose of synthesizing events. */
    public var isHittable: Bool {
        self.executor.execute {
            try await self.element.isHittable
        }
    }
    
    // Need better way to represent any :c
    public var value: String? {
        self.executor.execute {
            try await self.element.value
        }
    }
    
    /** Returns a query for all descendants of the element matching the specified type. */
    public func descendants(matching type: Element.ElementType) -> SyncQuery {
        let query = self.executor.execute {
            try await self.element.descendants(matching: type)
        }
        return SyncQuery(query: query, executor: self.executor)
    }
    
    /** Returns a query for direct children of the element matching the specified type. */
    public func children(matching type: Element.ElementType) -> SyncQuery {
        let query = self.executor.execute {
            try await self.element.children(matching: type)
        }
        return SyncQuery(query: query, executor: self.executor)
    }
    
    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) {
        self.executor.execute {
            try await self.element.scroll(byDeltaX: deltaX, deltaY: deltaY)
        }
    }
    
    public func typeText(_ text: String) {
        self.executor.execute {
            try await self.element.typeText(text)
        }
    }
    
    public var debugDescription: String {
        self.executor.execute {
            try await self.element.debugDescription
        }
    }
    
    public var identifier: String {
        self.executor.execute {
            try await self.element.identifier
        }
    }
    
    public var title: String {
        self.executor.execute {
            try await self.element.title
        }
    }
    
    public var label: String {
        self.executor.execute {
            try await self.element.label
        }
    }
    
    public var placeholderValue: String? {
        self.executor.execute {
            try await self.element.placeholderValue
        }
    }
    
    public var isSelected: Bool {
        self.executor.execute {
            try await self.element.isSelected
        }
    }
    
    public var hasFocus: Bool {
        self.executor.execute {
            try await self.element.hasFocus
        }
    }
    
    public var isEnabled: Bool {
        self.executor.execute {
            try await self.element.isEnabled
        }
    }
    
    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> Coordinate {
        self.executor.execute {
            try await self.element.coordinate(withNormalizedOffset: normalizedOffset)
        }
    }
    
    public var frame: CGRect {
        self.executor.execute {
            try await self.element.frame
        }
    }
    
    public var horizontalSizeClass: SizeClass {
        self.executor.execute {
            try await self.element.horizontalSizeClass
        }
    }
    
    public var verticalSizeClass: SizeClass {
        self.executor.execute {
            try await self.element.verticalSizeClass
        }
    }
    
    public var elementType: Element.ElementType {
        self.executor.execute {
            try await self.element.elementType
        }
    }
}

public class SyncApp: SyncElement {
    var app: App {
        self.element as! App
    }
    
    public init(xctest: XCTestCase, appId: String) {
        let executor = Executor(xctest: xctest)
        let app = executor.execute({
            try await App(appId: appId)
        })
        super.init(element: app, executor: executor)
    }
    
    public func pressHomeButton() {
        self.executor.execute {
            try await self.app.pressHomeButton()
        }
    }
    
    public func activate() {
        self.executor.execute {
            try await self.app.activate()
        }
    }
}

public class SyncQuery: SyncElementTypeQueryProvider {
    public var elementProvider: ElementTypeQueryProvider
    public let executor: Executor
    
    var query: Query {
        elementProvider as! Query
    }

    init(query: Query, executor: Executor) {
        self.elementProvider = query
        self.executor = executor
    }
    
    public var element: SyncElement! {
        let element = self.executor.execute {
            try await self.query.element
        }
        return SyncElement(element: element!, executor: executor)
    }
    
    public var allElementsBoundByAccessibilityElement: [SyncElement] {
        let elements = self.executor.execute {
            try await self.query.allElementsBoundByAccessibilityElement
        }
        
        return elements.map { element in
            SyncElement(element: element, executor: executor)
        }
    }
    
    public var allElementsBoundByIndex: [SyncElement] {
        let elements = self.executor.execute {
            try await self.query.allElementsBoundByIndex
        }
        return elements.map { element in
            SyncElement(element: element, executor: executor)
        }
    }
    
    /** Evaluates the query at the time it is called and returns the number of matches found. */
    public var count: Int {
        self.executor.execute {
            try await self.query.count
        }
    }
    
    /** Returns an element that will use the index into the query's results to determine which underlying accessibility element it is matched with. */
    public func element(boundByIndex index: Int) -> SyncElement {
        let element = self.executor.execute {
            try await self.query.element(boundByIndex: index)
        }
        return SyncElement(element: element, executor: executor)
    }
    
    /** Returns an element that matches the predicate. The predicate will be evaluated against objects of type id<XCUIElementAttributes>. */
    public func element(matching predicate: NSPredicate) -> SyncElement {
        let element = self.executor.execute {
            try await self.query.element(matching: predicate)
        }
        return SyncElement(element: element, executor: executor)
    }
    
    /** Returns an element that matches the type and identifier. */
    public func element(matching elementType: Element.ElementType, identifier: String?) -> SyncElement {
        let element = self.executor.execute {
            try await self.query.element(matching: elementType, identifier: identifier)
        }
        return SyncElement(element: element, executor: executor)
    }
    
    /** Keyed subscripting is implemented as a shortcut for matching an identifier only. For example, app.descendants["Foo"] -> XCUIElement. */
    public subscript(_ identifier: String) -> SyncElement {
        let element = self.executor.execute {
            try await self.query[identifier]
        }
        return SyncElement(element: element, executor: executor)
    }
    
    /** Returns a new query that finds the descendants of all the elements found by the receiver. */
    public func descendants(matching elementType: Element.ElementType) -> SyncQuery {
        let query = self.executor.execute {
            try await self.query.descendants(matching: elementType)
        }
        
        return SyncQuery(query: query, executor: executor)
        
    }
    
    /** Returns a new query that finds the direct children of all the elements found by the receiver. */
    public func children(matching type: Element.ElementType) -> SyncQuery {
        let query = self.executor.execute {
            try await self.query.children(matching: type)
        }
        return SyncQuery(query: query, executor: executor)
    }
    
    public func matching(_ predicate: NSPredicate) -> SyncQuery {
        let query = self.executor.execute {
            try await self.query.matching(predicate)
        }
        return SyncQuery(query: query, executor: executor)
    }
    
    public func matching(_ elementType: Element.ElementType, identifier: String?) -> SyncQuery {
        let query = self.executor.execute {
            try await self.query.matching(elementType, identifier: identifier)
        }
        return SyncQuery(query: query, executor: executor)
    }
    
    public func matching(identifier: String) -> SyncQuery {
        let query = self.executor.execute {
            try await self.query.matching(identifier: identifier)
        }
        return SyncQuery(query: query, executor: executor)
    }
    
    public func containing(_ predicate: NSPredicate) -> SyncQuery {
        let query = self.executor.execute {
            try await self.query.containing(predicate)
        }
        return SyncQuery(query: query, executor: executor)
    }
    
    public func containing(_ elementType: Element.ElementType, identifier: String?) -> SyncQuery {
        let query = self.executor.execute {
            try await self.query.containing(elementType, identifier: identifier)
        }
        return SyncQuery(query: query, executor: executor)
    }
    
    public var debugDescription: String {
        self.executor.execute {
            try await self.query.debugDescription
        }
    }
}


public extension SyncElementTypeQueryProvider {
    
    var firstMatch: SyncElement {
        let element = self.executor.execute {
            try await self.elementProvider.firstMatch
        }
        
        return SyncElement(element: element, executor: self.executor)
    }
    
    subscript(dynamicMember: Query.QueryType) -> SyncQuery {
        let query = self.executor.execute {
            try await Query(serverId: self.elementProvider.serverId, queryType: dynamicMember)
        }
        return SyncQuery(query: query, executor: self.executor)
    }
    
    var activityIndicators: SyncQuery {
        self[.activityIndicators]
    }
    
    var alerts: SyncQuery {
        self[.alerts]
    }
    
    var browsers: SyncQuery {
       self[.browsers]
    }
    
    var buttons: SyncQuery {
       self[.buttons]
    }
    
    var cells: SyncQuery {
       self[.cells]
    }
    
    var checkBoxes: SyncQuery {
       self[.checkBoxes]
    }
    
    var collectionViews: SyncQuery {
       self[.collectionViews]
    }
    
    var colorWells: SyncQuery {
       self[.colorWells]
    }
    
    var comboBoxes: SyncQuery {
       self[.comboBoxes]
    }
    
    var datePickers: SyncQuery {
       self[.datePickers]
    }
    
    var decrementArrows: SyncQuery {
       self[.decrementArrows]
    }
    
    var dialogs: SyncQuery {
       self[.dialogs]
    }
    
    var disclosureTriangles: SyncQuery {
       self[.disclosureTriangles]
    }
    
    var disclosedChildRows: SyncQuery {
       self[.disclosedChildRows]
    }
    
    var dockItems: SyncQuery {
       self[.dockItems]
    }
    
    var drawers: SyncQuery {
       self[.drawers]
    }
    
    var grids: SyncQuery {
       self[.grids]
    }
    
    var groups: SyncQuery {
       self[.groups]
    }
    
    var handles: SyncQuery {
       self[.handles]
    }
    
    var helpTags: SyncQuery {
       self[.helpTags]
    }
    
    var icons: SyncQuery {
       self[.icons]
    }
    
    var images: SyncQuery {
       self[.images]
    }
    
    var incrementArrows: SyncQuery {
       self[.incrementArrows]
    }
    
    var keyboards: SyncQuery {
       self[.keyboards]
    }
    
    var keys: SyncQuery {
       self[.keys]
    }
    
    var layoutAreas: SyncQuery {
       self[.layoutAreas]
    }
    
    var layoutItems: SyncQuery {
       self[.layoutItems]
    }
    
    var levelIndicators: SyncQuery {
       self[.levelIndicators]
    }
    
    var links: SyncQuery {
       self[.links]
    }
    
    var maps: SyncQuery {
       self[.maps]
    }
    
    var mattes: SyncQuery {
       self[.mattes]
    }
    
    var menuBarItems: SyncQuery {
       self[.menuBarItems]
    }
    
    var menuBars: SyncQuery {
       self[.menuBars]
    }
    
    var menuButtons: SyncQuery {
       self[.menuButtons]
    }
    
    var menuItems: SyncQuery {
       self[.menuItems]
    }
    
    var menus: SyncQuery {
       self[.menus]
    }
    
    var navigationBars: SyncQuery {
       self[.navigationBars]
    }
    
    var otherElements: SyncQuery {
       self[.otherElements]
    }
    
    var outlineRows: SyncQuery {
       self[.outlineRows]
    }
    
    var outlines: SyncQuery {
       self[.outlines]
    }
    
    var pageIndicators: SyncQuery {
       self[.pageIndicators]
    }
    
    var pickerWheels: SyncQuery {
       self[.pickerWheels]
    }
    
    var pickers: SyncQuery {
       self[.pickers]
    }
    
    var popUpButtons: SyncQuery {
       self[.popUpButtons]
    }
    
    var popovers: SyncQuery {
       self[.popovers]
    }
    
    var progressIndicators: SyncQuery {
       self[.progressIndicators]
    }
    
    var radioButtons: SyncQuery {
       self[.radioButtons]
    }
    
    var radioGroups: SyncQuery {
       self[.radioGroups]
    }
    
    var ratingIndicators: SyncQuery {
       self[.ratingIndicators]
    }
    
    var relevanceIndicators: SyncQuery {
       self[.relevanceIndicators]
    }
    
    var rulerMarkers: SyncQuery {
       self[.rulerMarkers]
    }
    
    var rulers: SyncQuery {
       self[.rulers]
    }
    
    var scrollBars: SyncQuery {
       self[.scrollBars]
    }
    
    var scrollViews: SyncQuery {
       self[.scrollViews]
    }
    var searchFields: SyncQuery {
       self[.searchFields]
    }
    
    var secureTextFields: SyncQuery {
       self[.secureTextFields]
    }
    
    var segmentedControls: SyncQuery {
       self[.segmentedControls]
    }
    
    var sheets: SyncQuery {
       self[.sheets]
    }
    
    var sliders: SyncQuery {
       self[.sliders]
    }
    
    var splitGroups: SyncQuery {
       self[.splitGroups]
    }
    
    var splitters: SyncQuery {
       self[.splitters]
    }
    
    var staticTexts: SyncQuery {
       self[.staticTexts]
    }
    
    var statusBars: SyncQuery {
       self[.statusBars]
    }
    
    var statusItems: SyncQuery {
       self[.statusItems]
    }
    
    var steppers: SyncQuery {
       self[.steppers]
    }
    
    var switches: SyncQuery {
       self[.switches]
    }
    
    var tabBars: SyncQuery {
       self[.tabBars]
    }
    
    var tabGroups: SyncQuery {
       self[.tabGroups]
    }
    
    var tableColumns: SyncQuery {
       self[.tableColumns]
    }
    
    var tableRows: SyncQuery {
       self[.tableRows]
    }
    
    var tables: SyncQuery {
       self[.tables]
    }
    
    var textFields: SyncQuery {
       self[.textFields]
    }
    
    var textViews: SyncQuery {
       self[.textViews]
    }
    
    var timelines: SyncQuery {
       self[.timelines]
    }
    
    var toggles: SyncQuery {
       self[.toggles]
    }
    
    var toolbarButtons: SyncQuery {
       self[.toolbarButtons]
    }
    
    var toolbars: SyncQuery {
       self[.toolbars]
    }
    
    var touchBars: SyncQuery {
       self[.touchBars]
    }
    
    var valueIndicators: SyncQuery {
       self[.valueIndicators]
    }
    
    var webViews: SyncQuery {
       self[.webViews]
    }
    
    var windows: SyncQuery {
       self[.windows]
    }
}
