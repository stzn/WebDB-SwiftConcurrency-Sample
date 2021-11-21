//
//  ConcurrencyFunctions.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

private enum FetchError: Error {
    case badURL, response, badImage
}

private let randomImageURL = URL(string: "https://dog.ceo/api/breeds/image/random")!
private struct APIDog: Decodable {
    let message: String
    let status: String
}

// MARK: Async/Await samples

// MARK: コールバック形式

func fetchThumbnailWithCompletion(completion: @escaping (Result<UIImage, Error>) -> Void) {
    URLSession.shared.dataTask(with: randomImageURL) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200,
              let data = data else {
            completion(.failure(FetchError.response))
            return
        }
        guard let message = try? JSONDecoder().decode(APIDog.self, from: data).message,
              let imageURL = URL(string: message) else {
                  completion(.failure(FetchError.badURL))
                  return
              }
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data else {
                completion(.failure(FetchError.response))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(FetchError.badImage))
                return
            }
            completion(.success(image))
        }
        .resume()
    }
    .resume()
}

// MARK: async/await形式

func fetchThumbnailWithAsyncAwait() async throws -> UIImage {
    let(data, response) = try await URLSession.shared.data(from: randomImageURL)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw FetchError.response
    }
    let message = try JSONDecoder().decode(APIDog.self, from: data).message
    guard let imageURL = URL(string: message) else {
        throw FetchError.badURL
    }
    let(imageData, imageResponse) = try await URLSession.shared.data(from: imageURL)
    guard let imageResponse = imageResponse as? HTTPURLResponse, imageResponse.statusCode == 200 else {
        throw FetchError.response
    }
    guard let image = UIImage(data: imageData) else {
        throw FetchError.badImage
    }
    return image
}

// MARK: async read-onlyプロパティ

struct ThumbnailCreateError: Error {}
extension UIImage {
    var thumbnail: UIImage {
        get async throws {
            let size = CGSize(width: 240, height: 240)
            guard let image = await byPreparingThumbnail(ofSize: size) else {
                throw ThumbnailCreateError()
            }
            return image
        }
    }
}

// MARK: AsyncSequence

struct Thumbnails: AsyncSequence {
    typealias Element = UIImage
    var images: [UIImage]
    var width: CGFloat
    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(images: images, width: width)
    }
    struct AsyncIterator: AsyncIteratorProtocol {
        fileprivate var images: [UIImage]
        fileprivate var width: CGFloat
        mutating func next() async throws -> UIImage? {
            guard !images.isEmpty else { return nil }
            let image = images.removeFirst()
            let size = thumbnailSize(of: image, width: width)
            guard let thumbnail = await image.byPreparingThumbnail(ofSize: size) else {
                return nil
            }
            return thumbnail
        }
    }
}

// MARK: AsyncStream

func thumbnails(from images: [UIImage], width: CGFloat) -> AsyncThrowingStream<UIImage, Error> {
    AsyncThrowingStream(UIImage.self) { continuation in
        Task.detached {
            for image in images {
                let size = thumbnailSize(of: image, width: width)
                guard let thumbnail = await image.byPreparingThumbnail(ofSize: size) else {
                    continuation.finish(throwing: ThumbnailCreateError())
                    return
                }
                continuation.yield(thumbnail)
            }
            continuation.finish()
        }
    }
}

private func thumbnailSize(of image: UIImage, width: CGFloat) -> CGSize {
    let aspectScale = image.size.height / image.size.width
    return CGSize(width: width, height: width * aspectScale)
}

// MARK: Continuation

func fetchThumbnailWithContinuation() async throws -> UIImage {
    try await withCheckedThrowingContinuation { continuation in
        fetchThumbnailWithCompletion { result in
            continuation.resume(with: result)
        }
    }
}

// MARK: - Task API samples

// MARK: async let(静的な数の同時並行処理)

func fetchThumbnailWithAsyncLet() async throws -> UIImage {
    async let image = fetchThumbnailWithAsyncAwait()
    async let size = fetchSize()
    guard let thumbnail = try await image.byPreparingThumbnail(ofSize: size) else {
        throw FetchError.badImage
    }
    return thumbnail
}

private func fetchSize() async throws -> CGSize {
    let sizeURL = URL(string: "https://www.random.org/integers/?num=1&min=100&max=500&col=1&base=10&format=plain&rnd=new")!
    let(data, response) = try await URLSession.shared.data(from: sizeURL)
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw FetchError.response
    }
    let number = try JSONDecoder().decode(Int.self, from: data)
    return CGSize(width: number, height: number)
}

// MARK: async let(動的な数の同時並行処理)

func fetchThumbnailsWithAsyncLet() async throws -> [UIImage] {
    var thumbnails: [Int: UIImage] = [:]
    for id in 0..<5 {
        async let image = fetchThumbnailWithAsyncAwait()
        thumbnails[id] = try await image
    }
    return thumbnails.map(\.value)
}

// MARK: TaskThrowingGroup

func fetchThumbnailsWithTaskThrowingGroup() async throws -> [UIImage] {
    var thumbnails: [Int: UIImage] = [:]
    try await withThrowingTaskGroup(of: (Int, UIImage).self) { group in
        for id in 0..<5 {
            group.addTask {
                let image = try await fetchThumbnailWithAsyncAwait()
                return (id, image)
            }
        }
        for try await (id, thumbnail) in group {
            thumbnails[id] = thumbnail
        }
    }
    return thumbnails.map(\.value)
}

// MARK: - Actor samples

// MARK: データ競合を起こすクラス

class CounterClass {
    var value = 0
    func increment() -> Int {
        value += 1
        return value
    }
}

func dataRace() {
    let counter = CounterClass()
    // データ競合が発生する
    Task.detached { print(counter.increment()) }
    Task.detached { print(counter.increment()) }
}

// MARK: データ競合を起こさないActor

actor CounterActor {
    var value = 0
    func increment() -> Int {
        value += 1
        return value
    }
}

func notDataRace() {
    let counter = CounterActor()
    // データ競合が発生しない
    Task.detached { print(await counter.increment()) }
    Task.detached { print(await counter.increment()) }
}

// MARK: データ競合を起こすActor内部メンバへのアクセス

class Person {
    var name: String
    init(name: String) {
        self.name = name
    }
}

actor BankAccount {
    private var owners: [Person]
    init(owners: [Person]) {
        self.owners = owners
    }
    func primaryOwner() -> Person? {
        return owners.first
    }
}

func unsafeClassMemberAccess() async -> String? {
    let owner = Person(name: "person")
    let account = BankAccount(owners: [owner])
    if let primary = await account.primaryOwner() {
        primary.name = "The Honorable " + primary.name
    }
    return await account.primaryOwner()?.name // 値が変わってしまっている!
}

// MARK: データ競合を起こさないActor内部メンバへのアクセス

// Sendableに準拠させることでBankAcountのinitのチェックが除外できる
// しかし、そもそもnameが変更できなくなる
final class SendablePerson: Sendable {
    let name: String
    init(name: String) {
        self.name = name
    }
}

extension BankAccount {
    func primaryOwnerName() -> String? {
        owners.first?.name
    }
}

func safeClassMemberAccess() async -> String? {
    let owner = Person(name: "person")
    let account = BankAccount(owners: [owner])
    if var name = await account.primaryOwnerName() {
        name = "The Honorable " + name
    }
    return await account.primaryOwnerName() // 値は変わらない
}
