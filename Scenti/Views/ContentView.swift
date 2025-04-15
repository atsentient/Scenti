//
//  ContentView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var showingAddView = false
    @State private var path: [CDPerfume] = []

    var body: some View {
        NavigationStack(path: $path) {
            PerfumeListView(path: $path)
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
                .navigationDestination(for: CDPerfume.self) { perfume in
                    DetailsView(perfume: perfume)
                }
        }
    }
}



#Preview {
    ContentView()
}
