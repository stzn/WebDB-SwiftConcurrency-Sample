//
//  AsyncAwaitView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct AsyncLetView: View {
    @State private var image: UIImage?
    var body: some View {
        switch image {
        case .some(let image):
            sizeAdjustedImage(image)
        case .none:
            loadOnAppear {
                self.image = try await fetchThumbnailWithAsyncLet()
            }
        }
    }
}

struct AsyncLetView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetView()
    }
}
