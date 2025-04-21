//
//  AddPerfumeView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPerfumeView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var brand = ""
    @State private var notes = ""

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        TextField("brand", text: $brand)
        TextField("name", text: $name)
        TextField("notes", text: $notes)
        PhotosPicker(selection: $selectedItem,
                     matching: .any(of: [.images, .not(.screenshots)])) {
            Text("Select perfume photo")
        }
        saveButtonSection
    }
    
    private var saveButtonSection: some View {
        HStack {
            Spacer()
            Button("Save") {
                savePerfume()
            }
            Spacer()
        }
    }
    
    private func savePerfume() {
        let newPerfume = CDPerfume(context: moc)
        newPerfume.id = UUID()
        newPerfume.name = name
        newPerfume.brand = brand
        newPerfume.notes = notes
        newPerfume.createdAt = Date()
        print(
            "ID: \(newPerfume.id?.uuidString ?? "nil")",
            "Name: \(newPerfume.name ?? "nil")",
            "Brand: \(newPerfume.brand ?? "nil")",
            "Notes: \(newPerfume.notes ?? "nil")",
            "Created: \(newPerfume.createdAt?.description ?? "nil")"
        )

        do {
            try moc.save()
            dismiss()
        } catch {
            print("Failed to save perfume: \(error.localizedDescription)")
        }

    }
}

#Preview {
    AddPerfumeView()
}
