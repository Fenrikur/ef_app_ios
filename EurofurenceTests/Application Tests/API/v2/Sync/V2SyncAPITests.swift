//
//  V2SyncAPITests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class V2SyncAPITests: XCTestCase {
    
    func testTheSyncEndpointShouldReceieveRequest() {
        let jsonSession = CapturingJSONSession()
        let syncApi = V2SyncAPI(jsonSession: jsonSession)
        let url = "https://app.eurofurence.org/api/v2/Sync"
        syncApi.fetchLatestData { (_) in }
        
        XCTAssertEqual(url, jsonSession.getRequestURL)
    }
    
    func testInvalidResponseEmitsNilResult() {
        let jsonSession = CapturingJSONSession()
        let syncApi = V2SyncAPI(jsonSession: jsonSession)
        let invalidResponseData = "{not json!".data(using: .utf8)
        var providedWithNilResponse = false
        syncApi.fetchLatestData { providedWithNilResponse = $0 == nil }
        jsonSession.invokeLastGETCompletionHandler(responseData: invalidResponseData)
        
        XCTAssertTrue(providedWithNilResponse)
    }
    
    func testSuccessfulResponseDoesNotEmitNilResponse() {
        let jsonSession = CapturingJSONSession()
        let syncApi = V2SyncAPI(jsonSession: jsonSession)
        let responseDataURL = Bundle(for: V2SyncAPITests.self).url(forResource: "V2SyncAPIResponse", withExtension: "json")!
        let responseData = try! Data(contentsOf: responseDataURL)
        let providedWithNilResponseExpectation = expectation(description: "Should not be provided with nil response when parsing valid sync response")
        providedWithNilResponseExpectation.isInverted = true
        syncApi.fetchLatestData { if $0 == nil { providedWithNilResponseExpectation.fulfill() } }
        jsonSession.invokeLastGETCompletionHandler(responseData: responseData)
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testFailedNetworkResponseEmitsNilResult() {
        let jsonSession = CapturingJSONSession()
        let syncApi = V2SyncAPI(jsonSession: jsonSession)
        var providedWithNilResponse = false
        syncApi.fetchLatestData { providedWithNilResponse = $0 == nil }
        jsonSession.invokeLastGETCompletionHandler(responseData: nil)
        
        XCTAssertTrue(providedWithNilResponse)
    }
    
}