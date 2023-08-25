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

public struct Executor: @unchecked Sendable {
    private var box = Box()
    
    public static func execute<T>(function: String = #function, _ block: @escaping () async throws -> T) -> T {
        let executor = Executor()
        return executor.execute(function: function, block)
    }
    
    // TODO: Think about a better way to handle errors. Maybe just fail the test?
    func execute<T>(function: String = #function, _ block: @escaping () async throws -> T) -> T {
        let expectation = XCTestExpectation(description: function)
        Task { @UIUnitTestActor in
            defer {
                expectation.fulfill()
            }
            self.box.value = try await block()
        }
        _ = XCTWaiter.wait(for: [expectation])
        return box.value as! T
    }
}

extension Element {
    
    @available(*, noasync)
    public var exists: Bool {
        Executor.execute {
            try await self.exists()
        }
    }
    
    @available(*, noasync)
    public func waitForExistence(timeout: TimeInterval) -> Bool {
        Executor.execute {
            try await self.waitForExistence(timeout: timeout)
        }
    }
    
    @available(*, noasync)
    public var isHittable: Bool {
        Executor.execute {
            try await self.isHittable()
        }
    }
    
    @available(*, noasync)
    public var value: String? {
        Executor.execute {
            try await self.value()
        }
    }
    
    @available(*, noasync)
    public func descendants(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.descendants(matching: type)
        }
    }
    
    @available(*, noasync)
    public func children(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.children(matching: type)
        }
    }
    
    @available(*, noasync)
    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) {
        Executor.execute {
            try await self.scroll(byDeltaX: deltaX, deltaY: deltaY)
        }
    }
    
    @available(*, noasync)
    public func typeText(_ text: String) {
        Executor.execute {
            try await self.typeText(text)
        }
    }
    
    @available(*, noasync)
    public var debugDescription: String {
        Executor.execute {
            try await self.debugDescription()
        }
    }
    
    @available(*, noasync)
    public var identifier: String {
        Executor.execute {
            try await self.identifier()
        }
    }
    
    @available(*, noasync)
    public var title: String {
        Executor.execute {
            try await self.title()
        }
    }
    
    @available(*, noasync)
    public var label: String {
        Executor.execute {
            try await self.label()
        }
    }
    
    @available(*, noasync)
    public var placeholderValue: String? {
        Executor.execute {
            try await self.placeholderValue()
        }
    }
    
    @available(*, noasync)
    public var isSelected: Bool {
        Executor.execute {
            try await self.isSelected()
        }
    }
    
    @available(*, noasync)
    public var hasFocus: Bool {
        Executor.execute {
            try await self.hasFocus()
        }
    }
    
    @available(*, noasync)
    public var isEnabled: Bool {
        Executor.execute {
            try await self.isEnabled()
        }
    }
    
    @available(*, noasync)
    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> Coordinate {
        Executor.execute {
            try await self.coordinate(withNormalizedOffset: normalizedOffset)
        }
    }
    
    @available(*, noasync)
    public var frame: CGRect {
        Executor.execute {
            try await self.frame()
        }
    }
    
    @available(*, noasync)
    public var horizontalSizeClass: SizeClass {
        Executor.execute {
            try await self.horizontalSizeClass()
        }
    }
    
    @available(*, noasync)
    public var verticalSizeClass: SizeClass {
        Executor.execute {
            try await self.verticalSizeClass()
        }
    }
    
    @available(*, noasync)
    public var elementType: Element.ElementType {
        Executor.execute {
            try await self.elementType()
        }
    }
}

public extension ElementTypeQueryProvider {
    
    @available(*, noasync)
    var firstMatch: Element {
        Executor.execute {
            try await self.firstMatch()
        }
    }
    
    @available(*, noasync)
    subscript(dynamicMember: Query.QueryType) -> Query {
        Executor.execute {
            try await Query(serverId: self.serverId, queryType: dynamicMember)
        }
    }
    
    @available(*, noasync)
    var activityIndicators: Query {
        Executor.execute {
            try await self(.activityIndicators)
        }
    }
    
    @available(*, noasync)
    var alerts: Query {
        Executor.execute {
            try await self(.alerts)
        }
    }
    
    @available(*, noasync)
    var browsers: Query {
        Executor.execute {
            try await self(.browsers)
        }
    }
    
    @available(*, noasync)
    var buttons: Query {
        Executor.execute {
            try await self(.buttons)
        }
    }
    
    @available(*, noasync)
    var cells: Query {
        Executor.execute {
            try await self(.cells)
        }
    }
    
    @available(*, noasync)
    var checkBoxes: Query {
        Executor.execute {
            try await self(.checkBoxes)
        }
    }
    
    @available(*, noasync)
    var collectionViews: Query {
        Executor.execute {
            try await self(.collectionViews)
        }
    }
    
