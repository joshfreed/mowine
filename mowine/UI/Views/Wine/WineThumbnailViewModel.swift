//
//  WineThumbnailViewModel.swift
//  mowine
//
//  Created by Josh Freed on 10/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import UIKit
import Model
import FirebaseCrashlytics
import SwiftyBeaver

class WineThumbnailViewModel: ObservableObject {
    @Published var uiImage: UIImage?

    @Injected private var query: GetWineThumbnailQueryHandler

    @MainActor
    func fetchThumbnail(wineId: String) async {
        do {
            if let data = try await query.handle(wineId: wineId) {
                uiImage = UIImage(data: data)
            } else {
                uiImage = nil
            }
        } catch {
            Crashlytics.crashlytics().record(error: error)
            SwiftyBeaver.error("\(error)")
        }
    }
}