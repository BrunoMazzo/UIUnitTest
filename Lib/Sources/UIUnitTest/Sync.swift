import Foundation
import XCTest

class Box {
    var value: Any?
    var success: Bool = false
}

@globalActor
public struct UIUnitTestActor {
    public actor MyActor {}
    public static let shared = MyActor()
}

public struct Executor: @unchecked Sendable {
    private var box = Box()
    
    public static func execute<T>(function: String = #function, _ block: @escaping () async throws -> T) -> Result<T, Error> {
        let executor = Executor()
        return executor.execute(function: function, block)
    }
    
    // TODO: Think about a better way to handle errors. Maybe just fail the test?
    func execute<T>(function: String = #function, _ block: @escaping () async throws -> T) -> Result<T, Error> {
        let expectation = XCTestExpectation(description: function)
        Task { @UIUnitTestActor in
            defer {
                expectation.fulfill()
            }
            do {
                self.box.value = try await block()
                self.box.success = true
            } catch {
                self.box.value = error
            }
        }
        _ = XCTWaiter.wait(for: [expectation])
        if box.success {
            return .success(box.value as! T)
        } else {
            return .failure(box.value as! Error)
        }
        
    }
}

extension Element {
    
    @available(*, noasync)
    public var exists: Bool {
        Executor.execute {
            try await self.exists()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public func waitForExistence(timeout: TimeInterval) -> Bool {
        Executor.execute {
            try await self.waitForExistence(timeout: timeout)
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var isHittable: Bool {
        Executor.execute {
            try await self.isHittable()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var value: String? {
        Executor.execute {
            try await self.value()
        }.valueOrFailWithFallback(nil)
    }
    
    @available(*, noasync)
    public func descendants(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.descendants(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    public func children(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.children(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    @available(*, noasync)
    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) {
        Executor.execute {
            try await self.scroll(byDeltaX: deltaX, deltaY: deltaY)
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public func typeText(_ text: String) {
        Executor.execute {
            try await self.typeText(text)
        }.valueOrFailWithFallback(())
    }
    
    @available(*, noasync)
    public var debugDescription: String {
        Executor.execute {
            try await self.debugDescription()
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var identifier: String {
        Executor.execute {
            try await self.identifier()
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var title: String {
        Executor.execute {
            try await self.title()
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var label: String {
        Executor.execute {
            try await self.label()
        }.valueOrFailWithFallback("")
    }
    
    @available(*, noasync)
    public var placeholderValue: String? {
        Executor.execute {
            try await self.placeholderValue()
        }.valueOrFailWithFallback(nil)
    }
    
    @available(*, noasync)
    public var isSelected: Bool {
        Executor.execute {
            try await self.isSelected()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var hasFocus: Bool {
        Executor.execute {
            try await self.hasFocus()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public var isEnabled: Bool {
        Executor.execute {
            try await self.isEnabled()
        }.valueOrFailWithFallback(false)
    }
    
    @available(*, noasync)
    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> Coordinate {
        Executor.execute {
            try await self.coordinate(withNormalizedOffset: normalizedOffset)
        }.valueOrFailWithFallback(.EmptyCoordinate)
    }
    
    @available(*, noasync)
    public var frame: CGRect {
        Executor.execute {
            try await self.frame()
        }.valueOrFailWithFallback(.null)
    }
    
    @available(*, noasync)
    public var horizontalSizeClass: SizeClass {
        Executor.execute {
            try await self.horizontalSizeClass()
        }.valueOrFailWithFallback(.unspecified)
    }
    
    @available(*, noasync)
    public var verticalSizeClass: SizeClass {
        Executor.execute {
            try await self.verticalSizeClass()
        }.valueOrFailWithFallback(.unspecified)
    }
    
    @available(*, noasync)
    public var elementType: Element.ElementType {
        Executor.execute {
            try await self.elementType()
        }.valueOrFailWithFallback(.any)
    }
}

public extension ElementTypeQueryProvider {
    
    @available(*, noasync)
    var firstMatch: Element {
        Executor.execute {
            try await self.firstMatch()
        }.valueOrFailWithFallback(.EmptyElement)
    }
    
    @available(*, noasync)
    subscript(dynamicMember: Query.QueryType) -> Query {
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

extension Result {
    func valueOrFailWithFallback(_ fallback: Success, file: StaticString = #filePath, line: UInt = #line) -> Success {
        switch self {
        case let .success(result):
            return result
        case let .failure(error):
            XCTFail(error.localizedDescription, file: file, line: line)
            return fallback
        }
    }
}
