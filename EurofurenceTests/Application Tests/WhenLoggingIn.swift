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
    
    private func makeLoginResponse(uid: String = "",
                                   username: String = "",
                                   token: String = "",
                                   tokenValidUntil: Date = Date()) -> APILoginResponse {
        return StubLoginResponse(uid: uid, username: username, token: token, tokenValidUntil: tokenValidUntil)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedUsername() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        
        XCTAssertEqual(expectedUsername, context.loginAPI.capturedLoginArguments?.username)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedRegNo() {
        let context = ApplicationTestBuilder().build()
        let expectedRegNo = 42
        context.login(registrationNumber: expectedRegNo)
        
        XCTAssertEqual(expectedRegNo, context.loginAPI.capturedLoginArguments?.regNo)
    }
    
    func testLoggingInShouldAttemptLoginWithProvidedPassword() {
        let context = ApplicationTestBuilder().build()
        let expectedPassword = "Some awesome password"
        context.login(password: expectedPassword)
        
        XCTAssertEqual(expectedPassword, context.loginAPI.capturedLoginArguments?.password)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUsername() {
        let context = ApplicationTestBuilder().build()
        let expectedUsername = "Some awesome guy"
        context.login(username: expectedUsername)
        context.loginAPI.simulateResponse(makeLoginResponse(username: expectedUsername))
        
        XCTAssertEqual(expectedUsername, context.capturingLoginCredentialsStore.capturedCredential?.username)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithUserIDFromLoginRequest() {
        let context = ApplicationTestBuilder().build()
        let expectedUserID = 42
        context.login(registrationNumber: expectedUserID)
        context.loginAPI.simulateResponse(makeLoginResponse(uid: "Something else"))
        
        XCTAssertEqual(expectedUserID, context.capturingLoginCredentialsStore.capturedCredential?.registrationNumber)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithLoginToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingLoginCredentialsStore.capturedCredential?.authenticationToken)
    }
    
    func testLoggingInSuccessfullyShouldPersistLoginCredentialWithTokenExpiry() {
        let context = ApplicationTestBuilder().build()
        let expectedTokenExpiry = Date.distantFuture
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(tokenValidUntil: expectedTokenExpiry))
        
        XCTAssertEqual(expectedTokenExpiry, context.capturingLoginCredentialsStore.capturedCredential?.tokenExpiryDate)
    }
    
    func testLoggingInSuccessfulyShouldNotifyObserversAboutIt() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutItUntilTokenPersistenceCompletes() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.capturingLoginCredentialsStore.blockToRunBeforeCompletingCredentialStorage = {
            XCTAssertFalse(loginObserver.notifiedLoginSucceeded)
        }
        
        context.application.add(loginObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
    }
    
    func testLoggingInSuccessfulyShouldNotNotifyObserversAboutLoginFailure() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertFalse(loginObserver.notifiedLoginFailed)
    }
    
    func testBeingLoggedInThenLoggingInShouldNotifyObserverLoginSuccessful() {
        let credential = LoginCredential(username: "",
                                         registrationNumber: 0,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        
        XCTAssertTrue(loginObserver.notifiedLoginSucceeded)
    }
    
    func testBeingLoggedInThenLoggingInShouldNotRequestTheAPIToLogin() {
        let credential = LoginCredential(username: "",
                                         registrationNumber: 0,
                                         authenticationToken: "",
                                         tokenExpiryDate: .distantFuture)
        let context = ApplicationTestBuilder().with(credential).build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        
        XCTAssertNil(context.loginAPI.capturedLoginArguments)
    }
    
    func testLoggingInSuccessfullyThenRegisteringPushTokenShouldProvideAuthTokenWithPushRegistration() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        context.application.registerRemoteNotifications(deviceToken: Data())
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testLoggingInAfterRegisteringPushTokenShouldReRegisterThePushTokenWithTheUserAuthenticationToken() {
        let context = ApplicationTestBuilder().build()
        let expectedToken = "JWT Token"
        context.application.registerRemoteNotifications(deviceToken: Data())
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse(token: expectedToken))
        
        XCTAssertEqual(expectedToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testRemovingTheObserverThenLoggingInShouldNotTellTheObserverAboutIt() {
        let context = ApplicationTestBuilder().build()
        let loginObserver = CapturingLoginObserver()
        context.application.add(loginObserver)
        context.login()
        context.application.remove(loginObserver)
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertFalse(loginObserver.notifiedLoginSucceeded)
    }
    
    func testAddingAuthenticationObserverAfterBeingLoggedInShouldTellItWeAreLoggedIn() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        context.application.add(authenticationStateObserver)
        
        XCTAssertTrue(authenticationStateObserver.didLogIn)
    }
    
    func testLoggingInShouldTellAuthenticationStateObserversWeAreLoggedIn() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        context.login()
        context.loginAPI.simulateResponse(makeLoginResponse())
        
        XCTAssertTrue(authenticationStateObserver.didLogIn)
    }
    
    func testLoggingInShouldNotTellAuthenticationStateObserversWeAreLoggedInUntilLoginSucceeds() {
        let context = ApplicationTestBuilder().build()
        let authenticationStateObserver = CapturingAuthenticationStateObserver()
        context.application.add(authenticationStateObserver)
        context.login()
        
        XCTAssertFalse(authenticationStateObserver.didLogIn)
    }
    
}
