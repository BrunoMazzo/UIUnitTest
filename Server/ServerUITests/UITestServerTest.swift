import XCTest
import FlyingFox

final class UITestServerTest: XCTestCase {
    
    override func record(_ issue: XCTIssue) {
        MainActor.assumeIsolated { [server] in
            server!.lastIssue = issue
        }
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
    
        self.server = UIServer()
        
        do {
            try await self.server.start(portIndex: UInt16(deviceId()))
        } catch {
            print("SERVER ERROR ----------------------------------")
            print(error.localizedDescription)
            print("SERVER ERROR ----------------------------------")
        }
    }
    
    @MainActor
    func deviceId() -> Int {
        let deviceName = UIDevice.current.name
        
        var deviceId = 0
        let regulerExpression = try! NSRegularExpression(pattern: "Clone (\\d*) of .*")
        
        if let devicesNameMatch = regulerExpression.firstMatch(in: deviceName, range: NSRange(location: 0, length: deviceName.utf16.count)) {
            if let swiftRange = Range(devicesNameMatch.range(at: 1), in: deviceName) {
                let deviceIdString = deviceName[swiftRange]
                deviceId = Int(deviceIdString) ?? 0
            }
        }
        
        return deviceId
    }
}
