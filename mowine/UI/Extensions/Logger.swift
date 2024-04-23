import Foundation
import OSLog

extension Logger {
    private static let subsystem = "MoWine"

    enum Category: String {
        case app = "App"
        case ui = "UI"
    }

    init(category: Category) {
        self.init(subsystem: Logger.subsystem, category: category.rawValue)
    }
}
