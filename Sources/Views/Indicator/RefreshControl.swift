import UIKit

public class RefreshControl: UIRefreshControl {
    var indicator: Indicator
    private var observing: Bool = false
    private var scrollInsets: UIEdgeInsets = .zero
    private var previousOffset: CGPoint = .zero
    private var previuslyOffset: CGFloat = 0
    
    public override func beginRefreshing() {
        super.beginRefreshing()
        indicator.start()
    }
    
    public override func endRefreshing() {
        super.endRefreshing()
        indicator.stop()
        previuslyOffset = .zero
    }
    
    weak var scrollView: UIScrollView? {
        willSet {
            removeObserving()
        }
        didSet {
            if let scrollView = scrollView {
                scrollInsets = scrollView.contentInset
                addObserving()
                bringSubviewToFront(indicator)
            }
        }
    }
    
    override init() {
        indicator = Indicator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        tintColor = .clear
        addSubview(indicator)
        indicator.center.x = UIScreen.main.bounds.width / 2
        indicator.center.y = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RefreshControl {
    private struct obesrvable {
        static var context = "PullToRefreshContext"
        static var contentOffset = #keyPath(UIScrollView.contentOffset)
    }
    
    private func addObserving() {
        guard let scrollView = scrollView, !observing else { return }

        scrollView.addObserver(self, forKeyPath: obesrvable.contentOffset, options: .initial, context: &obesrvable.context)
        
        observing = true
    }
    
    private func removeObserving() {
        guard let scrollView = scrollView, observing else { return }

        scrollView.removeObserver(self, forKeyPath: obesrvable.contentOffset, context: &obesrvable.context)

        observing = false
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &obesrvable.context
            && keyPath == obesrvable.contentOffset
            && object as? UIScrollView == scrollView {
            
            let offset = previousOffset.y + scrollInsets.top + 20
            let refreshViewHeight = self.frame.size.height
            let progress = -offset / refreshViewHeight
            
            if previuslyOffset <= progress { previuslyOffset = progress }
            UIView.animate(withDuration: TimeInterval(0.01)) {
                //self.indicator.frame.origin.y = -offset - (refreshViewHeight / 2)
                self.indicator.alpha = -offset.map(min1: 38, max1: 150, min2: 0, max2: 1)
            }
            indicator.rotate(value: progress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        previousOffset.y = scrollView?.normalizedContentOffset.y ?? 0
    }
}

extension UIScrollView {
    var normalizedContentOffset: CGPoint {
        get {
            let contentOffset = self.contentOffset
            let contentInset = self.contentInset
            
            let output = CGPoint(x: contentOffset.x + contentInset.left, y: contentOffset.y + contentInset.top)
            return output
        }
    }
}
