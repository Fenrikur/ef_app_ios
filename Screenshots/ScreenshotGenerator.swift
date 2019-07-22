import XCTest

class ScreenshotGenerator: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    private func navigateToRootTabController() {
        let newsTabBarItem = app.tabBars.buttons["News"]
        guard !newsTabBarItem.exists else {
            return
        }

        if app.alerts.element.collectionViews.buttons["Allow"].exists {
            app.tap()
        }

        let beginDownloadButton = app.buttons["Begin Download"]
        if beginDownloadButton.exists {
            beginDownloadButton.tap()
        }

        let beganWaitingAt = Date()
        var waitingForTabItemToAppear = true
        var totalWaitTimeSeconds: TimeInterval = 0
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
            waitingForTabItemToAppear = !newsTabBarItem.exists
            totalWaitTimeSeconds = Date().timeIntervalSince(beganWaitingAt)
        } while waitingForTabItemToAppear && totalWaitTimeSeconds < 30
    }

    func testScreenshots() {
        navigateToRootTabController()
        
        snapshot("01_News")

        app.tabBars.buttons["Schedule"].tap()
        app.tables.firstMatch.swipeDown()
        
        snapshot("02_Schedule")
        
        let searchField = app.searchFields["Search"]
        searchField.tap()
        searchField.typeText("comic")
        app.tables["Search results"].staticTexts["ECC Room 4"].tap()
        
        if app.tables.buttons["Add to Favourites"].exists {
            app.tables.buttons["Add to Favourites"].tap()
        }
        
        snapshot("03_EventDetail")
        
        app.tabBars.buttons["Dealers"].tap()
        
        snapshot("04_Dealers")
        
        app.tables.staticTexts["Eurofurence Shop"].tap()
        
        snapshot("05_DealerDetail")
        
        app.tabBars.buttons["Information"].tap()
        
        snapshot("06_Information")
    }

}