//
//  API.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 17/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol API {

    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void)

    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void)

    func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void)

    func loadPrivateMessages(authorizationToken: String, completionHandler: @escaping ([MessageCharacteristics]?) -> Void)

    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String)

}

public struct LoginRequest {

    public var regNo: Int
    public var username: String
    public var password: String

    public init(regNo: Int, username: String, password: String) {
        self.regNo = regNo
        self.username = username
        self.password = password
    }

}