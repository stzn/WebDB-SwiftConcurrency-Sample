//
//  TaskView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

final class ViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    private lazy var indicator = UIActivityIndicatorView()
    private var task: Task<UIImage, Error>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        Task {
            indicator.startAnimating()
            task = Task {
                return try await fetchThumbnailWithAsyncAwait()
            }
            imageView.image = try? await task?.value
            task = nil
            indicator.stopAnimating()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        indicator.stopAnimating()
        task?.cancel()
    }

    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(indicator)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

struct TaskViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        ViewController()
    }
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

struct TaskViewController_Previews: PreviewProvider {
    static var previews: some View {
        TaskViewController()
    }
}
