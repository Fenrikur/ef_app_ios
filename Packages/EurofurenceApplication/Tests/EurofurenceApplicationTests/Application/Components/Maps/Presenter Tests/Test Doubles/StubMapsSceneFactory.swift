import EurofurenceApplication
import EurofurenceModel
import UIKit

class StubMapsSceneFactory: MapsSceneFactory {

    let scene = CapturingMapsScene()
    func makeMapsScene() -> UIViewController & MapsScene {
        return scene
    }

}
