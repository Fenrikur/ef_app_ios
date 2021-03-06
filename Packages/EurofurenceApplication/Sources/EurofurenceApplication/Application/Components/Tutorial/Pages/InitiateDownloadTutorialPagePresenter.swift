import EurofurenceModel
import Foundation

struct InitiateDownloadTutorialPagePresenter: TutorialPage,
                                              TutorialPageSceneDelegate {

    private var delegate: TutorialPageDelegate
    private var networkReachability: NetworkReachability
    private var alertRouter: AlertRouter

    init(delegate: TutorialPageDelegate,
         tutorialScene: TutorialScene,
         alertRouter: AlertRouter,
         presentationAssets: PresentationAssets,
         networkReachability: NetworkReachability) {
        self.delegate = delegate
        self.alertRouter = alertRouter
        self.networkReachability = networkReachability

        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageImage(presentationAssets.initialLoadInformationAsset)
        tutorialPage.showPageTitle(.tutorialInitialLoadTitle)
        tutorialPage.showPageDescription(.tutorialInitialLoadDescription)
        tutorialPage.showPrimaryActionButton()
        tutorialPage.showPrimaryActionDescription(.tutorialInitialLoadBeginDownload)
    }

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        if networkReachability.wifiReachable {
            delegate.tutorialPageCompletedByUser(self)
        } else if networkReachability.cellularReachable {
            let allowCellularDownloads = AlertAction(title: .cellularDownloadAlertContinueOverCellularTitle, action: {
                self.delegate.tutorialPageCompletedByUser(self)
            })
            
            let cancel = AlertAction(title: .cancel)

            let alert = Alert(title: .cellularDownloadAlertTitle,
                              message: .cellularDownloadAlertMessage,
                              actions: [allowCellularDownloads, cancel])
            
            alertRouter.show(alert)
        } else {
            let ok = AlertAction(title: .ok)
            let alert = Alert(title: .noNetworkAlertTitle,
                              message: .noNetworkAlertMessage,
                              actions: [ok])
            
            alertRouter.show(alert)
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
    }

}
