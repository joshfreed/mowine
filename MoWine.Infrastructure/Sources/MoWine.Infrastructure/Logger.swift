import Foundation
import OSLog

extension Logger {
    private static let subsystem = "MoWine.Infrastructure"

    enum Category: String {
        case apple = "Apple"
        case firebase = "Firebase"
    }

    init(category: Category) {
        self.init(subsystem: Logger.subsystem, category: category.rawValue)
    }
}
