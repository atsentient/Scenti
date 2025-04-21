//
//  PerfumeListView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI
import CoreData

struct PerfumeListView: View {
    
    @Binding var path: [CDPerfume]
    var searchText: String
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var perfumes: FetchedResults<CDPerfume>
    
    init(path: Binding<[CDPerfume]>, searchText: String) {
        _path = path
        self.searchText = searchText
        
        let request: NSFetchRequest<CDPerfume> = CDPerfume.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDPerfume.createdAt, ascending: false)]
        
        if !searchText.isEmpty {
            request.predicate = NSPredicate(
                format: "name CONTAINS[cd] %@ OR brand CONTAINS[cd] %@ OR notes CONTAINS[cd] %@",
                searchText, searchText, searchText
            )
        }
        
        _perfumes = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        List {
            ForEach(perfumes) { perfume in
                Button {
                    path.append(perfume)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(perfume.brand ?? "No Brand")
                            .foregroundStyle(.black)
                        Text(perfume.name ?? "Unnamed")
                        Text(perfume.notes ?? "No notes")
                            .foregroundStyle(.brown)
                        Button {
                            perfume.favourite.toggle()
                            try? moc.save()
                        } label: {
                            Image(systemName: perfume.favourite ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 6)
                    
                }
                
            }
            .onDelete(perform: removePerfume)
            
        }
    }
    
    
    func removePerfume(at offsets: IndexSet) {
        for index in offsets {
            let perfume = perfumes[index]
            moc.delete(perfume)
        }
        
        do {
            try moc.save()
        } catch {
            print("Delete error: \(error.localizedDescription)")
        }
    }
}
