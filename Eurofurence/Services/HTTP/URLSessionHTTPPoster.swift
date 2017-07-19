//
//  URLSessionJSONPoster.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct URLSessionJSONPoster: JSONPoster {

    var session: URLSession = .shared

    func post(_ url: String, body: Data, headers: [String : String], completionHandler: @escaping (Data?) -> Void) {
        guard let actualURL = URL(string: url) else { return }

        var request = URLRequest(url: actualURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body
        request.allHTTPHeaderFields = headers

        session.dataTask(with: request, completionHandler: { (_, _, _) in }).resume()
    }

}
