//
//  ContentView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var moc

    @State private var showingAddView = false
    @State private var path: [CDPerfume] = []
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack(path: $path) {
            PerfumeListView(path: $path, searchText: searchText)
                .searchable(text: $searchText)
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
                        .environment(\.managedObjectContext, moc)
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

