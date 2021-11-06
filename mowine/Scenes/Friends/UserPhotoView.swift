//
//  UserPhotoView.swift
//  mowine
//
//  Created by Josh Freed on 2/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

enum UserPhoto {
    case url(URL?)
    case uiImage(UIImage)
}

struct UserPhotoView: View {
    let photo: UserPhoto
    var size: CGFloat = 44
    
    var body: some View {
        Group {
            switch photo {
            case .url(let url):
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image("No Profile Picture")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            case .uiImage(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)

            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

struct UserPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UserPhotoView(photo: .url(URL(string: "https://picsum.photos/150")), size: 128).previewLayout(.sizeThatFits)
        UserPhotoView(photo: .url(URL(string: "")), size: 128).previewLayout(.sizeThatFits)
        UserPhotoView(photo: .uiImage(UIImage(named: "JoshCats")!), size: 128).previewLayout(.sizeThatFits)
    }
}
