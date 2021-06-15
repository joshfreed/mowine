//
//  RemoteImageView.swift
//  mowine
//
//  Created by Josh Freed on 5/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver

struct RemoteImageView<NoImageView: View, LoadingView: View, ErrorView: View, LoadedView: View>: View {
    @ObservedObject var remoteImageModel: RemoteImageModel
    let noImage: NoImageView
    let loading: LoadingView
    let error: ErrorView
    let loaded: (Image) -> LoadedView

    init(
        url: String,
        remoteImageModel: RemoteImageModel = .init(imageLoader: URLSessionImageLoader()),
        @ViewBuilder noImage: () -> NoImageView,
        @ViewBuilder loading: () -> LoadingView,
        @ViewBuilder error: () -> ErrorView,
        loaded: @escaping (Image) -> LoadedView
    ) {
        self.remoteImageModel = remoteImageModel
        self.noImage = noImage()
        self.loading = loading()
        self.error = error()
        self.loaded = loaded

        remoteImageModel.load(urlString: url)
    }

    var body: some View {
        switch remoteImageModel.state {
        case .noImage: noImage
        case .loading: loading
        case .loaded(let image): loaded(Image(uiImage: image).resizable())
        case .error: error
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(url: "", noImage: {
            Text("No image")
        }, loading: {
            Text("Loading...")
        }, error: {
            Text("ERROR!")
        }, loaded: { $0 })
    }
}
