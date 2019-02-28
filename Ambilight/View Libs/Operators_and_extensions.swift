import Foundation
import UIKit


extension CGFloat {
    
    func squaredSize() -> CGSize {
        return CGSize(self, self)
    }
    
    func squaredRect() -> CGRect {
        return CGRect(origin: .zero, size: self.squaredSize())
    }
    
}



extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}



extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}



extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}

//dictionary + dictionary
func +<U,T>(lhs: [U:T], rhs: [U:T]) -> [U:T]{
    var ret = lhs
    for (key, value) in rhs {
        ret[key] = value
    }
    return ret
}

// dictionary += dictionary
func +=<U,T>(lhs: inout [U:T], rhs: [U:T]) {
    for (key, value) in rhs {
        lhs[key] = value
    }
}

//array + array
func +<U>(lhs:[U], rhs: [U]) -> [U]{
    var ret = lhs
    for (value) in rhs{
        ret.append(value)
    }
    return ret
}

//array + value
func +<U>(lhs:[U], rhs: U) -> [U]{
    var ret = lhs
    ret.append(rhs)
    return ret
}

//array += array
func +=<U>(lhs:inout [U], rhs:[U]){
    for (value) in rhs{
        lhs.append(value)
    }
}

//array += value
func +=<U>(lhs:inout [U], rhs: U){
    lhs.append(rhs)
}

/**
 * Get unique element in array
 */

func uniq<S: Sequence, E: Hashable>(_ source: S) -> [E] where E==S.Iterator.Element {
    var seen: [E:Bool] = [:]
    return source.filter({ (v) -> Bool in
        return seen.updateValue(true, forKey: v) == nil
    })
}

func onUIThread (_ funcToPerform: @escaping () -> (Void)){
    DispatchQueue.main.async(execute: funcToPerform)
}

func onBackgroundThread (_ funcToPerform: @escaping () -> (Void)){
    DispatchQueue.global().async(execute: funcToPerform)
}


func memoize<T: Hashable, U>( _ body: @escaping ( (T) -> U, T ) -> U ) -> (T) -> U {
    var memo = Dictionary<T, U>()
    var result: ((T) -> U)!
    result = { x in
        if let q = memo[x] { return q }
        let r = body(result, x)
        memo[x] = r
        return r
    }
    return result
}



//: MARK: - UIKIT EXTENTIONS -

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
    
    class func showAlert(_ alert:UIAlertController) {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
}


//: MARK: - UIColor -
extension UIColor {
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    convenience init?(hexString: String) {
        guard let hex = hexString.hex else {
            return nil
        }
        self.init(hex: hex)
    }
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    
    public func lighten(_ amount:CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return  UIColor(hue: h, saturation: s * (1.0 - amount), brightness: b * (1.0 + amount), alpha: a)
    }
    
    public func darken(_ amount:CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return  UIColor(hue: h, saturation: s * (1.0 + amount), brightness: b * (1.0 - amount), alpha: a)
    }
    
    public func hsba() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)? {
        var hue: CGFloat = .nan, saturation: CGFloat = .nan, brightness: CGFloat = .nan, alpha: CGFloat = .nan
        guard self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return nil
        }
        return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    public func changedBrightness(byPercentage perc: CGFloat) -> UIColor? {
        if perc == 0 {
            return self.copy() as? UIColor
        }
        guard let hsba = hsba() else {
            return nil
        }
        let percentage: CGFloat = min(max(perc, -1), 1)
        let newBrightness = min(max(hsba.brightness + percentage, -1), 1)
        return UIColor(hue: hsba.hue, saturation: hsba.saturation, brightness: newBrightness, alpha: hsba.alpha)
    }
    
    public func lightened(byPercentage percentage: CGFloat = 0.1) -> UIColor? {
        return changedBrightness(byPercentage: percentage)
    }
    
    public func darkened(byPercentage percentage: CGFloat = 0.1) -> UIColor? {
        return changedBrightness(byPercentage: -percentage)
    }
    
    public func changedSaturation(byPercentage perc: CGFloat) -> UIColor? {
        if perc == 0 {
            return self.copy() as? UIColor
        }
        guard let hsba = hsba() else {
            return nil
        }
        let percentage: CGFloat = min(max(perc, -1), 1)
        let newSaturation = min(max(hsba.saturation + percentage, -1), 1)
        return UIColor(hue: hsba.hue, saturation: newSaturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }
    
    public func tinted(byPercentage percentage: CGFloat = 0.1) -> UIColor? {
        return changedSaturation(byPercentage: percentage)
    }
    
    public func shaded(byPercentage percentage: CGFloat = 0.1) -> UIColor? {
        return changedSaturation(byPercentage: -percentage)
    }
    
    
}

