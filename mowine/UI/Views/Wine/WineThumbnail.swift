//
//  WineThumbnail.swift
//  mowine
//
//  Created by Josh Freed on 10/17/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct WineThumbnail: View {
    let thumbnailPath: String
    var size: CGFloat = 80

    var body: some View {
        RemoteImageView(
            url: thumbnailPath,
            remoteImageModel: RemoteImageModel(),
            noImage: { Image("Default Wine Image").resizable().frame(width: size, height: size) },
            loading: { Image("Default Wine Image").resizable().frame(width: size, height: size) },
            error: { Image("Default Wine Image").resizable().frame(width: size, height: size) },
            loaded: {
                $0.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
        )
    }
}

struct WineThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        WineThumbnail(thumbnailPath: "Wine1")
            .addPreviewEnvironment()
    }
}
