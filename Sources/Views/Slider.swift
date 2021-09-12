import UIKit

open class Slider: UIControl {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBlue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let _ = Gradient(.palette, .infinity).angle(180).add(to: self)
        }
    }
}

private extension Array where Element == UIColor {
    static var palette: [UIColor] { [.white, .black, .white, .black] }
}
