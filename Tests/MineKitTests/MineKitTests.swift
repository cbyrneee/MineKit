import XCTest
@testable import MineKit

final class MineKitTests: XCTestCase {
    func testConnection() throws {
        let minekit = MineKit()
        try minekit.connect(server: ServerDetails(address: "starship.dedi.koding.dev"))
    }
}