//: MARK: - CGColor -
extension CGColor {
    class func colorWithHex(_ hex: Int) -> CGColor { return UIColor(hex: hex).cgColor }
}




extension String {
    
    var hex: Int? {
        if self[0] == "#"{
            let subtracted = self.dropFirst()
            return Int(subtracted, radix: 16)
        } else {
            return Int(self, radix: 16)
        }
    }
    
    public var size : CGSize {
        get {
            let newSize : CGSize = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .footnote)])
            return CGSize(width: newSize.width.rounded(),height: newSize.height.rounded())
        }
    }
    // With Text Syle
    public func size(withStyle style: UIFont.TextStyle) -> CGSize {
        let attributes = [NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: style),]
        let attString = NSAttributedString(string: self,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        let frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), nil)
        return CGSize(width: frameSize.width.rounded(), height: frameSize.height.rounded())
    }
    
    public func width(withStyle style: UIFont.TextStyle) -> CGFloat {
        return self.size(withStyle: style).width
    }
    
    public func height(withStyle style: UIFont.TextStyle) -> CGFloat {
        return self.size(withStyle: style).height
    }
    
    
    // With Font
    public func size(withFont font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font:font]
        let attString = NSAttributedString(string: self,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        let frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), nil)
        return CGSize(width: frameSize.width.rounded(), height: frameSize.height.rounded())
    }
    
    public func width(withFont font: UIFont) -> CGFloat {
        return self.size(withFont: font).width
    }
    
    public func height(withFont font: UIFont) -> CGFloat {
        return self.size(withFont: font).height
    }
    
    
    public func getSizeWithStyle(_ style: UIFont.TextStyle) -> CGSize {
        let newSize : CGSize = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: style)])
        return CGSize(width: newSize.width.rounded(),height: newSize.height.rounded())
    }
    
    public func sizeConstrainedToWidth(_ width: Double,withStyle style: UIFont.TextStyle) -> CGSize {
        let attributes = [NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: style),]
        let attString = NSAttributedString(string: self,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: Double.greatestFiniteMagnitude), nil)
    }
    
    public func getSizeUsingSystemFontSize(_ systemFontSize:CGFloat) -> CGSize {
        let newSize : CGSize = (self as NSString).size(withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: systemFontSize)])
        return CGSize(width: newSize.width.rounded(),height: newSize.height.rounded())
    }
    
    public func getLineCount(_ usingSystemFontSize:CGFloat) -> Int {
        return Int(self.getSizeUsingSystemFontSize(usingSystemFontSize).height / "X".getSizeUsingSystemFontSize(usingSystemFontSize).height)
    }
}



extension UIAlertController {
    func addActions(_ actions: UIAlertAction...){
        actions.forEach{ self.addAction($0) }
    }

    func addActions(_ actions: [UIAlertAction]){
        actions.forEach{ self.addAction($0) }
    }

}

extension UILabel{
    class func fromText(_ text: String) -> UILabel{
        let label = UILabel()
        label.text = text
        return label
    }

    func setFontSize(_ fontSize: CGFloat){
        self.font = self.font.withSize(fontSize)
    }

    func makeBold(size: CGFloat){
        self.font = UIFont.boldSystemFont(ofSize: size)
    }
}



