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
                format: "name CONTAINS[cd] %@ OR brand CONTAINS[cd] %@ OR notes CONTAINS[cd] %@ OR tags CONTAINS[cd] %@",
                searchText, searchText, searchText, searchText
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
                    HStack{
                        VStack(alignment: .leading, spacing: 4) {
                            Text(perfume.brand ?? "No Brand")
                                .foregroundStyle(.black)
                            Text(perfume.name ?? "Unnamed")
                            Text(perfume.notes ?? "No notes")
                                .foregroundStyle(.brown)
                            TagsView(tags: perfume.tags ?? [])
                            Button {
                                        perfume.favourite.toggle()
                                        try? moc.save()
                                    } label: {
                                        Image(systemName: perfume.favourite ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                    }
                                    .buttonStyle(.plain)
                        }
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
                    
                }.onDelete(perform: removePerfume)
                
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
