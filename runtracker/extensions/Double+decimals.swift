import Foundation

extension Double {
    func string(withDecimals places: Int) -> String {
        let formatString = "%.\(places)f"
        return String(format: formatString, self)
    }
}
