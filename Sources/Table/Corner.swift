import UIKit

public struct Corner: OptionSet {
    public var rawValue: UInt
    
    public init(rawValue: UInt) { self.rawValue = rawValue }
    
    public static var topLeft: Self = .init(rawValue: 1)
    public static var topRight: Self = .init(rawValue: 2)
    public static var bottomLeft: Self = .init(rawValue: 4)
    public static var bottomRight: Self = .init(rawValue: 8)

    public static var all: Self = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    
    public static var top: Self { [.topLeft, .topRight] }
    public static var bottom: Self { [.bottomLeft, .bottomRight] }
    
    public var uirectcorner: UIRectCorner { UIRectCorner(rawValue: rawValue) }
    public var cacornermask: CACornerMask { CACornerMask(rawValue: rawValue) }
}

extension UIView {
    open func radius(corners: Corner = .all, value: CGFloat = 12) {
        if #available(iOS 11, *) {
            radius(corners: corners.cacornermask, value: value)
        } else {
            radius(corners: corners.uirectcorner, value: value)
        }
    }
}

private extension UIView {
    @available(iOS 11, *) func radius(corners: CACornerMask, value: CGFloat) {
        layer.maskedCorners = corners
        layer.cornerRadius = value
    }
}

private extension UIView {
    func radius(corners: UIRectCorner, value: CGFloat) {
        layoutIfNeeded()
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: value, height: value)).cgPath
        layer.mask = rectShape
    }
}
