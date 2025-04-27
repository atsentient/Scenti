//
//  DetailsView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 13.04.2025.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var perfume: CDPerfume
    @Environment(\.editMode) var editMode

    @State private var tempName: String = ""
    @State private var tempBrand: String = ""
    @State private var tempNotes: String = ""

    let perfumeNoteTags: [String] = [
        "floral", "fruity", "gourmand", "woody", "musky",
        "citrus", "aquatic", "oriental", "powdery", "green",
        "leathery", "tobacco", "sweet", "fresh", "smoky", "aldehydic",
        "spring", "summer", "autumn", "winter",
        "daytime", "evening", "night",
        "feminine", "masculine", "unisex",
        "romantic", "playful", "cozy", "mysterious", "bold",
        "elegant", "minimalistic", "everyday", "festive", "vintage", "niche",
        "long-lasting", "weak longevity", "strong sillage", "intimate sillage",
        "work", "date", "party", "home", "relaxing", "office", "gym", "travel"
    ]

    @State private var selectedNotesTags: Set<String> = []

    var body: some View {
        List {
            Section(header: Text("Name")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextField("Name", text: $tempName)
                } else {
                    Text(perfume.name ?? "No name")
                }
            }

            Section(header: Text("Brand")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextField("Brand", text: $tempBrand)
                } else {
                    Text(perfume.brand ?? "No brand")
                }
            }

            Section(header: Text("Notes")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextEditor(text: $tempNotes)
                        .frame(height: 100)
                } else {
                    Text(perfume.notes ?? "No notes")
                }
            }

            Section(header: Text("Tags")) {
                if editMode?.wrappedValue.isEditing == true {
                    TagsEditorView(allTags: perfumeNoteTags, selectedTags: $selectedNotesTags)
                } else {
                    if let tags = perfume.tags, !tags.isEmpty {
                    TagsDisplayView(tags: tags)
                }
            }
        }

            if editMode?.wrappedValue.isEditing == true {
                Button("Save") {
                    perfume.name = tempName
                    perfume.brand = tempBrand
                    perfume.notes = tempNotes
                    perfume.tags = Array(selectedNotesTags)

                    do {
                        try moc.save()
                        withAnimation {
                            editMode?.wrappedValue = .inactive
                        }
                    } catch {
                        print("Save error: \(error)")
                    }
                }
            }
        }
        .navigationTitle("Details")
        .toolbar {
            EditButton()
        }
        .onAppear {
            tempName = perfume.name ?? ""
            tempBrand = perfume.brand ?? ""
            tempNotes = perfume.notes ?? ""
            if let tagArray = perfume.tags {
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


