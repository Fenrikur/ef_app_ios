//
//  WhenToldToOpenNotification_ThatRepresentsSyncEvent_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenToldToOpenNotification_ThatRepresentsSyncEvent_ApplicationShould: XCTestCase {

    var context: ApplicationTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = ApplicationTestBuilder().build()
    }

    private func simulateSyncPushNotification(_ handler: @escaping (ApplicationPushActionResult) -> Void) {
        let payload: [String: String] = ["event": "sync"]
        context.application.handleRemoteNotification(payload: payload, completionHandler: handler)
    }

    func testRefreshTheLocalStore() {
        simulateSyncPushNotification { (_) in }
        XCTAssertTrue(context.syncAPI.didBeginSync)
    }

    func testProvideSyncSuccessResultWhenDownloadSucceeds() {
        var result: ApplicationPushActionResult?
        simulateSyncPushNotification { result = $0 }
        context.syncAPI.simulateSuccessfulSync(.randomWithoutDeletions)

        XCTAssertEqual(.successfulSync, result)
    }

    func testProideSyncFailedResponseWhenDownloadFails() {
        var result: ApplicationPushActionResult?
        simulateSyncPushNotification { result = $0 }
        context.syncAPI.simulateUnsuccessfulSync()

        XCTAssertEqual(.failedSync, result)
    }

}
