//
//  DetailsView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 13.04.2025.
//

import SwiftUI

struct DetailsView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.editMode) var editMode

    @State private var selectedNotesTags: Set<String> = []
    
    @StateObject var detailsViewModel: DetailsViewModel

    var body: some View {
        List {
            Section(header: Text("Name")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextField("Name", text: $detailsViewModel.tempName)
                } else {
                    Text(detailsViewModel.perfume.name ?? "No name")
                }
            }

            Section(header: Text("Brand")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextField("Brand", text: $detailsViewModel.tempBrand)
                } else {
                    Text(detailsViewModel.perfume.brand ?? "No brand")
                }
            }

            Section(header: Text("Notes")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextEditor(text: $detailsViewModel.tempNotes)
                        .frame(height: 100)
                } else {
                    Text(detailsViewModel.perfume.notes ?? "No notes")
                }
            }

            Section(header: Text("Tags")) {
                if editMode?.wrappedValue.isEditing == true {
                    TagsEditorView(allTags: perfumeNoteTags, selectedTags: $detailsViewModel.selectedNotesTags)
                } else {
                    if let tags = detailsViewModel.perfume.tags, !tags.isEmpty {
                    TagsDisplayView(tags: tags)
                }
            }
        }

            if editMode?.wrappedValue.isEditing == true {
                Button("Save"){
                    detailsViewModel.saveDetails()
                }
            }
        }
        .navigationTitle("Details")
        .toolbar {
            EditButton()
        }
        .onAppear {
            detailsViewModel.tempName = detailsViewModel.perfume.name ?? ""
            detailsViewModel.tempBrand = detailsViewModel.perfume.brand ?? ""
            detailsViewModel.tempNotes = detailsViewModel.perfume.notes ?? ""
            if let tagArray = detailsViewModel.perfume.tags {
                selectedNotesTags = Set(tagArray)
            } else {
                selectedNotesTags = []
            }
        }
    }
}



struct TagsEditorView: View {
    let allTags: [String]
    @Binding var selectedTags: Set<String>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(allTags, id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(selectedTags.contains(tag) ? Color.blue : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(.white)
                        .onTapGesture {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

struct TagsDisplayView: View {
    let tags: [String]
    let columns = [GridItem(.adaptive(minimum: 80), spacing: 8)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical, 4)
    }
}


