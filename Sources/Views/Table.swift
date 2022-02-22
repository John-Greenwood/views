import UIKit

open class Table: UITableView {
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        create()
    }
    
    public var sections: [Section] = []
    
    func create() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        if #available(macCatalyst 15.0, iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
        configure()
    }
    
    open func configure() { }
    open func configure(cell: TableCell, index: IndexPath) { }
    open func display(cell: TableCell, index: IndexPath) { }
    
    required public init?(coder: NSCoder) { nil }
}

extension Table {
    public func headerHeight(section: Int) -> CGFloat {
        sections[section].header == nil ? .leastNormalMagnitude : UITableView.automaticDimension
    }
    
    public func footerHeight(section: Int) -> CGFloat {
        sections[section].footer == nil ? .leastNormalMagnitude : UITableView.automaticDimension
    }
    
    func radius(view: UIView, index: IndexPath) {
        let count = numberOfRows(inSection: index.section)
        if count > 1 {
            if index.row == 0 || index.row == count - 1 {
                view.addRadius(rectCorner: index.row == 0 ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
            } else { view.layer.mask = nil }
        } else { view.addRadius() }
    }
    
    func roundedStyle(cell: RoundedCell, index: IndexPath) {
        radius(view: cell.box, index: index)
        cell.line.isHidden = index.row == numberOfRows(inSection: index.section) - 1
    }
}

extension Table: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { headerHeight(section: section) }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { footerHeight(section: section) }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = sections[section]
        guard let header = item.header, let view = dequeueReusableHeaderFooterView(withIdentifier: header) as? TableHeader else { return nil }
        view.configure(data: item.data)
        return view
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let item = sections[section]
        guard let footer = item.footer, let view = dequeueReusableHeaderFooterView(withIdentifier: footer) as? TableFooter else { return nil }
        view.configure(data: item.data)
        return view
    }
}

extension Table: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].items.count }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        guard let cell = dequeueReusableCell(withIdentifier: item.id, for: indexPath) as? TableCell else { fatalError() }
        configure(cell: cell, index: indexPath)
        cell.configure(data: item.data)
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TableCell else { return }
        display(cell: cell, index: indexPath)
        cell.display()
    }
}

extension Table {
    public struct Section {
        public var data: Any?
        public var items: [Item] = []
        public var header: String?
        public var footer: String?
        
        public init(data: Any? = nil, items: [Table.Item] = [], header: String? = nil, footer: String? = nil) {
            self.data = data
            self.items = items
            self.header = header
            self.footer = footer
        }
    }
    
    public struct Item {
        public var data: Any?
        public var id: String = ""
        
        public init(data: Any? = nil, id: String = "") {
            self.data = data
            self.id = id
        }
    }
}

open class TableCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        configure()
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func configure() { }
    open func configure(data: Any?) { }
    open func display() { }
}

public extension TableCell {
    var table: UITableView? { superview as? UITableView }
    var index: IndexPath? { table?.indexPath(for: self) }
}

open class TableHeader: UITableViewHeaderFooterView {
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func configure() {}
    open func configure(data: Any?) {}
}

open class TableFooter: UITableViewHeaderFooterView {
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func configure() {}
    open func configure(data: Any?) {}
}

open class RoundedCell: TableCell {
    public var box: UIView = {
        let obj = UIView()
        obj.backgroundColor = .secondary
        return obj
    }()
    public var line: UIView = {
        let obj = UIView()
        obj.backgroundColor = .separators
        obj.isHidden = true
        return obj
    }()
    
    open override func configure() {
        backgroundColor = .clear
        addSubview(box)
        addSubview(line)
        box.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        box.topAnchor.constraint(equalTo: topAnchor).isActive = true
        box.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        box.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        box.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
}

extension UIView {
    func addRadius(rectCorner: UIRectCorner = [.allCorners], radius: Int = 12) {
        layoutIfNeeded()
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: rectCorner,
                                      cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.mask = rectShape
    }
}
