//
//  WineImageView.swift
//  mowine
//
//  Created by Josh Freed on 2/6/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct WineImageView: View {
    let image: UIImage?
    
    var body: some View {
        if let uiImage = image {
            ZStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .layoutPriority(-1)
                    .clipShape(Circle())
                
                Color.clear.frame(minWidth: 0, maxWidth: .infinity)
            }
            .clipped()
            .aspectRatio(1, contentMode: .fit)            
        } else {
            Image("Default Wine Image").resizable()
        }        
    }
}

struct WineImageView_Previews: PreviewProvider {
    static var previews: some View {
        WineImageView(image: nil).frame(width: 150, height: 150).previewLayout(.sizeThatFits)
        WineImageView(image: UIImage(named: "Wine1")).previewLayout(.sizeThatFits)
    }
}
