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
    @ObservedObject var viewModel: PerfumeListViewModel
    @State private var showAddPerfumeView = false
    
    var body: some View {
        List {
            ForEach(viewModel.filteredPerfumes) { perfume in
                Button {
                    path.append(perfume)
                } label: {
                    HStack{
                        PerfumeRowView(
                            perfume: perfume,
                            onFavouriteTap: {
                                viewModel.toggleFavourite(for: perfume)
                                }
                            )
                            
                            if let imageData = perfume.imageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(12)
                            }
                        }
                    
                        .padding(.vertical, 6)
                    }
                    
                }
                .onDelete { offsets in
                            offsets.forEach { viewModel.removePerfume(at: $0) }
            }
        }
    }
    
    
    struct TagsView: View {
        var tags: [String]
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .padding(6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    struct PerfumeRowView: View {
        @ObservedObject var perfume: CDPerfume
        let onFavouriteTap: () -> Void
        
        var body: some View {
           
            HStack {
                VStack(alignment: .leading) {
                    Text(perfume.brand ?? "")
                        .font(.headline)
                    Text(perfume.name ?? "")
                        .font(.title2.bold())
                    Text(perfume.notes ?? "No notes")
                        .foregroundStyle(.brown)
                    TagsView(tags: perfume.tags ?? [])
                }
                
                Spacer()
                
                Button(action: onFavouriteTap) {
                    Image(systemName: perfume.favourite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                .buttonStyle(.plain)
            }

            
        }
    }
}
