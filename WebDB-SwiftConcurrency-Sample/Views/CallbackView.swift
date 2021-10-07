//
//  CallbackView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct CallbackView: View {
    @State private var image: UIImage?
    var body: some View {
        switch image {
        case .some(let image):
            sizeAdjustedImage(image)
        case .none:
            loadOnAppear {
                fetchThumbnailWithCompletion { result in
                    self.image = try? result.get()
                }
            }
        }
    }
}

struct CallbackView_Previews: PreviewProvider {
    static var previews: some View {
        CallbackView()
    }
}
