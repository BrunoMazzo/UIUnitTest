import FlyingFox
import FlyingSocks
import Foundation
import UIUnitTestAPI
import XCTest

let decoder = JSONDecoder()
let encoder = JSONEncoder()

let CurrentServerVersion = 6

@MainActor
class UIServer {
    var lastIssue: XCTIssue?

    var server: HTTPServer!

    @MainActor
    let cache = Cache()

    @MainActor
    func performAccessibilityAudit(
        request: AccessibilityAuditRequest
    ) async throws -> AccessibilityAuditResponse {
        let app = try cache.getApplication(request.serverId)

        if #available(iOS 17.0, *) {
            var issues = [XCUIAccessibilityAuditIssue]()
            try app.performAccessibilityAudit(for: request.accessibilityAuditType.toXCUIAccessibilityAuditType()) { issue in
                issues.append(issue)
                return true
            }

            var issuesData: [AccessibilityAuditIssueData] = []
            for issue in issues {
                issuesData.append(AccessibilityAuditIssueData(xcIssue: issue, cache: cache))
            }

            return AccessibilityAuditResponse(issues: issuesData)
        } else {
            // Fallback on earlier versions
            throw NSError(domain: "com.apple.XCTest", code: 0, userInfo: nil)
        }
    }

    @MainActor
    func firstMatch(firstMatchRequest: FirstMatchRequest) async throws -> FirstMatchResponse {
        let query = try cache.getQuery(firstMatchRequest.serverId)
        let element = query.firstMatch

        let id = cache.add(element: element)

        return FirstMatchResponse(serverId: id)
    }

    @MainActor
    func elementFromQuery(elementFromQuery: ElementFromQuery) async throws -> ElementPayload {
        let query = try cache.getElementQuery(elementFromQuery.serverId)

        let element: XCUIElement
        if let index = elementFromQuery.index {
            element = query.element(boundBy: index)
        } else if let type = elementFromQuery.elementType {
            element = query.element(matching: type.toXCUIElementType(), identifier: elementFromQuery.identifier)
        } else {
            element = query.element
        }

        let id = cache.add(element: element)

        return ElementPayload(serverId: id)
    }

    @MainActor
    func elementMatchingPredicate(predicateRequest: PredicateRequest) async throws -> ElementPayload {
        let query = try cache.getElementQuery(predicateRequest.serverId)

        let element = query.element(matching: predicateRequest.predicate)

        let id = cache.add(element: element)

        return ElementPayload(serverId: id)
    }

    @MainActor
    func matchingPredicate(predicateRequest: PredicateRequest) async throws -> QueryResponse {
        let query = try cache.getElementQuery(predicateRequest.serverId)
        let matching = query.matching(predicateRequest.predicate)
        let id = cache.add(query: matching)
        return QueryResponse(serverId: id)
    }

    @MainActor
    func matchingByIdentifier(request: ByIdRequest) async throws -> QueryResponse {
        let query = try cache.getElementQuery(request.queryRoot)
        let matching = query.matching(identifier: request.identifier)
        let id = cache.add(query: matching)
        return QueryResponse(serverId: id)
    }

    @MainActor
    func containingPredicate(request: PredicateRequest) async throws -> QueryResponse {
        let query = try cache.getElementQuery(request.serverId)
        let matching = query.containing(request.predicate)
        let id = cache.add(query: matching)
        return QueryResponse(serverId: id)
    }

    @MainActor
    func containingElementType(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let query = rootQuery.containing(request.elementType.toXCUIElementType(), identifier: request.identifier)

        let id = cache.add(query: query)

        return QueryResponse(serverId: id)
    }

    @MainActor
    func typeText(request: EnterTextRequest) async throws {
        let element = try cache.getElement(request.serverId)
        element.typeText(request.textToEnter)
    }

    @MainActor
    func value(request: ElementPayload) async throws -> ValueResponse {
        let element = try cache.getElement(request.serverId)
        let value = element.value as? String

        return ValueResponse(value: value)
    }

    @MainActor
    func scroll(request: ScrollRequest) async throws {
        let element = try cache.getElement(request.serverId)
        element.scroll(byDeltaX: request.deltaX, deltaY: request.deltaY)
    }

    @MainActor
    func swipe(request: SwipeRequest) async throws {
        let element = try cache.getElement(request.serverId)

        let velocity = request.velocity.xcUIGestureVelocity

        switch request.swipeDirection {
        case .left:
            element.swipeLeft(velocity: velocity)
        case .right:
            element.swipeRight(velocity: velocity)
        case .up:
            element.swipeUp(velocity: velocity)
        case .down:
            element.swipeDown(velocity: velocity)
        }
    }

    @MainActor
    func pinch(request: PinchRequest) async throws {
        let element = try cache.getElement(request.serverId)
        element.pinch(withScale: request.scale, velocity: request.velocity)
    }

    @MainActor
    func rotate(request: RotateRequest) async throws {
        let element = try cache.getElement(request.serverId)
        element.rotate(request.rotation, withVelocity: request.velocity)
    }

    @MainActor
    func isHittable(request: ElementPayload) async throws -> IsHittableResponse {
        let isHittable = try cache.getElement(request.serverId).isHittable
        return IsHittableResponse(isHittable: isHittable)
    }

    @MainActor
    func count(request: CountRequest) async throws -> CountResponse {
        let count: Int = try (cache.getElementQuery(request.serverId)).count
        return CountResponse(count: count)
    }

    @MainActor
    func queryDescendants(request: DescendantsFromQuery) async throws -> QueryResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let descendantsQuery = rootQuery.descendants(matching: request.elementType.toXCUIElementType())

        let id = cache.add(query: descendantsQuery)

        return QueryResponse(serverId: id)
    }

    @MainActor
    func elementDescendants(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootElement = try cache.getElement(request.serverId)
        let descendantsQuery = rootElement.descendants(matching: request.elementType.toXCUIElementType())

        let id = cache.add(query: descendantsQuery)

        return QueryResponse(serverId: id)
    }

    @MainActor
    func matchingElementType(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let descendantsQuery = rootQuery.matching(request.elementType.toXCUIElementType(), identifier: request.identifier)
        let id = cache.add(query: descendantsQuery)
        return QueryResponse(serverId: id)
    }

    @MainActor
    func allElementsBoundByAccessibilityElement(request: ElementsByAccessibility) async throws -> ElementArrayResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let allElements = rootQuery.allElementsBoundByAccessibilityElement

        let ids = cache.add(elements: allElements)

        return ElementArrayResponse(serversId: ids)
    }

    @MainActor
    func allElementsBoundByIndex(request: ElementsByAccessibility) async throws -> ElementArrayResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let allElements = rootQuery.allElementsBoundByIndex

        let ids = cache.add(elements: allElements)

        return ElementArrayResponse(serversId: ids)
    }

    @MainActor
    func children(request: ChildrenMatchinType) async throws -> QueryResponse {
        var childrenQuery: XCUIElementQuery

        if let rootQuery = try? cache.getElementQuery(request.serverId) {
            childrenQuery = rootQuery.children(matching: request.elementType.toXCUIElementType())
        } else if let rootElement = try? cache.getElement(request.serverId) {
            childrenQuery = rootElement.children(matching: request.elementType.toXCUIElementType())
        } else {
            throw ElementNotFoundError(serverId: request.serverId.uuidString)
        }

        let id = cache.add(query: childrenQuery)

        return QueryResponse(serverId: id)
    }

    @MainActor
    func element(request: ByIdRequest) async throws -> ElementPayload {
        let newElement = try await findElement(elementRequest: request)
        let id = cache.add(element: newElement)
        return ElementPayload(serverId: id)
    }

    @MainActor
    func query(request: QueryRequest) async throws -> QueryResponse {
        let newQuery = try await performQuery(queryRequest: request)
        let serverId = cache.add(query: newQuery)
        return QueryResponse(serverId: serverId)
    }

    @MainActor
    func remove(request: ElementPayload) async -> Bool {
        cache.remove(request.serverId)

        return true
    }

    @MainActor
    func accessibilityTest(request: ElementPayload) async throws -> Bool {
        let application = try cache.getApplication(request.serverId)

        if #available(iOS 17.0, *) {
            return (try? application.performAccessibilityAudit()) != nil
        } else {
            return false
        }
    }

    func buildResponse(_ data: some Codable) -> HTTPResponse {
        if let lastIssue {
            return buildError(lastIssue.detailedDescription ?? lastIssue.description)
        } else {
            return HTTPResponse(statusCode: .ok, body: try! encoder.encode(UIResponse(response: data)))
        }
    }

    func buildError(_ error: String) -> HTTPResponse {
        return HTTPResponse(statusCode: .badRequest, body: try! encoder.encode(UIResponse<Bool>(error: error)))
    }

    func findElement(elementRequest: ByIdRequest) async throws -> XCUIElement {
        let rootElementQuery = try cache.getElementQuery(elementRequest.queryRoot)

        return rootElementQuery[elementRequest.identifier]
    }
}

public extension UInt {
    func toXCUIElementType() -> XCUIElement.ElementType {
        XCUIElement.ElementType(rawValue: self)!
    }
}

extension UInt64 {
    @available(iOS 17.0, *)
    func toXCUIAccessibilityAuditType() -> XCUIAccessibilityAuditType {
        return XCUIAccessibilityAuditType(rawValue: self)
    }
}

extension AccessibilityAuditIssueData {
    @available(iOS 17.0, *)
    @MainActor
    init(xcIssue: XCUIAccessibilityAuditIssue, cache: Cache) {
        var elementId: UUID?
        if let element = xcIssue.element {
            elementId = cache.add(element: element)
        }
        self.init(
            element: elementId,
            compactDescription: xcIssue.compactDescription,
            detailedDescription: xcIssue.detailedDescription,
            auditType: xcIssue.auditType.rawValue
        )
    }
}

extension UIServer {
    @MainActor
    func performQuery(queryRequest: QueryRequest) async throws -> XCUIElementQuery {
        let rootElementQuery = try cache.getQuery(queryRequest.serverId)
        return rootElementQuery.queryBy(queryRequest.queryType)
    }
}
