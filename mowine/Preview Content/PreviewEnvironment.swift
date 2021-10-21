//
//  PreviewEnvironment.swift
//  mowine
//
//  Created by Josh Freed on 1/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

extension View {
    func addPreviewEnvironment() -> some View {
        addAppEnvironment()
            .environmentObject(ObservableSession(session: try! JFServices.resolve()))
    }
}
