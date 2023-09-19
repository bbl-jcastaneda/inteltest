import Foundation
@objc public class IntelTest: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
