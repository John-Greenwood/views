import UIKit

public class Slider: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        
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
