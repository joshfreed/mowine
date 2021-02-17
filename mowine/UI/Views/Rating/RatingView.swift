//
//  RatingView.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

/// A view that displays a star rating out of 5 stars.
///
/// If you want users to be able to change the rating, use `RatingPicker` or `FormRatingPicker` instead.
struct RatingLabel: View {
    let rating: Int
    var starSize: CGFloat = 20
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                RatingStar(rating: rating, value: index)
                    .frame(width: starSize, height: starSize)
            }
        }
    }
}

/// A view that allows picking a star rating by tapping on a star.
///
/// Inside a `Form` view use `FormRatingPicker` instead.
struct RatingPicker: View {
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

/// A view that allows picking a star rating by tapping on a star inside a `Form` view.
///
/// The SwiftUI `Form` view does weird things when there are multiple buttons inside a row. This is a specialized view that
/// doesn't use regular buttons so that the picker will work inside a form.
struct FormRatingPicker: View {
    @Binding var rating: Int
    var starSize: CGFloat = 20

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                RatingStar(rating: rating, value: index)
                    .frame(width: starSize, height: starSize)
                    .onTapGesture { rating = index }
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
    struct StandaloneEditor: View {
        @State var rating: Int = 0
        
        var body: some View {
            RatingPicker(rating: $rating)
        }
    }
    
    struct FormEditor: View {
        @State var rating: Int = 0
        
        var body: some View {
            Form {
                FormRatingPicker(rating: $rating)
            }
        }
    }
    
    static var previews: some View {
        StandaloneEditor().previewLayout(.sizeThatFits)
        FormEditor().previewLayout(.fixed(width: 390, height: 110))
        VStack {
            RatingLabel(rating: 0)
            RatingLabel(rating: 1)
            RatingLabel(rating: 2)
            RatingLabel(rating: 3)
            RatingLabel(rating: 4)
            RatingLabel(rating: 5)
            RatingLabel(rating: 6)
        }.previewLayout(.sizeThatFits)
    }
}
