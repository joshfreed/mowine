//
//  FriendListItemView.swift
//  mowine
//
//  Created by Josh Freed on 2/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct FriendListItemView: View {
    let name: String
    let thumbnail: URL?
    
    var body: some View {
        HStack(spacing: 8) {
            UserPhotoView(photo: .url(thumbnail))
            
            Text(name)
                .font(.system(size: 21))
            
            Spacer()
        }
    }
}

struct FriendListItemView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListItemView(name: "Test Person", thumbnail: nil)
    }
}
