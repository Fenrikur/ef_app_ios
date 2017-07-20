//
//  UserAuthenticationObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol UserAuthenticationObserver: class {

    func userAuthenticationAuthorized()
    func userAuthenticationUnauthorized()

}
