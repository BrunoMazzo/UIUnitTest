# API Coverage

The following table shows the API coverage at the moment:

| API | Coverage | Notes |
| --- | --- | --- |
| **XCUIElementTypeQueryProvider** |
| var firstMatch: XCUIElement | ❌ | |
| var activityIndicators: XCUIElementQuery | ✅ | |
| var alerts: XCUIElementQuery | ❌ | |
| var browsers: XCUIElementQuery | ❌ | |
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
| var incrementArrows: XCUIElementQuery | ❌ | |
| var keyboards: XCUIElementQuery | ❌ | |
| var keys: XCUIElementQuery | ❌ | |
| var layoutAreas: XCUIElementQuery | ❌ | |
| var layoutItems: XCUIElementQuery | ❌ | |
| var levelIndicators: XCUIElementQuery | ❌ | |
| var links: XCUIElementQuery | ❌ | |
| var maps: XCUIElementQuery | ❌ | |
| var mattes: XCUIElementQuery | ❌ | |
| var menuBarItems: XCUIElementQuery | ❌ | |
| var menuBars: XCUIElementQuery | ❌ | |
| var menuButtons: XCUIElementQuery | ❌ | |
| var menuItems: XCUIElementQuery | ❌ | |
| var menus: XCUIElementQuery | ❌ | |
| var navigationBars: XCUIElementQuery | ❌ | |
| var otherElements: XCUIElementQuery | ❌ | |
| var outlineRows: XCUIElementQuery | ❌ | |
| var outlines: XCUIElementQuery | ❌ | |
| var pageIndicators: XCUIElementQuery | ❌ | |
| var pickerWheels: XCUIElementQuery | ❌ | |
| var pickers: XCUIElementQuery | ❌ | |
| var popUpButtons: XCUIElementQuery | ❌ | |
| var popovers: XCUIElementQuery | ❌ | |
| var progressIndicators: XCUIElementQuery | ❌ | |
| var radioButtons: XCUIElementQuery | ❌ | |
| var radioGroups: XCUIElementQuery | ❌ | |
| var ratingIndicators: XCUIElementQuery | ❌ | |
| var relevanceIndicators: XCUIElementQuery | ❌ | |
| var rulerMarkers: XCUIElementQuery | ❌ | |
| var rulers: XCUIElementQuery | ❌ | |
| var scrollBars: XCUIElementQuery | ❌ | |
| var scrollViews: XCUIElementQuery | ❌ | |
| var searchFields: XCUIElementQuery | ❌ | |
| var secureTextFields: XCUIElementQuery | ❌ | |
| var segmentedControls: XCUIElementQuery | ❌ | |
| var sheets: XCUIElementQuery | ❌ | |
| var sliders: XCUIElementQuery | ❌ | |
| var splitGroups: XCUIElementQuery | ❌ | |
| var splitters: XCUIElementQuery | ❌ | |
| var staticTexts: XCUIElementQuery | ✅ | |
| var statusBars: XCUIElementQuery | ❌ | |
| var statusItems: XCUIElementQuery | ❌ | |
| var steppers: XCUIElementQuery | ❌ | |
| var switches: XCUIElementQuery | ❌ | |
| var tabBars: XCUIElementQuery | ❌ | |
| var tabGroups: XCUIElementQuery | ❌ | |
| var tableColumns: XCUIElementQuery | ❌ | |
| var tableRows: XCUIElementQuery | ❌ | |
| var tables: XCUIElementQuery | ✅ | |
| var tabs: XCUIElementQuery | ❌ | |
| var textFields: XCUIElementQuery | ✅ | |
| var textViews: XCUIElementQuery | ❌ | |
| var timelines: XCUIElementQuery | ❌ | |
| var toggles: XCUIElementQuery | ❌ | |
| var toolbarButtons: XCUIElementQuery | ❌ | |
| var toolbars: XCUIElementQuery | ❌ | |
| var touchBars: XCUIElementQuery | ❌ | |
| var valueIndicators: XCUIElementQuery | ❌ | |
| var webViews: XCUIElementQuery | ❌ | |
| var windows: XCUIElementQuery | ❌ | |
| **XCUIElement** |
| func waitForExistence(timeout: TimeInterval) -> Bool | ✅ | |
| var exists: Bool | ✅ | | 
| var isHittable: Bool | ❌ | Try to implement to version 1.0 | 
| var debugDescription: String | ❌ | Try to implement to version 1.0 |
| func children(matching: XCUIElement.ElementType) -> XCUIElementQuery | ❌ | |
| func descendants(matching: XCUIElement.ElementType) -> XCUIElementQuery | ❌ | |
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
| func scroll(byDeltaX: CGFloat, deltaY: CGFloat) | ❌ | Try to implement to version 1.0 |
| func tap() | ✅ | |
| func doubleTap() | ✅ | |
| func press(forDuration: TimeInterval) | ✅ |  |
| func press(forDuration: TimeInterval, thenDragTo: XCUIElement) | ❌ | After version 1.0 |
| func press(forDuration: TimeInterval, thenDragTo: XCUIElement, withVelocity: XCUIGestureVelocity, thenHoldForDuration: TimeInterval) | ❌ | After version 1.0 |
| func twoFingerTap() | ❌ | |
| func tap(withNumberOfTaps: Int, numberOfTouches: Int) | ❌ | Try to implement to version 1.0 |
| func swipeLeft() | ✅ | |
| func swipeLeft(velocity: XCUIGestureVelocity) | ❌ | Try to implement to version 1.0 |
| func swipeRight() | ✅ | |
| func swipeRight(velocity: XCUIGestureVelocity) | ❌ | Try to implement to version 1.0 |
| func swipeUp() | ✅ | |
| func swipeUp(velocity: XCUIGestureVelocity) | ❌ | Try to implement to version 1.0 |
| func swipeDown() | ✅ | |
| func swipeDown(velocity: XCUIGestureVelocity) | ❌ | Try to implement to version 1.0 |
| func pinch(withScale: CGFloat, velocity: CGFloat) | ❌ | Try to implement to version 1.0 |
| func rotate(CGFloat, withVelocity: CGFloat) | ❌ | Try to implement to version 1.0 |
| var normalizedSliderPosition: CGFloat | ❌ |  | | | |
| func adjust(toNormalizedSliderPosition: CGFloat) | ❌ | |
| func adjust(toPickerWheelValue: String) | ❌ | |
| func coordinate(withNormalizedOffset: CGVector) -> XCUICoordinate | ❌ | |


