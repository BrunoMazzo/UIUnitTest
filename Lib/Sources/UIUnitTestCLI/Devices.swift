import Foundation

struct DeviceList: Codable {
    var devices: [String: [Device]]
}

struct Device: Codable {
    var name: String
    var udid: String
    var isAvailable: Bool
    var state: String
    var deviceTypeIdentifier: String
}

//@available(macOS 12.0, *)
//func openDevices() async -> [Device] {
//    let data = await executeShellCommand2("xcrun simctl list devices -j 2> /dev/null")
//    let decoder = JSONDecoder()
//
//    let deviceList = try! decoder.decode(DeviceList.self, from: data.data(using: .utf8)!)
//
//    return deviceList.devices.flatMap { (key: String, value: [Device]) -> [Device] in
//        value.flatMap { device -> [Device] in
//            guard device.state == "Booted" else {
//                return []
//            }
//
//            return [device]
//        }
//    }
//}
//

func boot() async {
    _ = await executeShellCommand("xcrun simctl boot iPhone 14")
}
