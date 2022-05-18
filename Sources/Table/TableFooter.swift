import UIKit

open class TableFooter: UITableViewHeaderFooterView {
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) { nil }
    
    open func configure() {}
    open func configure(data: Any?) {}
}

open class RoundedFooter: TableFooter {
    open var content = UIView()
    
    open override func configure() {
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
}
