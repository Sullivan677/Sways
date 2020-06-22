import Foundation

extension Date {
    func isLessThan(_ date: Date) -> Bool {
        if self.timeIntervalSince(date) < date.timeIntervalSinceNow {
            return true
        } else {
            return false
        }
    }
}