    @available(*, noasync)
    var colorWells: Query {
        Executor.execute {
            try await self(.colorWells)
        }
    }
    
    @available(*, noasync)
    var comboBoxes: Query {
        Executor.execute {
            try await self(.comboBoxes)
        }
    }
    
    @available(*, noasync)
    var datePickers: Query {
        Executor.execute {
            try await self(.datePickers)
        }
    }
    
    @available(*, noasync)
    var decrementArrows: Query {
        Executor.execute {
            try await self(.decrementArrows)
        }
    }
    
    @available(*, noasync)
    var dialogs: Query {
        Executor.execute {
            try await self(.dialogs)
        }
    }
    
    @available(*, noasync)
    var disclosureTriangles: Query {
        Executor.execute {
            try await self(.disclosureTriangles)
        }
    }
    
    @available(*, noasync)
    var disclosedChildRows: Query {
        Executor.execute {
            try await self(.disclosedChildRows)
        }
    }
    
    @available(*, noasync)
    var dockItems: Query {
        Executor.execute {
            try await self(.dockItems)
        }
    }
    
    @available(*, noasync)
    var drawers: Query {
        Executor.execute {
            try await self(.drawers)
        }
    }
    
    @available(*, noasync)
    var grids: Query {
        Executor.execute {
            try await self(.grids)
        }
    }
    
    @available(*, noasync)
    var groups: Query {
        Executor.execute {
            try await self(.groups)
        }
    }
    
    @available(*, noasync)
    var handles: Query {
        Executor.execute {
            try await self(.handles)
        }
    }
    
    @available(*, noasync)
    var helpTags: Query {
        Executor.execute {
            try await self(.helpTags)
        }
    }
    
    @available(*, noasync)
    var icons: Query {
        Executor.execute {
            try await self(.icons)
        }
    }
    
    @available(*, noasync)
    var images: Query {
        Executor.execute {
            try await self(.images)
        }
    }
    
    @available(*, noasync)
    var incrementArrows: Query {
        Executor.execute {
            try await self(.incrementArrows)
        }
    }
    
    @available(*, noasync)
    var keyboards: Query {
        Executor.execute {
            try await self(.keyboards)
        }
    }
    
    @available(*, noasync)
    var keys: Query {
        Executor.execute {
            try await self(.keys)
        }
    }
    
    @available(*, noasync)
    var layoutAreas: Query {
        Executor.execute {
            try await self(.layoutAreas)
        }
    }
    
    @available(*, noasync)
    var layoutItems: Query {
        Executor.execute {
            try await self(.layoutItems)
        }
    }
    
    @available(*, noasync)
    var levelIndicators: Query {
        Executor.execute {
            try await self(.levelIndicators)
        }
    }
    
    @available(*, noasync)
    var links: Query {
        Executor.execute {
            try await self(.links)
        }
    }
    
    @available(*, noasync)
    var maps: Query {
        Executor.execute {
            try await self(.maps)
        }
    }
    
    @available(*, noasync)
    var mattes: Query {
        Executor.execute {
            try await self(.mattes)
        }
    }
    
    @available(*, noasync)
    var menuBarItems: Query {
        Executor.execute {
            try await self(.menuBarItems)
        }
    }
    
    @available(*, noasync)
    var menuBars: Query {
        Executor.execute {
            try await self(.menuBars)
        }
    }
    
    @available(*, noasync)
    var menuButtons: Query {
        Executor.execute {
            try await self(.menuButtons)
        }
    }
    
    @available(*, noasync)
    var menuItems: Query {
        Executor.execute {
            try await self(.menuItems)
        }
    }
    
    @available(*, noasync)
    var menus: Query {
        Executor.execute {
            try await self(.menus)
        }
    }
    
    @available(*, noasync)
    var navigationBars: Query {
        Executor.execute {
            try await self(.navigationBars)
        }
    }
    
    @available(*, noasync)
    var otherElements: Query {
        Executor.execute {
            try await self(.otherElements)
        }
    }
    
    @available(*, noasync)
    var outlineRows: Query {
        Executor.execute {
            try await self(.outlineRows)
        }
    }
    
    @available(*, noasync)
    var outlines: Query {
        Executor.execute {
            try await self(.outlines)
        }
    }
    
    @available(*, noasync)
    var pageIndicators: Query {
        Executor.execute {
            try await self(.pageIndicators)
        }
    }
    
    @available(*, noasync)
    var pickerWheels: Query {
        Executor.execute {
            try await self(.pickerWheels)
        }
    }
    
    @available(*, noasync)
    var pickers: Query {
        Executor.execute {
            try await self(.pickers)
        }
    }
    
    @available(*, noasync)
    var popUpButtons: Query {
        Executor.execute {
            try await self(.popUpButtons)
        }
    }
    
