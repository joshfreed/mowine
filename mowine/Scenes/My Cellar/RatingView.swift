//
//  RatingView.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    var rating: Int

    var body: some View {
        HStack {
            ForEach(0..<rating, id: \.self) { index in
                Star(corners: 5, smoothness: 0.4)
                    .fill(Color("Rating"))
                    .frame(width: 20, height: 20)
            }
            ForEach(rating..<5, id: \.self) { index in
                Star(corners: 5, smoothness: 0.4)
                    .stroke(Color("Rating"))
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 0)
    }
}
