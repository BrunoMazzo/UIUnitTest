# API Coverage

The following table shows the API coverage at the moment:

## **XCUIElementTypeQueryProvider**
| API | Coverage | Notes |
| --- | --- | --- |
| var firstMatch: XCUIElement | ✅ | |
| var activityIndicators: XCUIElementQuery | ✅ | |
| var alerts: XCUIElementQuery | ✅ | |
| var browsers: XCUIElementQuery | ✅ | |
| var buttons: XCUIElementQuery | ✅ | |
| var cells: XCUIElementQuery | ✅ | |
| var checkBoxes: XCUIElementQuery | ✅ | |
| var collectionViews: XCUIElementQuery | ✅ | |
| var colorWells: XCUIElementQuery | ✅ | |
| var comboBoxes: XCUIElementQuery | ✅ | |
| var datePickers: XCUIElementQuery | ✅ | |
| var decrementArrows: XCUIElementQuery | ✅ | |
| var dialogs: XCUIElementQuery | ✅ | |
| var disclosureTriangles: XCUIElementQuery | ✅ | |
| var disclosedChildRows: XCUIElementQuery | ✅ | |
| var dockItems: XCUIElementQuery | ✅ | |
| var drawers: XCUIElementQuery | ✅ | |
| var grids: XCUIElementQuery | ✅ | |
| var groups: XCUIElementQuery | ✅ | |
| var handles: XCUIElementQuery | ✅ | |
| var helpTags: XCUIElementQuery | ✅ | |
| var icons: XCUIElementQuery | ✅ | |
| var images: XCUIElementQuery | ✅ | |
| var incrementArrows: XCUIElementQuery | ✅ | |
| var keyboards: XCUIElementQuery | ✅ | |
| var keys: XCUIElementQuery | ✅ | |
| var layoutAreas: XCUIElementQuery | ✅ | |
| var layoutItems: XCUIElementQuery | ✅ | |
| var levelIndicators: XCUIElementQuery | ✅ | |
| var links: XCUIElementQuery | ✅ | |
| var maps: XCUIElementQuery | ✅ | |
| var mattes: XCUIElementQuery | ✅ | |
| var menuBarItems: XCUIElementQuery | ✅ | |
| var menuBars: XCUIElementQuery | ✅ | |
| var menuButtons: XCUIElementQuery | ✅ | |
| var menuItems: XCUIElementQuery | ✅ | |
| var menus: XCUIElementQuery | ✅ | |
| var navigationBars: XCUIElementQuery | ✅ | |
| var otherElements: XCUIElementQuery | ✅ | |
| var outlineRows: XCUIElementQuery | ✅ | |
| var outlines: XCUIElementQuery | ✅ | |
| var pageIndicators: XCUIElementQuery | ✅ | |
| var pickerWheels: XCUIElementQuery | ✅ | |
| var pickers: XCUIElementQuery | ✅ | |
| var popUpButtons: XCUIElementQuery | ✅ | |
| var popovers: XCUIElementQuery | ✅ | |
| var progressIndicators: XCUIElementQuery | ✅ | |
| var radioButtons: XCUIElementQuery | ✅ | |
| var radioGroups: XCUIElementQuery | ✅ | |
| var ratingIndicators: XCUIElementQuery | ✅ | |
| var relevanceIndicators: XCUIElementQuery | ✅ | |
| var rulerMarkers: XCUIElementQuery | ✅ | |
| var rulers: XCUIElementQuery | ✅ | |
| var scrollBars: XCUIElementQuery | ✅ | |
| var scrollViews: XCUIElementQuery | ✅ | |
| var searchFields: XCUIElementQuery | ✅ | |
| var secureTextFields: XCUIElementQuery | ✅ | |
| var segmentedControls: XCUIElementQuery | ✅ | |
| var sheets: XCUIElementQuery | ✅ | |
| var sliders: XCUIElementQuery | ✅ | |
| var splitGroups: XCUIElementQuery | ✅ | |
| var splitters: XCUIElementQuery | ✅ | |
| var staticTexts: XCUIElementQuery | ✅ | |
| var statusBars: XCUIElementQuery | ✅ | |
| var statusItems: XCUIElementQuery | ✅ | |
| var steppers: XCUIElementQuery | ✅ | |
| var switches: XCUIElementQuery | ✅ | |
| var tabBars: XCUIElementQuery | ✅ | |
| var tabGroups: XCUIElementQuery | ✅ | |
| var tableColumns: XCUIElementQuery | ✅ | |
| var tableRows: XCUIElementQuery | ✅ | |
| var tables: XCUIElementQuery | ✅ | |
| var tabs: XCUIElementQuery | ✅ | |
| var textFields: XCUIElementQuery | ✅ | |
| var textViews: XCUIElementQuery | ✅ | |
| var timelines: XCUIElementQuery | ✅ | |
| var toggles: XCUIElementQuery | ✅ | |
| var toolbarButtons: XCUIElementQuery | ✅ | |
| var toolbars: XCUIElementQuery | ✅ | |
| var touchBars: XCUIElementQuery | ✅ | |
| var valueIndicators: XCUIElementQuery | ✅ | |
| var webViews: XCUIElementQuery | ✅ | |
| var windows: XCUIElementQuery | ✅ | |

