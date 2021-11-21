//
//  ConcurrencySampleApp.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

@main
struct ConcurrencySampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    Section("Async/Awaitのサンプル") {
                        NavigationLink("Callback形式の非同期処理") { CallbackView().navigationTitle("Callback形式の非同期処理") }
                        NavigationLink("Async/Await形式の非同期処理") { AsyncAwaitView().navigationTitle("Async/Await形式の非同期処理") }
                        NavigationLink("AsyncSequenceでループ処理") { AsyncSequenceView().navigationTitle("AsyncSequenceでループ処理") }
                        NavigationLink("Notification(AsyncSequence)から継続的にデータを受信") { NotificationsView().navigationTitle("Notifiations") }
                        NavigationLink("AsyncStreamでループ処理") { AsyncStreamView().navigationTitle("AsyncStreamでループ処理") }

                        NavigationLink("Continuationで既存実装を変換") { ContinuationView().navigationTitle("Continuationで既存実装を変換") }
                    }
                    .textCase(nil)
                    .headerProminence(.increased)
                    .navigationBarTitleDisplayMode(.inline)
                    Section("Task APIのサンプル") {
                        NavigationLink("async letで静的な数の同時並行処理") { AsyncLetView().navigationTitle("async let(静的)") }
                        NavigationLink("async letで動的な数の同時並行処理") { AsyncLetMultipleImagesView().navigationTitle("async let(動的)") }
                        NavigationLink("TaskThrowingGroupViewで同時並行処理") { TaskThrowingGroupView().navigationTitle("TaskThrowingGroup") }
                        NavigationLink("TaskGroupと協調キャンセルの動作確認") { TaskGroupCooperativeCancellationView().navigationTitle("TaskGroupと協調キャンセル") }
                        NavigationLink("TaskとUIKit") { TaskViewController().navigationTitle("TaskとUIKit") }
                        NavigationLink("TaskとSwiftUI") { TaskView(loader: ImageLoader()).navigationTitle("TaskとSwiftUI") }
                    }
                    .textCase(nil)
                    .headerProminence(.increased)
                    .navigationBarTitleDisplayMode(.inline)
                    Section("Actor/Sendableのサンプル") {
                        NavigationLink("データ競合を起こすclass") { DataRaceClassView().navigationTitle("データ競合を起こすclass") }
                        NavigationLink("データ競合を起こさないActor") { NotDataRaceActorView().navigationTitle("データ競合を起こさないActor") }
                        NavigationLink("Actorへの安全ではないアクセス") { UnsafeClassMemberAccessView().navigationTitle("Actorへの安全ではないアクセス") }
                        NavigationLink("Actorへの安全なアクセス") { SafeClassMemberAccessView().navigationTitle("Actorへの安全なアクセス") }
                    }
                    .textCase(nil)
                    .headerProminence(.increased)
                    .navigationBarTitleDisplayMode(.inline)
                }
                .navigationTitle("Swift Concurency入門サンプル")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