extension UIScrollView{
    func fitSubViews() {
        var contentRect = CGRect.zero
        for view in self.subviews{
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}


//: MARK: - UIVIEW -
extension UIView{
    
    func capture() -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = isOpaque
        let renderer = UIGraphicsImageRenderer(size: frame.size, format: format)
        return renderer.image { _ in
            drawHierarchy(in: frame, afterScreenUpdates: true)
        }
    }
    
    func addSubviews(_ views: [UIView]){
        for sv in views{ self.addSubview(sv) }
    }

    func addSubviewInFront(_ view: UIView){
        self.addSubview(view)
        self.bringSubviewToFront(view)
    }
    
   public func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func resizeContainerView() {

        let subviewsRect = subviews.reduce(CGRect.zero) { $0.union($1.frame) }

        let fix = subviewsRect.origin
        subviews.forEach { $0.frame.offsetBy(dx: -fix.x, dy: -fix.y) }

        frame.offsetBy(dx: fix.x, dy: fix.y)
        frame.size = subviewsRect.size
    }
}


extension UIStackView{
    func addArrangedSubviews(_ views: [UIView]){
        for sv in views{ self.addArrangedSubview(sv) }
    }
}

extension DateFormatter{
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

//: MARK: - DATE -  
extension Date{
    
    func ceiling() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute, .second], from: self)
        return (calendar as NSCalendar).date(bySettingHour: components.minute! > 0 ? components.hour! + 1 : components.hour!, minute: 0, second: 0, of: self, options: .matchFirst)!
    }
    
    func floor() -> Date {
        let calendar = Calendar.current
        let hour = (calendar as NSCalendar).components(.hour, from: self)
        return (calendar as NSCalendar).date(bySettingHour: hour.hour!, minute: 0, second: 0, of: self, options: .matchFirst)!
    }
    
    
    public func oneHourBefore() -> Date {
        return Calendar.current.date(byAdding: Calendar.Component.hour, value: -1, to: self, wrappingComponents: false)!
    }
    
    public func oneHourAfter() -> Date {
        return Calendar.current.date(byAdding: Calendar.Component.hour, value: 1, to: self, wrappingComponents: false)!
    }
    
    public func getHour() -> Int {
        return Calendar.current.component(Calendar.Component.hour, from: self)
    }
    
    public func getMins() -> Int {
        return Calendar.current.component(Calendar.Component.minute, from: self)
    }
    
    public func addingMins(_ mins:Int) -> Date {
        if let additiveDate = Calendar.current.date(byAdding: Calendar.Component.minute, value: mins, to: self, wrappingComponents: false) {
            return additiveDate
        } else {
            return self
        }
        
    }
    
    public func addingHours(_ hours:Int) -> Date {
        if let additiveDate = Calendar.current.date(byAdding: Calendar.Component.hour, value: hours, to: self, wrappingComponents: true) {
            return additiveDate
        } else {
            return self
        }
    }
    
    public func nearestHour() -> Date? {
        var components = Calendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    public func topOfTheNextHour() -> Date {
        if let date = Calendar.current.date(bySettingHour: Calendar.current.component(Calendar.Component.hour, from: self) + 1, minute: 0, second: 0, of: self) {
            return date
        } else {
            return self
        }
        
    }
    
    public func topOfThePreviousHour() -> Date {
        if let date = Calendar.current.date(bySettingHour: Calendar.current.component(Calendar.Component.hour, from: self) - 1, minute: 0, second: 0, of: self) {
            return date
        } else {
            return self
        }
    }
    
    public func hourString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: self)
    }
    
    public func nextDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    public func previousDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    
}


extension CGFloat {
    public func toRadians() -> CGFloat {
        return self * (.pi/180.0)
    }
}




extension String {

    var length : Int {
        return self.count
    }

    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

//    subscript (r: CountableRange<Int>) -> String {
//        
//        return String(with: index(startIndex, offsetBy: r.lowerBound)..<index(startIndex, offsetBy: r.upperBound))
//    }

    func removePercents() -> String{
        return self.removingPercentEncoding!
    }

