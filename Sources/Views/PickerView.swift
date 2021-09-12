import UIKit

protocol PickerViewDelegate {
    func update(current: [String], type: String?, value: String?)
}

enum PickerType: Equatable {
    case weight(String, String = ""), height(String, String = ""),
         settings(PickerSettings), custom(String, Any, Any = 0)
    
    static func ==(lhs: PickerType, rhs: PickerType) -> Bool {
        switch (lhs, rhs) {
        case (.weight(_,_), .weight(_,_)): return true
        case (.height(_,_), .height(_,_)): return true
        case (.settings(_), .settings(_)): return true
        case (.custom(_,_,_), .custom(_,_,_)): return true
        default: return false
        }
    }
    
    var settings: PickerSettings {
        switch self {
        case .weight(let type, let setting): return PickerSettings(type: type, ["lb", "kg"], setting)
        case .height(let type, let setting): return PickerSettings(type: type, ["ft", "m"], setting)
        case .settings(let settings): return settings
        case .custom(let type, let strings, let selected):
            return PickerSettings(type: type, strings, selected)
        }
    }
}

struct PickerSettings {
    var type: String = ""
    var strings: [String] = []
    var selected: Int = 0
    
    init() {}
    init(type: String, _ strings: Any) {
        if let value = strings as? String { self.strings = [value] }
        if let value = strings as? [String] { self.strings = value }
        if let value = strings as? Range<Int> { self.strings = value.strings }
        if let value = strings as? ClosedRange<Int> { self.strings = value.strings }
        self.type = type
    }
    init(type: String, _ strings: Any, _ selected: Any) {
        self.init(type: type, strings)
        if let value = selected as? Int { self.selected = value }
        if let value = selected as? String { self.selected = self.strings.find(value) }
    }
}

class PickerView: UIView {
    var picker = UIPickerView()
    var pickers: [PickerType] = []
    var delegate: PickerViewDelegate?
    
    var current: [String] {
        var array: [String] = []
        for (i, p) in pickers.enumerated() {
            guard let e = p.settings.strings[safe: picker.selectedRow(inComponent: i)] else { continue }
            array.append(e)
        }
        return array
    }
    
    var create: Self {
        DispatchQueue.main.async { self.picker.frame = self.bounds }
        picker.delegate = self
        picker.dataSource = self
        
        addSubview(picker)
        
        delegate?.update(current: current, type: nil, value: nil)
        return self
    }
    
    @discardableResult
    func configure(_ pickers: [PickerType]) -> Self {
        self.pickers = pickers
        picker.reloadAllComponents()
        for (i, p) in pickers.enumerated() {
            picker.selectRow(p.settings.selected, inComponent: i, animated: false)
        }
        return self
    }
}

extension PickerView {
    @discardableResult
    func delegate(_ object: PickerViewDelegate) -> Self {
        delegate = object
        return self
    }
}

extension PickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let p = pickers[safe: component],
            let e = p.settings.strings[safe: row] else { return }
        delegate?.update(current: current, type: p.settings.type, value: e)
    }
}

extension PickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { pickers.count }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let count = pickers[safe: component]?.settings.strings.count else { return 0 }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { 50 }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let text = pickers[safe: component]?.settings.strings[safe: row] else { return UIView() }
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        return label
    }
}

private extension Range where Bound == Int {
    var strings: [String] { self.map{ String($0) } }
}
private extension ClosedRange where Bound == Int {
    var strings: [String] { self.map{ String($0) } }
}
private extension Array where Element == String {
    func find(_ string: String) -> Int {
        guard let value = self.firstIndex(of: string) else { return 0 }
        return value
    }
}
