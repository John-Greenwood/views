import UIKit

public class Gradient: CAGradientLayer {
    @discardableResult public
    func colors(_ value: [UIColor]) -> Self {
        colors = value.map { $0.cgColor }
        return self
    }
    //degrees
    @discardableResult public
    func angle(_ degrees: CGFloat) -> Self {
        var ang = (-degrees).truncatingRemainder(dividingBy: 360)+90
        if ang < 0 { ang = 360 + ang }
        
        let n: CGFloat = 0
        let a, b: CGPoint
        switch ang {
        case 0...45, 315...360:
            (a, b) = (CGPoint(x: 1, y: n*tan(-ang)+n), CGPoint(x: 0, y: n*tan(ang)+n))
        case 45...135:
            (a, b) = (CGPoint(x: n*tan(-ang-90)+n, y: 0), CGPoint(x: n*tan(ang-90)+n, y: 1))
        case 135...225:
            (a, b) = (CGPoint(x: 0, y: n*tan(ang)+n), CGPoint(x: 1, y: n*tan(-ang)+n))
        case 225...315:
            (a, b) = (CGPoint(x: n*tan(ang-90)+n, y: 1), CGPoint(x: n*tan(-ang-90)+n, y: 0))
        default: (a, b) = (CGPoint(x: 0, y: n), CGPoint(x: 1, y: n))
        }
        startPoint = a
        endPoint = b
        return self
    }
    @discardableResult public
    func frame(_ rect: CGRect) -> Self {
        frame = rect
        return self
    }
    @discardableResult public
    func locations(_ value: [Double]?) -> Self {
        locations = value?.map { NSNumber(value: $0) }
        return self
    }
    @discardableResult public
    func start(_ point: CGPoint) -> Self {
        startPoint = point
        return self
    }
    @discardableResult public
    func end(_ point: CGPoint) -> Self {
        endPoint = point
        return self
    }
}

extension Gradient {
    convenience public init(_ rect: CGRect) {
        self.init()
        frame = rect
    }
    convenience public init(_ colors: [UIColor], _ type: Model.`Type` = .none) {
        self.init()
        guard let model = Model(colors, type) else { return }
        self.colors = model.colors
        self.locations = model.locations
    }
    @discardableResult public
    func model(_ colors: [UIColor], _ type: Model.`Type` = .none) -> Self? {
        guard let model = Model(colors, type) else { return nil }
        self.colors = model.colors
        self.locations = model.locations
        return self
    }
    public struct Model {
        var colors: [CGColor]
        var locations: [NSNumber]?
        
        public enum `Type` { case none, infinity }
        public init?(_ colors: [UIColor], _ type: Type) {
            switch type {
            case .infinity:
                guard let first = colors.first else { return nil }
                let step: Double = 1/Double(colors.count)
                self.locations = []
                for i in 0...colors.count {
                    let value: Double = Double(i)*step
                    locations?.append( NSNumber(value: value) )
                }
                self.colors = colors.map { $0.cgColor }
                self.colors.append(first.cgColor)
            case .none:
                self.colors = colors.map { $0.cgColor }
                self.locations = nil
            }
            return
        }
    }
    
    @discardableResult public
    func add(to view: UIView?) -> Self {
        view?.layer.addSublayer(self)
        return self
    }
}