## **XCUIElementQuery**
| API | Coverage | Notes |
| --- | --- | --- |
| var element: XCUIElement { get } | ✅ | |
| var count: Int { get } | ✅ | |
| func element(boundBy index: Int) -> XCUIElement | ✅ | |
| func element(matching predicate: NSPredicate) -> XCUIElement | ✅ | Doesn't support NSPredicate with blocks |
| func element(matching elementType: XCUIElement.ElementType, identifier: String?) -> XCUIElement | ✅ | |
| subscript(key: String) -> XCUIElement { get } | ✅ | |
| var allElementsBoundByAccessibilityElement: [XCUIElement] { get } | ✅ | |
| var allElementsBoundByIndex: [XCUIElement] { get } | ✅ | |
| func descendants(matching type: XCUIElement.ElementType) -> XCUIElementQuery | ✅ | |
| func children(matching type: XCUIElement.ElementType) -> XCUIElementQuery | ✅ | |
| func matching(_ predicate: NSPredicate) -> XCUIElementQuery | ✅ | |
| func matching(_ elementType: XCUIElement.ElementType, identifier: String?) -> XCUIElementQuery | ✅ | |
| func matching(identifier: String) -> XCUIElementQuery | ✅ | |
| func containing(_ predicate: NSPredicate) -> XCUIElementQuery | ✅ | |
| func containing(_ elementType: XCUIElement.ElementType, identifier: String?) -> XCUIElementQuery | ✅ | |
| var debugDescription: String { get } | ✅ | |

## **XCUIElement**
| API | Coverage | Notes |
| --- | --- | --- |
| func waitForExistence(timeout: TimeInterval) -> Bool | ✅ | |
| var exists: Bool | ✅ | | 
| var isHittable: Bool | ✅ |  | 
| var debugDescription: String | ✅ |  |
| func children(matching: XCUIElement.ElementType) -> XCUIElementQuery | ✅ | |
| func descendants(matching: XCUIElement.ElementType) -> XCUIElementQuery | ✅ | |
| func typeText(String) | ✅ | |
| func typeKey(String, modifierFlags: XCUIElement.KeyModifierFlags) | ❌ | After version 1.0 |
| func typeKey(XCUIKeyboardKey, modifierFlags: XCUIElement.KeyModifierFlags) | ❌ | After version 1.0 |
| class func perform(withKeyModifiers: XCUIElement.KeyModifierFlags, block: () -> Void) | ❌ | After version 1.0 |
| func hover() | ❌ | After version 1.0 |
| func click() | ❌ | After version 1.0 |
| func click(forDuration: TimeInterval, thenDragTo: XCUIElement) | ❌ | After version 1.0 |
| func click(forDuration: TimeInterval, thenDragTo: XCUIElement, withVelocity: XCUIGestureVelocity, thenHoldForDuration: TimeInterval) | ❌ | After version 1.0 |
| func doubleClick() | ❌ | After version 1.0 |
| func rightClick() | ❌ | After version 1.0 |
| func scroll(byDeltaX: CGFloat, deltaY: CGFloat) | ✅ |  |
| func tap() | ✅ | |
| func doubleTap() | ✅ | |
| func press(forDuration: TimeInterval) | ✅ |  |
| func press(forDuration: TimeInterval, thenDragTo: XCUIElement) | ❌ | After version 1.0 |
| func press(forDuration: TimeInterval, thenDragTo: XCUIElement, withVelocity: XCUIGestureVelocity, thenHoldForDuration: TimeInterval) | ❌ | After version 1.0 |
| func twoFingerTap() | ✅ | |
| func tap(withNumberOfTaps: Int, numberOfTouches: Int) | ✅ | |
| func swipeLeft() | ✅ | |
| func swipeLeft(velocity: XCUIGestureVelocity) | ✅ | |
| func swipeRight() | ✅ | |
| func swipeRight(velocity: XCUIGestureVelocity) | ✅ | |
| func swipeUp() | ✅ | |
| func swipeUp(velocity: XCUIGestureVelocity) | ✅ | |
| func swipeDown() | ✅ | |
| func swipeDown(velocity: XCUIGestureVelocity) | ✅ | |
| func pinch(withScale: CGFloat, velocity: CGFloat) | ✅ | |
| func rotate(CGFloat, withVelocity: CGFloat) | ✅ | |
| var normalizedSliderPosition: CGFloat | ❌ |  | | | |
| func adjust(toNormalizedSliderPosition: CGFloat) | ❌ | |
| func adjust(toPickerWheelValue: String) | ❌ | |
| func coordinate(withNormalizedOffset: CGVector) -> XCUICoordinate | ❌ | |


