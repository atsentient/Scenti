//
//  PerfumeListView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI
import CoreData

struct PerfumeListView: View {
    
    @ObservedObject var profileVM: ProfileVM
    @Binding var path: [CDPerfume]
    @ObservedObject var viewModel: PerfumeListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.filteredPerfumes) { perfume in
                PerfumeRowView(
                    perfume: perfume,
                    favoriteNotes: profileVM.selectedNotes,
                    onFavouriteTap: { viewModel.toggleFavourite(for: perfume) }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    path.append(perfume)
                }
            }
            .onDelete { offsets in
                offsets.forEach { viewModel.removePerfume(at: $0) }
            }
        }
    }
    
    struct PerfumeRowView: View {
        @ObservedObject var perfume: CDPerfume
        let favoriteNotes: [String]
        let onFavouriteTap: () -> Void
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                
                // Фото
                if let imageData = perfume.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(12)
                }
                
                // Текстовая информация
                VStack(alignment: .leading, spacing: 6) {
                    Text(perfume.brand ?? "")
                        .font(.headline)
                    
                    Text(perfume.name ?? "")
                        .font(.title2.bold())
                    
                    TagsView(
                        perfume: perfume,
                        favoriteNotes: favoriteNotes
                    )
                }
                
                Spacer()
                
                Button(action: onFavouriteTap) {
                    Image(systemName: perfume.favourite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 6)
        }
    }
    
    struct TagsView: View {
        @ObservedObject var perfume: CDPerfume
        let favoriteNotes: [String]
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    let notes = perfume.tags as? [String] ?? []
                    ForEach(notes, id: \.self) { note in
                        Text(note.capitalized)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                favoriteNotes.contains(note)
                                    ? Color.green.opacity(0.3)
                                    : Color.gray.opacity(0.1)
                            )
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
