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

    var body: some View {
        Form {
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
                    TextField("Notes", text: $tempNotes)
                } else {
                    Text(perfume.notes ?? "No notes")
                }
            }

            if editMode?.wrappedValue.isEditing == true {
                Button("Save") {
                    perfume.name = tempName
                    perfume.brand = tempBrand
                    perfume.notes = tempNotes
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
        }
    }
}

