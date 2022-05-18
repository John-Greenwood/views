import UIKit
import Views

open class Collection: UICollectionView {
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        create()
    }
    
    open var sections: [Section] = []
    
    open func create() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        configure()
    }
    
    open func configure() { }
    open func configure(cell: CollectionCell, item: Item, indexPath: IndexPath) -> CollectionCell {
        cell.configure(data: item.data)
        return cell
    }
    
    required public init?(coder: NSCoder) { nil }
}

extension Collection: UICollectionViewDelegate {
    
}

extension Collection: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[safe: section]?.items.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = sections[safe: indexPath.section]?.items[safe: indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.id, for: indexPath) as? CollectionCell else { fatalError() }
        return configure(cell: cell, item: item, indexPath: indexPath)
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
    
    required public init?(coder: NSCoder) { nil }
}

open class CollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder: NSCoder) { nil }
    
    open func configure() { }
    open func configure(data: Any?) { }
}

open class CollectionView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder: NSCoder) { nil }
    
    open func configure() { }
    open func configure(data: Any?) { }
}
