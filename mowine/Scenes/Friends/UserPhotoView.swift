//
//  UserPhotoView.swift
//  mowine
//
//  Created by Josh Freed on 2/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct UserPhotoView: View {
    let photoUrl: String
    var size: CGFloat = 44
    
    var body: some View {
        RemoteImageView(
            url: photoUrl,
            noImage: { Image("No Profile Picture").resizable().frame(width: size, height: size) },
            loading: { Image("No Profile Picture").resizable().frame(width: size, height: size) },
            error: { Image("No Profile Picture").resizable().frame(width: size, height: size) },
            loaded: {
                $0.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
        )
    }
}

struct UserPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UserPhotoView(photoUrl: "")
    }
}
