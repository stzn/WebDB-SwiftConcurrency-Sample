//
//  AsyncAwaitView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct AsyncAwaitView: View {
    @State private var image: UIImage?
    var body: some View {
        switch image {
        case .some(let image):
            sizeAdjustedImage(image)
        case .none:
            loadOnAppear {
                self.image = try await fetchThumbnailWithAsyncAwait()
            }
        }
    }
}

struct AsyncAwaitView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitView()
    }
}
