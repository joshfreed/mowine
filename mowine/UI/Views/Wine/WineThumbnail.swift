//
//  WineThumbnail.swift
//  mowine
//
//  Created by Josh Freed on 10/17/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct WineThumbnail: View {
    let data: Data?

    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        } else {
            Image("Default Wine Image")
                .resizable()
                .frame(width: 80, height: 80)
        }
    }
}

struct WineThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        WineThumbnail(data: nil)
    }
}
