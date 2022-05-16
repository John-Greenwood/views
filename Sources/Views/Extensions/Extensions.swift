import UIKit

extension BinaryFloatingPoint {
    func map<T:BinaryFloatingPoint>(min1:T, max1:T, min2:T, max2:T) -> T {
        min2 + (max2 - min2) * (T(self) - min1) / (max1 - min1)
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension UIColor {
    class var secondary: UIColor {
        if #available(iOS 13.0, *) { return .secondarySystemBackground }
        return .lightGray
    }
    
    class var separators: UIColor {
        if #available(iOS 13.0, *) { return .separator }
        return .lightGray
    }
    
    class var background: UIColor {
        if #available(iOS 13.0, *) { return .systemBackground }
        return .white
    }
}