    func split(_ s: String) -> [String]{
        return self.components(separatedBy: s)
    }
    
    public func sanitized() -> String {
        return self.trimmingCharacters(in: .whitespaces).lowercased()
    }
    
    /**
     Takes the current String struct and strips out HTML using regular expression. All tags get stripped out.
     :returns: String html text as plain text
     */
    func stripHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func cleanWeighmaster() -> String {
        return self.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
}

extension Array {
    
    func containsItem<U: Equatable>(_ object:U) -> Bool {
        return (self.indexOf(object) != nil);
    }

    func indexOf<U: Equatable>(_ object: U) -> Int? {
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    return idx
                }
            }
        }
        return nil
    }

    mutating func removeObject<U: Equatable>(_ object: U) {
        let index = self.indexOf(object)
        if(index != nil) {
            self.remove(at: index!)
        }
    }

    func forEach(_ doThis: (_ element: Element) -> Void) {
        for e in self {
            doThis(e)
        }
    }
}


extension RangeReplaceableCollection where Self.Iterator.Element: Hashable {
    /// @return the unique elements of the collection
    func uniq() -> Self {
        var seen: Set<Self.Iterator.Element> = Set()

        return reduce(Self()) { result, item in
            if seen.contains(item) {
                return result
            }
            seen.insert(item)
            return result + [item]
        }
    }
}



/*
extension UITabBarController {
    
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        if #available(iOS 10.0, *) {
            UIViewPropertyAnimator(duration: duration, curve: .linear) {
                self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
                self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
                }.startAnimation()
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 0.25, animations: {
                self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
                self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    
    func growTabBar(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        if #available(iOS 10.0, *) {
            UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
                self?.tabBar.frame.offsetBy(dx:0, dy:offsetY)
                self?.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
                self?.view.setNeedsDisplay()
                self?.view.layoutIfNeeded()
                }.startAnimation()
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 0.25, animations: {
                self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
                self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}
*/




//: MARK: - UIDevice -
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

//: MARK: - INT -
extension Int {
    public func hourString() -> String {
        switch self {
        case 0: return "12 am"
        case 1...12: return "\(self) am"
        case 13...24: return "\(self-12) pm"
        default: return ""
        }
    }

    
    public func isOdd() -> Bool {
        if (self % 2 != 0) {
            return true
        } else {
            return false
        }
    }
    
    public func isEven() -> Bool { return !(self.isOdd()) }
}

//: MARK: - DOUBLE -
extension Double {
    public static func random(_ lower:Double = 0.01,_ upper:Double = 99.99) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}


//: MARK: - UIImage -
extension UIImage {
    
    // colorize image with given tint color
    // this is similar to Photoshop's "Color" layer blend mode
    // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
    // white will stay white and black will stay black as the lightness of the image is preserved
    func tint(tintColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            
            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)
            
            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    // fills the alpha channel of the source image with the given color
    // any color information except to the alpha channel will be ignored
    func fillAlpha(fillColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
            //            context.fillCGContextFillRect(context, rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    private func modifiedImage( draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

//: MARK: - Gometery -

// MARK: CGPoint
extension CGPoint {
    
    /// Creates a point with unnamed arguments.
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.init()
        self.x = x
        self.y = y
    }
    
    /// Returns a copy with the x value changed.
    public func with(x: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    /// Returns a copy with the y value changed.
    public func with(y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    public func distanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y);
    }
    
    public func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(distanceSquared(from: from, to: to));
    }
    
}

// MARK: CGSize
extension CGSize {
    
    /// Creates a size with unnamed arguments.
    public init(_ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.width = width
        self.height = height
    }
    
