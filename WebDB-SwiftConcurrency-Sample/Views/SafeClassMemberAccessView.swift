//
//  DataRaceClassView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct SafeClassMemberAccessView: View {
    @State var name: String?
    var body: some View {
        Text(name ?? "no name")
            .task {
                self.name = await safeClassMemberAccess()
            }
    }
}

struct SafeClassMemberAccessView_Previews: PreviewProvider {
    static var previews: some View {
        SafeClassMemberAccessView()
    }
}
