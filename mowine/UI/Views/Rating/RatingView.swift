//
//  RatingView.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var starSize: CGFloat = 20

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Button(action: { rating = index }) {
                    RatingStar(rating: rating, value: index)
                        .frame(width: starSize, height: starSize)
                }
                .accessibility(identifier: "Star\(index)")
            }
        }
    }
}

struct RatingStar: View {
    /// The rating given to the item
    let rating: Int
    /// The value of this particular star, from 1 to max rating (5)
    let value: Int
    
    var body: some View {
        if value <= rating {
            Star().fill(Color("Rating"))
        } else {
            Star().stroke(Color("Rating"))
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(0)).previewLayout(.sizeThatFits)
        RatingView(rating: .constant(1)).previewLayout(.sizeThatFits)
        RatingView(rating: .constant(2)).previewLayout(.sizeThatFits)
        RatingView(rating: .constant(3)).previewLayout(.sizeThatFits)
        RatingView(rating: .constant(4)).previewLayout(.sizeThatFits)
        RatingView(rating: .constant(5)).previewLayout(.sizeThatFits)
        RatingView(rating: .constant(6)).previewLayout(.sizeThatFits)
    }
}
