extension BinaryFloatingPoint {
    func map<T:BinaryFloatingPoint>(min1:T, max1:T, min2:T, max2:T) -> T {
        min2 + (max2 - min2) * (T(self) - min1) / (max1 - min1)
    }
}
