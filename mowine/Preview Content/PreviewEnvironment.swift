//
//  PreviewEnvironment.swift
//  mowine
//
//  Created by Josh Freed on 1/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

extension View {
    func addPreviewEnvironment() -> some View {
        let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
        JFContainer.configureForPreviews()
        
        return addAppEnvironment()
    }
}
