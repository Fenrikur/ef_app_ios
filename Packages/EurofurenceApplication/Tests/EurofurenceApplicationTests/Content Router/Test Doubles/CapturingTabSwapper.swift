import EurofurenceApplication

class CapturingTabSwapper: TabNavigator {
    
    private(set) var didMoveToTab = false
    func moveToTab() {
        didMoveToTab = true
    }
    
}