    @available(*, noasync)
    var popovers: Query {
        Executor.execute {
            try await self(.popovers)
        }
    }
    
    @available(*, noasync)
    var progressIndicators: Query {
        Executor.execute {
            try await self(.progressIndicators)
        }
    }
    
    @available(*, noasync)
    var radioButtons: Query {
        Executor.execute {
            try await self(.radioButtons)
        }
    }
    
    @available(*, noasync)
    var radioGroups: Query {
        Executor.execute {
            try await self(.radioGroups)
        }
    }
    
    @available(*, noasync)
    var ratingIndicators: Query {
        Executor.execute {
            try await self(.ratingIndicators)
        }
    }
    
    @available(*, noasync)
    var relevanceIndicators: Query {
        Executor.execute {
            try await self(.relevanceIndicators)
        }
    }
    
    @available(*, noasync)
    var rulerMarkers: Query {
        Executor.execute {
            try await self(.rulerMarkers)
        }
    }
    
    @available(*, noasync)
    var rulers: Query {
        Executor.execute {
            try await self(.rulers)
        }
    }
    
    @available(*, noasync)
    var scrollBars: Query {
        Executor.execute {
            try await self(.scrollBars)
        }
    }
    
    @available(*, noasync)
    var scrollViews: Query {
        Executor.execute {
            try await self(.scrollViews)
        }
    }
    
    @available(*, noasync)
    var searchFields: Query {
        Executor.execute {
            try await self(.searchFields)
        }
    }
    
    @available(*, noasync)
    var secureTextFields: Query {
        Executor.execute {
            try await self(.secureTextFields)
        }
    }
    
    @available(*, noasync)
    var segmentedControls: Query {
        Executor.execute {
            try await self(.segmentedControls)
        }
    }
    
    @available(*, noasync)
    var sheets: Query {
        Executor.execute {
            try await self(.sheets)
        }
    }
    
    @available(*, noasync)
    var sliders: Query {
        Executor.execute {
            try await self(.sliders)
        }
    }
    
    @available(*, noasync)
    var splitGroups: Query {
        Executor.execute {
            try await self(.splitGroups)
        }
    }
    
    @available(*, noasync)
    var splitters: Query {
        Executor.execute {
            try await self(.splitters)
        }
    }
    
    @available(*, noasync)
    var staticTexts: Query {
        Executor.execute {
            try await self(.staticTexts)
        }
    }
    
    @available(*, noasync)
    var statusBars: Query {
        Executor.execute {
            try await self(.statusBars)
        }
    }
    
    @available(*, noasync)
    var statusItems: Query {
        Executor.execute {
            try await self(.statusItems)
        }
    }
    
    @available(*, noasync)
    var steppers: Query {
        Executor.execute {
            try await self(.steppers)
        }
    }
    
    @available(*, noasync)
    var switches: Query {
        Executor.execute {
            try await self(.switches)
        }
    }
    
    @available(*, noasync)
    var tabBars: Query {
        Executor.execute {
            try await self(.tabBars)
        }
    }
    
    @available(*, noasync)
    var tabGroups: Query {
        Executor.execute {
            try await self(.tabGroups)
        }
    }
    
    @available(*, noasync)
    var tableColumns: Query {
        Executor.execute {
            try await self(.tableColumns)
        }
    }
    
    @available(*, noasync)
    var tableRows: Query {
        Executor.execute {
            try await self(.tableRows)
        }
    }
    
    @available(*, noasync)
    var tables: Query {
        Executor.execute {
            try await self(.tables)
        }
    }
    
    @available(*, noasync)
    var textFields: Query {
        Executor.execute {
            try await self(.textFields)
        }
    }
    
    @available(*, noasync)
    var textViews: Query {
        Executor.execute {
            try await self(.textViews)
        }
    }
    
    @available(*, noasync)
    var timelines: Query {
        Executor.execute {
            try await self(.timelines)
        }
    }
    
    @available(*, noasync)
    var toggles: Query {
        Executor.execute {
            try await self(.toggles)
        }
    }
    
    @available(*, noasync)
    var toolbarButtons: Query {
        Executor.execute {
            try await self(.toolbarButtons)
        }
    }
    
    @available(*, noasync)
    var toolbars: Query {
        Executor.execute {
            try await self(.toolbars)
        }
    }
    
    @available(*, noasync)
    var touchBars: Query {
        Executor.execute {
            try await self(.touchBars)
        }
    }
    
    @available(*, noasync)
    var valueIndicators: Query {
        Executor.execute {
            try await self(.valueIndicators)
        }
    }
    
    @available(*, noasync)
    var webViews: Query {
        Executor.execute {
            try await self(.webViews)
        }
    }
    
    @available(*, noasync)
    var windows: Query {
        Executor.execute {
            try await self(.windows)
        }
    }
}

