//
//  TaskView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {
    @Published private(set) var image: UIImage?
    private var task: Task<UIImage, Error>?

    func load() {
        Task {
            self.image = await self.fetchThumbnail()
        }
    }

    private func fetchThumbnail() async -> UIImage? {
        task = Task {
            try await fetchThumbnailWithAsyncAwait()
        }
        defer { task = nil }
        guard let image = try? await task?.value else {
            return nil
        }
        Task.detached { try cacheImage(image) }
        return image
    }

    private func cancelDownload() {
        task?.cancel()
        task = nil
    }
}

struct TaskView: View {
    @ObservedObject var loader: ImageLoader
    var body: some View {
        switch loader.image {
        case .some(let image):
            sizeAdjustedImage(image)
        case .none:
            loadOnAppear {
                await loader.load()
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(loader: .init())
    }
}

// MARK: Image Cache

private func cacheImage(_ image: UIImage) throws {
    let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    guard let cachePath = cacheDirectory.first?.appendingPathComponent("imageCache.png") else {
        return
    }
    try image.pngData()?.write(to: cachePath)
}
