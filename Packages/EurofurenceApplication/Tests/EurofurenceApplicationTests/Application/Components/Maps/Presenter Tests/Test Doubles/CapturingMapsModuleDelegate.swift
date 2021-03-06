import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingMapsComponentDelegate: MapsComponentDelegate {

    private(set) var capturedMapIdentifierToPresent: MapIdentifier?
    func mapsComponentDidSelectMap(identifier: MapIdentifier) {
        capturedMapIdentifierToPresent = identifier
    }

}
