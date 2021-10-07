//
//  AsyncSequenceView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

private let samples: [UIImage] = [
    .init(named: "bali")!, .init(named: "cambodia")!,
    .init(named: "cork")!, .init(named: "tokyo")!,
]

struct AsyncSequenceView: View {
    @State private var images = [UIImage]()
    var body: some View {
        ScrollView {
            if images.isEmpty {
                GeometryReader { proxy in
                    let width = proxy.size.width
                    loadOnAppear {
                        var thumbs: [UIImage] = []
                        for try await image in Thumbnails(images: samples, width: width) {
                            thumbs.append(image)
                        }
                        images = thumbs
                    }
                }
            } else {
                LazyVStack {
                    ForEach(images, id: \.self, content: Image.init(uiImage:))
                }
            }
        }
    }
}

struct AsyncSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncSequenceView()
    }
}
