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

    var body: some View {
        List {
            ForEach(perfumes) { perfume in
                VStack(alignment: .leading, spacing: 4) {
                    Text(perfume.name ?? "Unnamed")
                    Text(perfume.brand ?? "No Brand")
                    Text(perfume.notes ?? "No notes")
                }
                .padding(.vertical, 6)
            }
        }
    }
}

#Preview {
    PerfumeListView()
}
