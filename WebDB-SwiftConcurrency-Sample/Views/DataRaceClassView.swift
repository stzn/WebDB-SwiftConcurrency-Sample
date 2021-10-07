//
//  DataRaceClassView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct DataRaceClassView: View {
    var body: some View {
        Text("Thread SanitizerをONにして確認してください")
            .onAppear {
                dataRace()
            }
    }
}

struct DataRaceClassView_Previews: PreviewProvider {
    static var previews: some View {
        DataRaceClassView()
    }
}
