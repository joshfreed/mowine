//
//  WineThumbnailViewModel.swift
//  mowine
//
//  Created by Josh Freed on 10/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import UIKit
import MoWine_Application
import OSLog

class WineThumbnailViewModel: ObservableObject {
    @Published var uiImage: UIImage?

    @Injected private var query: GetWineThumbnailQueryHandler
    private let logger = Logger(category: .ui)

    @MainActor
    func fetchThumbnail(wineId: String) async {
        do {
            if let data = try await query.handle(wineId: wineId) {
                uiImage = UIImage(data: data)
            } else {
                uiImage = nil
            }
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
        }
    }
}
