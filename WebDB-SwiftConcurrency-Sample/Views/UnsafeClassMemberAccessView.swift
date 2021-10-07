//
//  DataRaceClassView.swift
//  WebDB-SwiftConcurrency-Sample
//
//

import SwiftUI

struct UnsafeClassMemberAccessView: View {
    @State var name: String?
    var body: some View {
        Text(name ?? "no name")
            .task {
                self.name = await unsafeClassMemberAccess()
            }
    }
}

struct UnsafeClassMemberAccessView_Previews: PreviewProvider {
    static var previews: some View {
        UnsafeClassMemberAccessView()
    }
}
