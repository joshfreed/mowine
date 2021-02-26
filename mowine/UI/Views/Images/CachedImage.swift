//
//  CachedImage.swift
//  ConstantImprovers
//
//  Created by Josh Freed on 5/20/20.
//  Copyright © 2020 Clay Steadman. All rights reserved.
//

import SwiftUI

struct CachedImage<NoImageView: View, LoadingView: View, ErrorView: View, LoadedView: View>: View {
    @ObservedObject var remoteImageLoader: RemoteImageLoader
    let noImage: NoImageView
    let loading: LoadingView
    let error: ErrorView
    let loaded: (Image) -> LoadedView

    init(
        url: String,
        @ViewBuilder noImage: () -> NoImageView,
        @ViewBuilder loading: () -> LoadingView,
        @ViewBuilder error: () -> ErrorView,
                     loaded: @escaping (Image) -> LoadedView
    ) {
        remoteImageLoader = RemoteImageLoader(urlString: url)
        self.noImage = noImage()
        self.loading = loading()
        self.error = error()
        self.loaded = loaded
    }

    var body: some View {
        switch remoteImageLoader.state {
        case .noImage: return AnyView(noImage)
        case .loading: return AnyView(loading)
        case .loaded(let image): return AnyView(loaded(Image(uiImage: image).resizable()))
        case .error: return AnyView(error)
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage(url: "", noImage: {
            Text("No image")
        }, loading: {
            Text("Loading...")
        }, error: {
            Text("ERROR!")
        }, loaded: { $0 })
    }
}
