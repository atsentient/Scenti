//
//  ContentView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddView = false

    var body: some View {
        NavigationStack {
            PerfumeListView()
                .navigationTitle("Scenti")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddView) {
                    AddPerfumeView()
                }
        }
    }
}

    


#Preview {
    ContentView()
}
