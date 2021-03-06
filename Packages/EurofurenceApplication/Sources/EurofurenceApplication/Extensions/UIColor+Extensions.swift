import UIKit

extension UIColor {
    
    static func adaptiveColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: { (traitCollection) in
                if traitCollection.userInterfaceStyle == .light {
                    return lightColor
                } else {
                    return darkColor
                }
            })
        } else {
            return lightColor
        }
    }
    
    static let tintColor = adaptiveColor(lightColor: .pantone330U, darkColor: .pantone330U_45)
    static let disabledColor = safeSystemGray
    static let placeholder = adaptiveColor(lightColor: .pantone330U, darkColor: safeSystemGray2)
    static let navigationBar = barColor
    static let tabBar = barColor
    static let searchBarTint = pantone330U
    static let refreshControl = pantone330U_13
    static let selectedTabBarItem = adaptiveColor(lightColor: .white, darkColor: .pantone330U_45)
    static let unselectedTabBarItem = adaptiveColor(lightColor: .pantone330U_45, darkColor: .darkGray)
    static let primary = adaptiveColor(lightColor: .pantone330U, darkColor: .black)
    static let secondary = adaptiveColor(lightColor: .pantone330U_45, darkColor: .secondaryDarkColor)
    static let buttons = pantone330U
    static let tableIndex = pantone330U
    static let iconographicTint = pantone330U
    static let unreadIndicator = pantone330U
    static let selectedSegmentText = adaptiveColor(lightColor: .pantone330U, darkColor: .white)
    static let selectedSegmentBackground = adaptiveColor(lightColor: .white, darkColor: .safeSystemGray)
    static let unselectedSegmentText = adaptiveColor(lightColor: .white, darkColor: .white)
    static let unselectedSegmentBackground = adaptiveColor(lightColor: .pantone330U_45, darkColor: .safeSystemGray3)
    static let segmentSeperator = adaptiveColor(lightColor: .white, darkColor: .safeSystemGray)
    static let safariBarTint = navigationBar
    static let safariControlTint = white
    static let userPrompt = adaptiveColor(
        lightColor: UIColor(white: 0.5, alpha: 1.0),
        darkColor: .safeSystemGray
    )
    
    static let userPromptWithUnreadMessages = pantone330U
    
    private static let barColor: UIColor = adaptiveColor(lightColor: .pantone330U, darkColor: calendarStyleBarColor)
    
    private static var calendarStyleBarColor: UIColor {
        scaled(red: 18, green: 19, blue: 18)
    }
    
    private static var secondaryDarkColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .opaqueSeparator
        } else {
            return .black
        }
    }()
    
    private static var safeSystemGray: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray
        } else {
            return .lightGray
        }
    }
    
    private static var safeSystemGray2: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray2
        } else {
            return .lightGray
        }
    }
    
    private static var safeSystemGray3: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray3
        } else {
            return .darkGray
        }
    }
    
    static let pantone330U = unsafelyNamed("Pantone 330U")
    static let pantone330U_45 = unsafelyNamed("Pantone 330U (45%)")
    static let pantone330U_26 = unsafelyNamed("Pantone 330U (26%)")
    static let pantone330U_13 = unsafelyNamed("Pantone 330U (13%)")
    static let pantone330U_5 = unsafelyNamed("Pantone 330U (5%)")
    static let largeActionButton = unsafelyNamed("Large Action Button")
    
    private static func scaled(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        let scale: (CGFloat) -> CGFloat = { $0 / 255.0 }
        return UIColor(red: scale(red), green: scale(green), blue: scale(blue), alpha: 1.0)
    }
    
    func makeColoredImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    func makePixel() -> UIImage {
        makeColoredImage(size: CGSize(width: 1, height: 1))
    }
    
    static func unsafelyNamed(_ name: String) -> UIColor {
        guard let color = UIColor(named: name, in: .module, compatibleWith: nil) else {
            fatalError("Color named \(name) missing from xcassets")
        }
        
        return color
    }

}
