import UIKit

class ConventionBrandedTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    static let identifier = "Header"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        backgroundView = ConventionSecondaryColorView()
    }
    
}
