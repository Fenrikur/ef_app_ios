import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController

class StubScheduleSceneFactory: ScheduleSceneFactory {

    let scene = CapturingScheduleScene()
    func makeEventsScene() -> UIViewController & ScheduleScene {
        return scene
    }

}
