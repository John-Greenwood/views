import UIKit

open class Collection: UICollectionView, UICollectionViewDelegateFlowLayout {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        create()
    }
    
    var items = [Table.S]()
    
    func create() {
        configure()
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    public func configure() { }
    
    func cellSetup(cell: CollectionCell, index: IndexPath) { }
    
    func getItem(index: IndexPath) -> Any? {
        guard let items = items[safe: index.section]?.items else { return nil }
        guard let item = items[safe: index.row] else { return nil }
        return item.data
    }
    
    func getSizeHeaderSection(section: Int) -> CGSize {
        let sectionName = items[section].name
        return sectionName == nil ? CGSize(width: 0, height: 0) : CGSize(width: frame.size.width, height: 40)
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension Collection: UICollectionViewDataSource, UICollectionViewDelegate {
    public func numberOfSections(in collectionView: UICollectionView) -> Int { items.count }
    
    override public func numberOfItems(inSection section: Int) -> Int {
        items[safe: section]?.items.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = items[safe: section]?.items.count { return items }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section].items[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.id, for: indexPath) as? CollectionCell else { fatalError() }
        cellSetup(cell: cell, index: indexPath)
        cell.setup(data: item)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        getSizeHeaderSection(section: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? CollectionHeader else { fatalError("Unexpected element kind") }
            
            header.label.text = items[indexPath.section].name
            return header
        default:  fatalError("Unexpected element kind")
        }
    }
}

class CollectionLayout: UICollectionViewFlowLayout {
    //override var collectionViewContentSize: CGSize { .zero }
    
    override public var collectionView: UICollectionView { super.collectionView! }
    
    //    var inset: UIEdgeInsets { collectionView.contentInset }
    //
    //    var numberOfSections: Int { collectionView.numberOfSections }
    //
    //    func numberOfItems(inSection section: Int) -> Int { collectionView.numberOfItems(inSection: section) }
    //
    //    override public func invalidateLayout() {
    //        super.invalidateLayout()
    //    }
    //
    //    override func prepare() {
    //        super.prepare()
    //
    //    }
    
    override public init() {
        super.init()
        scrollDirection = .vertical
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    func itemWidth() -> CGFloat { collectionView.frame.size.width/3 }
    
    override var itemSize: CGSize {
        set { self.itemSize = CGSize(width: itemWidth(), height: itemWidth()) }
        get { CGSize(width: itemWidth(), height: itemWidth()) }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class CollectionCell: UICollectionViewCell {
    
    var item: Table.I?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure() {}
    func setup(data: Any?) { }
    
    func itemData(data: Any?) -> Any? { return (data as? Table.I)?.data }
    
}

class CollectionHeader: UICollectionReusableView {
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure() {
        backgroundColor = .clear
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
