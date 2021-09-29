//
// Created by Josh Freed on 2019-04-12.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

class UrlSessionService: DataReadService {
    func getData(url: URL) async throws -> Data? {
        SwiftyBeaver.debug("Getting data from URL session \(url)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
