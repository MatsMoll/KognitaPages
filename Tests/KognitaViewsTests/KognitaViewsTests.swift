import XCTest
@testable import KognitaViews
import HTMLKit


final class KognitaViewsTests: XCTestCase {

    lazy var renderer: HTMLRenderer = {
        var renderer = HTMLRenderer()
        try! renderer.add(template: StarterPage())
        return renderer
    }()

    func testLandingPage() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let page = try renderer.renderRaw(StarterPage.self, with: .init())

        XCTAssert(page.contains("href='/signup'"), "The landing page is missing a link to the signup page")
        XCTAssert(page.contains("href='/login'"), "The landing page is missing a link to the login page")
    }

    static var allTests = [
        ("testLandingPage", testLandingPage),
    ]
}
