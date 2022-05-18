extension Collection {
    public struct Item {
        public var data: Any?
        public var id: String
        
        public init(data: Any? = nil, id: String) {
            self.data = data
            self.id = id
        }
    }
}
