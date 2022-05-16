import UIKit

open class TableHeader: UITableViewHeaderFooterView {
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func configure() {}
    open func configure(data: Any?) {}
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
