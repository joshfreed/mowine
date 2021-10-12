//
//  WineThumbnail.swift
//  mowine
//
//  Created by Josh Freed on 10/17/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct WineThumbnail: View {
    let wineId: String
    var size: CGFloat = 80
    @StateObject var vm = WineThumbnailViewModel()

    var body: some View {
        Group {
            if let uiImage = vm.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image("Default Wine Image")
                    .resizable()
                    .frame(width: size, height: size)
            }
        }
        .task {
            await vm.fetchThumbnail(wineId: wineId)
        }
    }
}

struct WineThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        WineThumbnail(wineId: "W1")
            .addPreviewEnvironment()
            .addPreviewData()
            .previewLayout(.sizeThatFits)

        WineThumbnail(wineId: "Z")
            .addPreviewEnvironment()
            .addPreviewData()
            .previewLayout(.sizeThatFits)
    }
}
