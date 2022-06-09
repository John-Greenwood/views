import UIKit

open class RZTable: UITableView {
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        create()
    }
    
    open var sections: [Section] = []
    open var invisible: Set<Int> = []
    
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
        if let cell = cell as? RoundedCell {
            round(cell: cell, indexPath: indexPath)
        }
        cell.display()
    }
    open func configure(header: TableHeader, data: Any?, section: Int) -> TableHeader? {
        let contains = invisible.contains(section)
        if let header = header as? RoundedHeader {
            round(header: header, section: section)
        }
        if let header = header as? ExpandableHeader {
            header.hide { [weak self] in self?.hide(section: section) }
            header.update(hidden: contains)
        }
        if let header = header as? ExpandableRoundedHeader {
            header.hide { [weak self] in self?.hide(section: section) }
            header.update(hidden: contains)
        }
        header.configure(data: data)
        return header
    }
    open func configure(footer: TableFooter, data: Any?, section: Int) -> TableFooter? {
        let contains = invisible.contains(section)
        if let footer = footer as? RoundedFooter {
            round(footer: footer, section: section)
        }
        if let footer = footer as? ExpandableFooter {
            footer.hide { [weak self] in self?.hide(section: section) }
            footer.update(hidden: contains)
        }
        if let footer = footer as? ExpandableRoundedFooter {
            footer.hide { [weak self] in self?.hide(section: section) }
            footer.update(hidden: contains)
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
        
        var header: Bool { view(sections[indexPath.section].header) as? RoundedHeader != nil }
        var footer: Bool { view(sections[indexPath.section].footer) as? RoundedFooter != nil }
        func view(_ identifier: String?) -> UITableViewHeaderFooterView? {
            guard let identifier = identifier else { return nil }
            return dequeueReusableHeaderFooterView(withIdentifier: identifier)
        }
        
        var corners: Corner = []
        if first && last, !header && !footer {
            corners = .all
        } else if first, !header {
            corners = .top
        } else if last, !footer {
            corners = .bottom
        }
        cell.line.isHidden = last
        
        cell.content.radius(corners: corners)
    }
    
    open func round(header: RoundedHeader, section: Int) {
        let item = sections[section]
        if item.footer != nil {
            header.content.radius(corners: .top, value: 12)
        } else if invisible.contains(section) {
            header.content.radius(corners: .all, value: 12)
        } else if item.items.count > 0 {
            header.content.radius(corners: .top, value: 12)
        } else {
            header.content.radius(corners: .all, value: 12)
        }
    }
    
    open func round(footer: RoundedFooter, section: Int) {
        let item = sections[section]
        if item.header != nil {
            footer.content.radius(corners: .bottom, value: 12)
        } else if invisible.contains(section) {
            footer.content.radius(corners: .all, value: 12)
        } else if item.items.count > 0 {
            footer.content.radius(corners: .bottom, value: 12)
        } else {
            footer.content.radius(corners: .all, value: 12)
        }
    }
    
    open func hide(section: Int) {
        var indexPaths: [IndexPath] {
            sections[section].items.enumerated().map { i, item in IndexPath(row: i, section: section) }
        }
        
        if invisible.contains(section) {
            invisible.remove(section)
            insertRows(at: indexPaths, with: .fade)
        } else {
            invisible.insert(section)
            deleteRows(at: indexPaths, with: .fade)
        }
        
        let contains = invisible.contains(section)
        
        if let header = headerView(forSection: section) {
            if let header = header as? RoundedHeader {
                round(header: header, section: section)
            }
            (header as? ExpandableHeader)?.update(hidden: contains)
            (header as? ExpandableRoundedHeader)?.update(hidden: contains)
        }
        
        if let footer = footerView(forSection: section) {
            if let footer = footer as? RoundedFooter {
                round(footer: footer, section: section)
            }
            (footer as? ExpandableFooter)?.update(hidden: contains)
            (footer as? ExpandableRoundedFooter)?.update(hidden: contains)
        }
    }
    
    required public init?(coder: NSCoder) { nil }
}

extension RZTable: UITableViewDelegate {
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

extension RZTable: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if invisible.contains(section) { return 0 }
        return sections[section].items.count
    }
    
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
