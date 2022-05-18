import UIKit

open class TableHeader: UITableViewHeaderFooterView {
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) { nil }
    
    open func configure() { }
    open func configure(data: Any?) { }
}

open class RoundedHeader: TableHeader {
    open var content = UIView()
    
    open override func configure() {
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        content.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
}

open class ExpandableHeader: TableHeader {
    open var button = UIButton()
    
    open override func configure() {
        super.configure()
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    open func hide(_ closure: @escaping () -> Void) {
        let action = Action(closure)
        button.addTarget(action, action: #selector(Action.action), for: .touchUpInside)
        Associated(self).set(action, .hashable(self), .OBJC_ASSOCIATION_RETAIN)
    }
    
    open func update() { }
}

open class ExpandableRoundedHeader: RoundedHeader {
    open var button = UIButton()
    
    open override func configure() {
        super.configure()
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
    }
    
    open func hide(_ closure: @escaping () -> Void) {
        let action = Action(closure)
        button.addTarget(action, action: #selector(Action.action), for: .touchUpInside)
        Associated(self).set(action, .hashable(self), .OBJC_ASSOCIATION_RETAIN)
    }
    
    open func update() { }
}
