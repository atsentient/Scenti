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
    @State private var showingFilterViewActive = false
    @State private var searchText: String = ""
    
    @StateObject private var viewModel: PerfumeListViewModel
        
        init() {
            let moc = PersistenceController.shared.container.viewContext
            _viewModel = StateObject(wrappedValue: PerfumeListViewModel(moc: moc))
        }
    
    var body: some View {
        NavigationStack(path: $path) {
            PerfumeListView(path: $path, viewModel: viewModel)
                .sheet(isPresented: $showingAddView) {
                    AddPerfumeView(
                        addPerfumeVM: AddPerfumeVM(moc: moc),
                        onSave: { viewModel.fetchPerfumes() }
                    )
                    .environment(\.managedObjectContext, moc)
                }
                .searchable(text: $searchText)
                .navigationTitle("My Collection")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingFilterViewActive = true
                        } label: {
                            Image(systemName: showingFilterViewActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        }
                    }
                } 
                .navigationDestination(for: CDPerfume.self) { perfume in
                    DetailsView(
                        detailsViewModel: DetailsViewModel(moc: moc, perfume: perfume)
                        )
                }
                .sheet(isPresented: $showingFilterViewActive) {
                    FilterView(selectedTags: $viewModel.selectedTags)
                }
                .onChange(of: viewModel.selectedTags) { _ in
                    viewModel.fetchPerfumes()
                }
        }
    }
}

#Preview {
    ContentView()
}

