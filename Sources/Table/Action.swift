import UIKit

final class Action: NSObject {
    private let _action: () -> ()

    public init(_ action: @escaping () -> ()) {
        _action = action
        super.init()
    }

    @objc public func action() {
        _action()
    }
}

extension UIControl {
    func addAction(_ event: UIControl.Event = .valueChanged, _ closure: @escaping ()->()) {
        let action = Action(closure)
        addTarget(action, action: #selector(Action.action), for: event)
        Associated(self).set(action, .random, .OBJC_ASSOCIATION_RETAIN)
    }
}

struct Associated {
    public enum Key {
        case random
        case hashable(AnyHashable)
        case pointer(UnsafeRawPointer)
        
        var pointer: UnsafeRawPointer {
            switch self {
            case .random:
                var pointer: UnsafeRawPointer?
                repeat {
                    pointer = UnsafeRawPointer(bitPattern: Int(arc4random()) )
                } while pointer == nil
                return pointer!
            case .hashable(let anyHashable):
                return UnsafeRawPointer(bitPattern: anyHashable.hashValue)!
            case .pointer(let pointer):
                return pointer
            }
        }
    }
    
    private weak var object: AnyObject?
    
    public init(_ object: AnyObject) { self.object = object }
    
    @discardableResult
    public func set(_ value: Any?, _ key: Key, _ policy: objc_AssociationPolicy) -> Key? {
        guard let object = object else { return nil }
        objc_setAssociatedObject(object, key.pointer, value, policy)
        return .pointer(key.pointer)
    }
    
    public func get(_ key: Key) -> Any? {
        guard let object = object else { return nil }
        return objc_getAssociatedObject(object, key.pointer)
    }
}
