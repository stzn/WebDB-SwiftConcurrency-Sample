//
//  TaskGroupCooperativeCancellationView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct TaskGroupCooperativeCancellationView: View {
    @State var isLoading: Bool = false
    var body: some View {
        VStack(spacing: 8) {
            Text("Consoleの出力結果を確認してください")
            VStack {
                button(needThrowError: false, needCheckCancel: false).disabled(isLoading)
                button(needThrowError: true, needCheckCancel: false).disabled(isLoading)
                button(needThrowError: true, needCheckCancel: true).disabled(isLoading)
            }
        }
    }

    private func button(needThrowError: Bool, needCheckCancel: Bool) -> some View {
        Button(buttonTitle(needThrowError: needThrowError, needCheckCancel: needCheckCancel)) {
            Task {
                isLoading = true
                await checkTaskGroupCooperativeCancellation(
                    needThrowError: needThrowError,
                    needCheckCancel: needCheckCancel
                )
                isLoading = false
            }
        }
        .foregroundColor(.white)
        .background(buttonColor(needThrowError: needThrowError, needCheckCancel: needCheckCancel))
        .buttonStyle(.bordered)
        .cornerRadius(8)
    }

    private func buttonTitle(needThrowError: Bool, needCheckCancel: Bool) -> String {
        switch (needThrowError, needCheckCancel) {
        case (true, true):
            return "エラーをスロー + エラーチェック"
        case (true, false):
            return "エラーをスロー"
        case (false, _):
            return "エラーなし"
        }
    }

    private func buttonColor(needThrowError: Bool, needCheckCancel: Bool) -> Color {
        switch (needThrowError, needCheckCancel) {
        case (true, true):
            return .red
        case (true, false):
            return .yellow
        case (false, _):
            return .blue
        }
    }

}

struct TaskThrowingGroupErrorView_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupCooperativeCancellationView()
    }
}
