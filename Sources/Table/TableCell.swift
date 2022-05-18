import UIKit

open class TableCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        configure()
    }
    
    required public init?(coder: NSCoder) { nil }
    
    open func configure() { }
    open func configure(data: Any?) { }
    open func display() { }
}

open class RoundedCell: TableCell {
    open var content = UIView()
    open var line = UIView()
    
    open override func configure() {
        addSubview(content)
        addSubview(line)
        content.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        
        line.isHidden = true
    }
}
