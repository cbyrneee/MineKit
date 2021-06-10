import XCTest
@testable import MineKit

final class MineKitTests: XCTestCase {
    func testConnection() throws {
        let minekit = MineKit()
        try minekit.connect(to: ServerDetails(address: "127.0.0.1"), using: .status)
    }
}
