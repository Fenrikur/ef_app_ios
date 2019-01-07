//
//  FakeMapsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class FakeMapsService: MapsService {

    let maps = [Map].random
    func add(_ observer: MapsObserver) {
        observer.mapsServiceDidChangeMaps(maps)
    }

    func fetchImagePNGDataForMap(identifier: MapIdentifier, completionHandler: @escaping (Data) -> Void) {
        completionHandler(imagePNGDataForMap(identifier: identifier))
    }

    struct ContentRequest: Equatable {
        static func == (lhs: FakeMapsService.ContentRequest, rhs: FakeMapsService.ContentRequest) -> Bool {
            return lhs.identifier == rhs.identifier && lhs.x == rhs.x && lhs.y == rhs.y
        }

        var identifier: MapIdentifier
        var x: Int
        var y: Int
        var completionHandler: (MapContent) -> Void
    }

    fileprivate var requests = [ContentRequest]()
    func fetchContent(for identifier: MapIdentifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (MapContent) -> Void) {
        requests.append(ContentRequest(identifier: identifier, x: x, y: y, completionHandler: completionHandler))
    }

}

extension FakeMapsService {

    func imagePNGDataForMap(identifier: MapIdentifier) -> Data {
        return identifier.rawValue.data(using: .utf8)!
    }

    func resolveMapContents(identifier: MapIdentifier, atX x: Int, y: Int, with mapContent: MapContent) {
        guard let request = requests.first(where: { $0.identifier == identifier && $0.x == x && $0.y == y }) else { return }
        request.completionHandler(mapContent)
    }

}
