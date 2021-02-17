//
//  AddWineHeaderView.swift
//  mowine
//
//  Created by Josh Freed on 2/16/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct AddWineHeaderView: View {
    var body: some View {
        Image("add-wine-header")
            .resizable()
            .aspectRatio(CGSize(width: 248, height: 93), contentMode: .fit)
            .frame(height: 93)
            .foregroundColor(Color("WineImageHeader"))
    }
}

struct AddWineHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AddWineHeaderView().previewLayout(.sizeThatFits)
    }
}
