//
//  PerfumeListView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI
import CoreData

struct PerfumeListView: View {
    @FetchRequest(
        entity: CDPerfume.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CDPerfume.createdAt, ascending: false)]
    ) var perfumes: FetchedResults<CDPerfume>
    
    @Environment(\.managedObjectContext) var moc
    @Binding var path: [Perfume]

    var body: some View {
        List {
            ForEach(perfumes) { perfume in
                Button {
                    path.append(perfume.toModel())
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(perfume.name ?? "Unnamed")
                        Text(perfume.brand ?? "No Brand")
                        Text(perfume.notes ?? "No notes")
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
