import XCTest

final class UITestServerTest: XCTestCase {
    
    override func record(_ issue: XCTIssue) {
        self.server.lastIssue = issue
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    var server: UIServer!
    
    @MainActor
    func testStart() async throws {
        let deviceName = UIDevice.current.name
        
        var deviceId = 0
        if let devicesNameMatch = deviceName.range(of: "Clone (\\d*) of .*", options: .regularExpression) {
            let deviceIdString = String(deviceName[devicesNameMatch])
            deviceId = Int(deviceIdString) ?? 0
        }
        
        self.server = UIServer()
        
        do {
            try await self.server.start(portIndex: UInt16(deviceId))
        } catch {
            print("SERVER ERROR ----------------------------------")
            print(error.localizedDescription)
            print("SERVER ERROR ----------------------------------")
        }
    }
}
