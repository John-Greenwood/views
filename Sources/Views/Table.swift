import UIKit

open class Table: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        create()
    }
    
    lazy public var refresh: RefreshControl = RefreshControl()
    var items = [S]() //var sorting = [S]()
    
    @discardableResult
    func items(_ items: [S]) -> Self {
        self.items = items
        return self
    }
    
    func create() {
        configure()
        backgroundColor = .clear
        delegate = self
        dataSource = self
    }
    
    open func configure() {}
    
    func cellSetup(cell: TableCell, index: IndexPath) { }
    
    func getCell(index: IndexPath) -> TableCell? {
        guard let cell = cellForRow(at: index) as? TableCell else {
            reloadRows(at: [index], with: .automatic)
            return nil
        }
        return cell
    }
    
    func getHeaderSection(section: Int, fontSize: CGFloat? = nil) -> TableHeader? {
        guard let sectionName = items[section].name else { return nil }
        let view = TableHeader()
        view.label.text = sectionName
        if let fontSize = fontSize { view.label.font = .systemFont(ofSize: fontSize)}
        return view
    }
    
    func getHeightHeaderSection(section: Int) -> CGFloat {
        let sectionName = items[section].name
        return sectionName == nil ? .leastNormalMagnitude : UITableView.automaticDimension
    }
    
    func getItem(index: IndexPath) -> Any? {
        guard let items = items[safe: index.section]?.items else { return nil }
        guard let item = items[safe: index.row] else { return nil }
        return item.data
    }
    
    func addRadiusCell(view: UIView, index: IndexPath) {
        let count = numberOfRows(inSection: index.section)
        if count > 1 {
            if index.row == 0 || index.row == count - 1 {
                view.addRadius(rectCorner: index.row == 0 ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
            } else { view.layer.mask = nil }
        } else { view.addRadius() }
    }
    
    func roundedStyle(cell: RoundedCell, index: IndexPath) {
        addRadiusCell(view: cell.box, index: index)
        cell.line.isHidden = index.row == numberOfRows(inSection: index.section) - 1
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Table: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { .leastNormalMagnitude }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { .leastNormalMagnitude }
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat { .leastNormalMagnitude }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        getHeaderSection(section: section)
    }
}

extension Table: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int { items.count }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items[section].items.count }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section].items[indexPath.row]
        guard let cell = dequeueReusableCell(withIdentifier: item.id, for: indexPath) as? TableCell else { fatalError() }
        cell.setup(data: item)
        cellSetup(cell: cell, index: indexPath)
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let myCell = cell as? RoundedCell else { return }
        roundedStyle(cell: myCell, index: indexPath)
    }
}

extension Table {
    public struct S {
        var name: String?
        var items = [Table.I]()
        var kind: Any?
    }
    
    public struct I {
        var id = "main"
        var data: Any?
        var kind: Any?
    }
}

open class TableCell: UITableViewCell {
    public var item: Table.I?
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configure()
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func configure() {}
    open func setup(data: Any?) {}
    
    open func itemData(data: Any?) -> Any? { return (data as? Table.I)?.data }
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

open class TableHeader: UIView {
    public var label: UILabel = {
        let obj = UILabel()
        obj.contentMode = .bottomLeft
        obj.font = .systemFont(ofSize: 16)
        return obj
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func configure() {
        backgroundColor = .clear
        addSubview(label)
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
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