    /// Returns a copy with the width value changed.
    public func with(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
    /// Returns a copy with the height value changed.
    public func with(height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
}

// MARK: CGRect
extension CGRect {
    
    //    /// Creates a rect with unnamed arguments.
    //    public init(_ origin: CGPoint, _ size: CGSize) {
    //        self.origin = origin
    //        self.size = size
    //    }
    
    /// Creates a rect with unnamed arguments.
    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
    }
    
    // MARK: access shortcuts
    /// Alias for origin.x.
    public var x: CGFloat {
        get {return origin.x}
        set {origin.x = newValue}
    }
    /// Alias for origin.y.
    public var y: CGFloat {
        get {return origin.y}
        set {origin.y = newValue}
    }
    
    /// Accesses origin.x + 0.5 * size.width.
    public var centerX: CGFloat {
        get {return x + width * 0.5}
        set {x = newValue - width * 0.5}
    }
    /// Accesses origin.y + 0.5 * size.height.
    public var centerY: CGFloat {
        get {return y + height * 0.5}
        set {y = newValue - height * 0.5}
    }
    
    // MARK: edges
    /// Alias for origin.x.
    public var left: CGFloat {
        get {return origin.x}
        set {origin.x = newValue}
    }
    /// Accesses origin.x + size.width.
    public var right: CGFloat {
        get {return x + width}
        set {x = newValue - width}
    }
    
    #if os(iOS)
    /// Alias for origin.y.
    public var top: CGFloat {
        get {return y}
        set {y = newValue}
    }
    /// Accesses origin.y + size.height.
    public var bottom: CGFloat {
        get {return y + height}
        set {y = newValue - height}
    }
    #else
    /// Accesses origin.y + size.height.
    public var top: CGFloat {
    get {return y + height}
    set {y = newValue - height}
    }
    /// Alias for origin.y.
    public var bottom: CGFloat {
    get {return y}
    set {y = newValue}
    }
    #endif
    
    // MARK: points
    /// Accesses the point at the top left corner.
    public var topLeft: CGPoint {
        get {return CGPoint(x: left, y: top)}
        set {left = newValue.x; top = newValue.y}
    }
    /// Accesses the point at the middle of the top edge.
    public var topCenter: CGPoint {
        get {return CGPoint(x: centerX, y: top)}
        set {centerX = newValue.x; top = newValue.y}
    }
    /// Accesses the point at the top right corner.
    public var topRight: CGPoint {
        get {return CGPoint(x: right, y: top)}
        set {right = newValue.x; top = newValue.y}
    }
    
    /// Accesses the point at the middle of the left edge.
    public var centerLeft: CGPoint {
        get {return CGPoint(x: left, y: centerY)}
        set {left = newValue.x; centerY = newValue.y}
    }
    /// Accesses the point at the center.
    public var center: CGPoint {
        get {return CGPoint(x: centerX, y: centerY)}
        set {centerX = newValue.x; centerY = newValue.y}
    }
    /// Accesses the point at the middle of the right edge.
    public var centerRight: CGPoint {
        get {return CGPoint(x: right, y: centerY)}
        set {right = newValue.x; centerY = newValue.y}
    }
    
    /// Accesses the point at the bottom left corner.
    public var bottomLeft: CGPoint {
        get {return CGPoint(x: left, y: bottom)}
        set {left = newValue.x; bottom = newValue.y}
    }
    /// Accesses the point at the middle of the bottom edge.
    public var bottomCenter: CGPoint {
        get {return CGPoint(x: centerX, y: bottom)}
        set {centerX = newValue.x; bottom = newValue.y}
    }
    /// Accesses the point at the bottom right corner.
    public var bottomRight: CGPoint {
        get {return CGPoint(x: right, y: bottom)}
        set {right = newValue.x; bottom = newValue.y}
    }
    
    // MARK: with
    /// Returns a copy with the origin value changed.
    public func with(origin: CGPoint) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    /// Returns a copy with the x and y values changed.
    public func with(x: CGFloat, y: CGFloat) -> CGRect {
        return with(origin: CGPoint(x: x, y: y))
    }
    /// Returns a copy with the x value changed.
    public func with(x: CGFloat) -> CGRect {
        return with(x: x, y: y)
    }
    /// Returns a copy with the y value changed.
    public func with(y: CGFloat) -> CGRect {
        return with(x: x, y: y)
    }
}




