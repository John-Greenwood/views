import UIKit

public class Indicator: UIView {
    public override class var layerClass: AnyClass { CAShapeLayer.self }
    var back: CAShapeLayer { layer as! CAShapeLayer }
    var indicator: CAShapeLayer = CAShapeLayer()
    private var rect: CGRect!
    var color: UIColor = .systemBlue
    var ratio: CGFloat = 0.15
    var animating: Bool = false
    
    public override func draw(_ rect: CGRect) {
        self.rect = rect
        drawCircle(layer: back, color: color.withAlphaComponent(0.3))
        drawCircle(layer: indicator, color: color, value: 0.4)
        indicator.position = CGPoint(x: rect.maxX / 2, y: rect.maxY / 2)
        indicator.bounds = indicator.path!.boundingBox
        layer.addSublayer(indicator)
    }
    
    public func start() {
        if indicator.animation(forKey: "rotation") == nil {
            addAnimation(to: indicator)
        } else { resume(layer: indicator) }
    }
    public func stop() {
        pause(layer: indicator)
    }
    
    private func pause(layer: CAShapeLayer) {
        if !animating { return }
        
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        
        animating = false
        
    }
    
    private func resume(layer: CAShapeLayer) {
        if animating { return }
        
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        animating = true
        
    }
    
    private func drawCircle(layer: CAShapeLayer, color: UIColor, value: CGFloat = 1) {
        let center = CGPoint(x: rect.maxX / 2, y: rect.maxY / 2)
        
        let longestSide = rect.height < rect.width ? rect.height : rect.width
        
        let circularPath = UIBezierPath(arcCenter: center, radius: (longestSide / 2) - ((longestSide * ratio) / 2), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = longestSide * ratio
        layer.lineCap = CAShapeLayerLineCap.round
        layer.strokeEnd = value
    }
    
    private func addAnimation(to layer: CAShapeLayer) {
        let rotation: CABasicAnimation
        if let oldAnimation = layer.animation(forKey: "rotation")?.copy() as? CABasicAnimation {
            rotation = oldAnimation
            layer.removeAnimation(forKey: "rotation")
        } else {
            rotation = CABasicAnimation(keyPath: "transform.rotation")
        }
        
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = Float.infinity
        rotation.fillMode = CAMediaTimingFillMode.forwards
        rotation.toValue = NSNumber(value: Double.pi * 2)
        
        layer.add(rotation, forKey: "rotation")
        
        animating = true
    }
    
    public func rotate(value: CGFloat) {
        if animating { return }
        let rotation: CABasicAnimation
        if let oldAnimation = layer.animation(forKey: "rotation")?.copy() as? CABasicAnimation {
            rotation = oldAnimation
            layer.removeAnimation(forKey: "rotation")
        } else {
            rotation = CABasicAnimation(keyPath: "transform.rotation")
        }
        rotation.duration = 0.1
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = 1
        rotation.fillMode = (value < 0) ? .backwards : .forwards
        let newValue = (value <= 2) ? value : value - 2
        rotation.toValue = NSNumber(value: Double.pi * Double(newValue))
        
        layer.add(rotation, forKey: "rotation")
    }
}
