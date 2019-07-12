import UserNotifications

class AppNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        ApplicationStack.handleRemoteNotification(notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        ApplicationStack.openNotification(response.notification.request.content.userInfo, completionHandler: completionHandler)
    }
    
    // MARK: Setup
    
    static let instance = AppNotificationDelegate()
    
    override private init() {
        
    }
    
    func prepare() {
        prepareNotificationHandler()
        requestNotificationPermissions()
    }
    
    private func prepareNotificationHandler() {
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermissions()
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, error) in
            if let error = error {
                print("Failed to register for notifications with error: \(error)")
            }
        }
    }
    
}
