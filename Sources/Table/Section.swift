extension RZTable {
    public struct Section {
        public var data: Any?
        public var items: [Item] = []
        public var header: String?
        public var footer: String?
        
        public init(data: Any? = nil, items: [Item] = [], header: String? = nil, footer: String? = nil) {
            self.data = data
            self.items = items
            self.header = header
            self.footer = footer
        }
    }
}
