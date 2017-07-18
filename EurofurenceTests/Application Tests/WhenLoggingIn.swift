//
//  WhenLoggingIn.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoggingIn: XCTestCase {
    
    func testTheLoginEndpointShouldReceievePOSTRequest() {
        let context = ApplicationTestBuilder().build()
        context.application.login(registrationNumber: 0, username: "", password: "")
        
        XCTAssertEqual("https://app.eurofurence.org/api/v2/Tokens/RegSys", context.jsonPoster.postedURL)
    }
    
    func testTheLoginEndpointShouldNotReceievePOSTRequestUntilCallingLogin() {
        let context = ApplicationTestBuilder().build()
        XCTAssertNil(context.jsonPoster.postedURL)
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithRegNo() {
        let context = ApplicationTestBuilder().build()
        let registrationNumber = 42
        context.application.login(registrationNumber: registrationNumber, username: "", password: "")
        
        XCTAssertEqual(registrationNumber, context.jsonPoster.postedJSONValue(forKey: "RegNo"))
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithUsername() {
        let context = ApplicationTestBuilder().build()
        let username = "Some awesome guy"
        context.application.login(registrationNumber: 0, username: username, password: "")
        
        XCTAssertEqual(username, context.jsonPoster.postedJSONValue(forKey: "Username"))
    }
    
    func testTheLoginRequestShouldReceieveJSONPayloadWithPassword() {
        let context = ApplicationTestBuilder().build()
        let password = "It's a secrent"
        context.application.login(registrationNumber: 0, username: "", password: password)
        
        XCTAssertEqual(password, context.jsonPoster.postedJSONValue(forKey: "Password"))
    }
    
}
