import Foundation
import OSLog

extension Logger {
    private static let subsystem = "MoWine.Application"

    enum Category: String {
        case friends = "Friends"
        case myCellar = "My Cellar"
    }

    init(category: Category) {
        self.init(subsystem: Logger.subsystem, category: category.rawValue)
    }
}

