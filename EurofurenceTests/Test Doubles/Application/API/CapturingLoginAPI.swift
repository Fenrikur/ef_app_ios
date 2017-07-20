//
//  CapturingLoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingLoginAPI: LoginAPI {
    
    private(set) var capturedLoginArguments: APILoginParameters?
    private var handler: LoginResponseHandler?
    func performLogin(arguments: APILoginParameters,
                      completionHandler: @escaping LoginResponseHandler) {
        capturedLoginArguments = arguments
        handler = completionHandler
    }
    
    func simulateResponse(_ response: APILoginResponse) {
        handler?(.success(response))
    }
    
    func simulateFailure() {
        handler?(.failure)
    }
    
}
