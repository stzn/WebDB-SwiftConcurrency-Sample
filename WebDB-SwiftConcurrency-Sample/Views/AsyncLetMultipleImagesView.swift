//
//  AsyncSequenceView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct AsyncLetMultipleImagesView: View {
    @State private var images = [UIImage]()
    var body: some View {
        if images.isEmpty {
            loadOnAppear {
                let images = try await fetchThumbnailsWithAsyncLet()
                self.images.append(contentsOf: images)
            }
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(images, id: \.self, content: Image.init(uiImage:))
                }
            }
        }
    }
}

struct AsyncLetMultipleImagesView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetMultipleImagesView()
    }
}
