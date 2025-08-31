//
//  CoinListView_UITests.swift
//  CryptoPricesUITests
//
//  Created by Nilusha Niwanthaka Wimalasena on 29/8/25.
//

import XCTest

final class CoinListView_UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    func test_CoinListView_SearchBarAndOtherComponents_ShouldExist() {

        let coinListSearchBarTextField = app/*@START_MENU_TOKEN@*/.textFields["CoinList_SearchBar"]/*[[".otherElements",".textFields[\"Search by name or symbol\"]",".textFields[\"CoinList_SearchBar\"]",".textFields.firstMatch"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(coinListSearchBarTextField.waitForExistence(timeout: 5), "Search bar should be visible")
        
        let title = app.staticTexts["CoinList_Title"]
        XCTAssertTrue(title.waitForExistence(timeout: 2), "Title should be visible")
        
        let menuButton = app.buttons["CoinList_MenuButton"]
        XCTAssertTrue(menuButton.waitForExistence(timeout: 2), "Menu button should be visible")
    }
    
    func test_CoinListView_CoinRows_ShouldDisplayCoins() {

        let firstCoinRow = app.buttons["CoinList_Row_binancecoin"].firstMatch
        XCTAssertTrue(firstCoinRow.waitForExistence(timeout: 5), "Coin rows should be visible with mock data")
    }
    
    func test_CoinListView_SearchFunctionality_ShouldFilterResults() {

        let searchBar = app.textFields["CoinList_SearchBar"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5))

        searchBar.tap()
        searchBar.typeText("BNB")

        let bitcoinRow = app.buttons["CoinList_Row_binancecoin"]
        XCTAssertTrue(bitcoinRow.waitForExistence(timeout: 3), "BNB should be in search results")

    }
    
    func test_CoinListView_MenuButton_ShouldToggleMenu() {

        let menuButton = app.buttons["CoinList_MenuButton"]
        XCTAssertTrue(menuButton.waitForExistence(timeout: 5))

        menuButton.tap()

        let settingsRow = app.otherElements.staticTexts["Settings"]
        XCTAssertTrue(settingsRow.waitForExistence(timeout: 2), "Settings row should appear")
    }
    
    func test_CoinListView_MenuButton_NavigateToSettings_ShouldGoToDetails() {

        let menuButton = app.buttons["CoinList_MenuButton"]
        XCTAssertTrue(menuButton.waitForExistence(timeout: 5))

        menuButton.tap()

        let settingsRow = app.otherElements.staticTexts["Settings"]
        XCTAssertTrue(settingsRow.waitForExistence(timeout: 2), "Settings row should appear")
        settingsRow.tap()
        
        let appVersion = app.staticTexts["App Version"]
        XCTAssertTrue(appVersion.waitForExistence(timeout: 2), "Settings view should be visible")
        
        let backButton = app.buttons["Back"]
        if backButton.waitForExistence(timeout: 2) {
            backButton.firstMatch.tap()
        }
        
        let coinListTitle = app.staticTexts["CoinList_Title"]
        XCTAssertTrue(coinListTitle.waitForExistence(timeout: 3), "Should be back on coin list view")
    }
    
    func test_CoinListView_Navigation_ShouldGoToDetail() {

        let bnbRowText = app.staticTexts["CoinRow_Name_binancecoin"]
        XCTAssertTrue(bnbRowText.waitForExistence(timeout: 5))

        bnbRowText.tap()

        let detailView = app.otherElements["CoinDetail_AllTimeStatsSection_binancecoin"]
        XCTAssertTrue(detailView.waitForExistence(timeout: 2), "Should navigate to coin detail view")
        
        let backButton = app.buttons["Back"]
        if backButton.waitForExistence(timeout: 2) {
            backButton.tap()
        }

        let coinListTitle = app.staticTexts["CoinList_Title"]
        XCTAssertTrue(coinListTitle.waitForExistence(timeout: 3), "Should be back on coin list view")
    }
}


