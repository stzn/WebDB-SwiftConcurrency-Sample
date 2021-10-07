//
//  AsyncSequenceView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

private let samples: [UIImage] = [
    .init(named: "new-zealand")!, .init(named: "paris")!,
    .init(named: "st-lucia")!, .init(named: "patagonia")!,
]

struct AsyncStreamView: View {
    @State private var images = [UIImage]()

    var body: some View {
        ScrollView {
            if images.isEmpty {
                GeometryReader { proxy in
                    let width = proxy.size.width
                    loadOnAppear {
                        var thumbs: [UIImage] = []
                        for try await image in thumbnails(from: samples, width: width) {
                            thumbs.append(image)
                        }
                        images = thumbs
                    }
                }
            } else {
                VStack {
                    ForEach(images, id: \.self, content: Image.init(uiImage:))
                }
            }
        }
    }
}

struct AsyncStreamView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncStreamView()
    }
}
