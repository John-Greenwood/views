import UIKit

open class Collection: UICollectionView {
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        create()
    }
    
    var items: [Section] = []
    
    func create() {
        configure()
        backgroundColor = .clear
        delegate = self
        dataSource = self
    }
    
    open func configure() { }
    open func configure(cell: CollectionCell, index: IndexPath) { }
    
    func item(index: IndexPath) -> Any? {
        guard let section = items[safe: index.section]?.items,
              let item = section[safe: index.row] else { return nil }
        return item.data
    }
    
    @discardableResult public
    func items(_ items: [Section]) -> Self {
        self.items = items
        return self
    }
    
    required public init?(coder: NSCoder) { nil }
}

extension Collection: UICollectionViewDelegate {
    
}

extension Collection: UICollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items[safe: section]?.items.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = items[safe: indexPath.section]?.items[safe: indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.id, for: indexPath) as? CollectionCell else { fatalError() }
        cell.item = item
        configure(cell: cell, index: indexPath)
        cell.configure(data: item)
        return cell
    }
}

extension Collection {
    public struct Section {
        var name: String?
        var items: [Item] = []
        var kind: Any?
    }
    
    public struct Item {
        var id: String
        var data: Any?
        var kind: Any?
    }
}

open class Layout: UICollectionViewFlowLayout {
    override public init() {
        super.init()
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        configure()
    }
    
    open func configure() { }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

open class CollectionCell: UICollectionViewCell {
    public var item: Collection.Item?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func configure() { }
    open func configure(data: Any?) { }
}
