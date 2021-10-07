//
//  ViewHelper.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

func loadOnAppear(action: @Sendable @escaping () async throws -> Void) -> some View {
    ProgressView()
        .task {
            do {
                try await action()
            } catch {
                print(error)
            }
        }
}

func sizeAdjustedImage(_ image: UIImage) -> some View {
    VStack {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
