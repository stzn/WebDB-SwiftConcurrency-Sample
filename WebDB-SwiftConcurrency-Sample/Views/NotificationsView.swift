//
//  AsyncSequenceView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

private let samples: [UIImage] = [
    .init(named: "bali")!, .init(named: "cambodia")!,
    .init(named: "cork")!, .init(named: "tokyo")!,
    .init(named: "new-zealand")!, .init(named: "paris")!,
    .init(named: "st-lucia")!, .init(named: "patagonia")!,
]

private let imageWidth: CGFloat = 50
private let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: imageWidth)), count: 5)

struct Thumbnail: Identifiable {
    var id: UUID
    var image: UIImage
}

@MainActor
private final class NotificationsViewModel: ObservableObject {
    @Published private(set) var images = [Thumbnail]()

    func startNotification() async {
        print("notification start")
        for try await notification in NotificationCenter.default.notifications(named: .postNewImage, object: self) {
            guard let image = notification.userInfo?[noficationImageKey] as? UIImage else {
                return
            }
            images.append(Thumbnail(id: UUID(), image: image))
        }
        print("notification end")
    }

    func post() {
        NotificationCenter.default.post(
            name: .postNewImage,
            object: self,
            userInfo: [noficationImageKey: samples[Int.random(in: 0..<samples.count)]])
    }
}

struct NotificationsView: View {
    @StateObject fileprivate var viewModel = NotificationsViewModel()

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.images, id: \.id) { thumb in
                    Image(uiImage: thumb.image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }.toolbar {
            Button("通知", action: { viewModel.post() })
        }
        .task {
            await viewModel.startNotification()
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

// MARK: - Notification

private let noficationImageKey = "NewImage"
private extension Notification.Name {
    static let postNewImage = Notification.Name("PostNewImage")
}

