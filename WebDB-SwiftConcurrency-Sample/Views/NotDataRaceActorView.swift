//
//  DataRaceClassView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct NotDataRaceActorView: View {
    var body: some View {
        Text("Thread SanitizerをONにして確認してください")
            .onAppear {
                notDataRace()
            }
    }
}

struct NonDataRaceActorView_Previews: PreviewProvider {
    static var previews: some View {
        NotDataRaceActorView()
    }
}
