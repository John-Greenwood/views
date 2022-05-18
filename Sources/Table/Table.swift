import UIKit

open class Table: UITableView {
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        create()
    }
    
    open var sections: [Section] = []
    
    open func create() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        if #available(macCatalyst 15.0, iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
        configure()
    }
    
    open func configure() { }
    open func configure(cell: TableCell, item: Item, indexPath: IndexPath) -> TableCell {
        cell.configure(data: item.data)
        return cell
    }
    open func display(cell: TableCell, indexPath: IndexPath) {
        cell.display()
    }
    open func configure(header: TableHeader, data: Any?, section: Int) -> TableHeader? {
        if let view = header as? RoundedHeader {
            let item = sections[section]
            if item.items.count > 0 {
                view.content.radius(corners: .top, value: 12)
            } else if item.footer != nil {
                view.content.radius(corners: .top, value: 12)
            } else {
                view.content.radius(corners: .all, value: 12)
            }
        }
        header.configure(data: data)
        return header
    }
    open func configure(footer: TableFooter, data: Any?, section: Int) -> TableFooter? {
        if let view = footer as? RoundedFooter {
            let item = sections[section]
            if item.items.count > 0 {
                view.content.radius(corners: .bottom, value: 12)
            } else if item.header != nil {
                view.content.radius(corners: .bottom, value: 12)
            } else {
                view.content.radius(corners: .all, value: 12)
            }
        }
        footer.configure(data: data)
        return footer
    }
    open func headerHeight(section: Int) -> CGFloat {
        sections[section].header == nil ? .leastNormalMagnitude : UITableView.automaticDimension
    }
    open func footerHeight(section: Int) -> CGFloat {
        sections[section].footer == nil ? .leastNormalMagnitude : UITableView.automaticDimension
    }
    
    open func round(cell: RoundedCell, indexPath: IndexPath) {
        let count = numberOfRows(inSection: indexPath.section)
        let first = indexPath.row == 0
        let last = indexPath.row == count - 1
        let view = cell.content
        
        var header: Bool { sections[indexPath.section].header != nil }
        var footer: Bool { sections[indexPath.section].footer != nil }
        
        var corners: Corner = []
        if first && last, !header && !footer {
            corners = .all
        } else if first, !header {
            corners = .top
        } else if last, !footer {
            corners = .bottom
        }
        cell.line.isHidden = last
        
        view.radius(corners: corners)
    }
    
    required public init?(coder: NSCoder) { nil }
}

extension Table: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { headerHeight(section: section) }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { footerHeight(section: section) }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = sections[section]
        guard let identifier = item.header, let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? TableHeader else { return nil }
        return configure(header: view, data: item.data, section: section)
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let item = sections[section]
        guard let identifier = item.footer, let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? TableFooter else { return nil }
        return configure(footer: view, data: item.data, section: section)
    }
}

extension Table: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].items.count }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        guard let cell = dequeueReusableCell(withIdentifier: item.id, for: indexPath) as? TableCell else { fatalError() }
        return configure(cell: cell, item: item, indexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TableCell else { return }
        display(cell: cell, indexPath: indexPath)
    }
}
