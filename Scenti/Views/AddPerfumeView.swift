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
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        TextField("brand", text: $brand)
        TextField("name", text: $name)
        TextField("notes", text: $notes)
        Section {
            imagePickerSection
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
    
    @ViewBuilder
    private var imagePickerSection: some View {
        PhotosPicker("Select photo", selection: $selectedPhoto, matching: .images)
            .onChange(of: selectedPhoto) { newItem in
                Task {
                    if let newItem {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            }

        if let imageData = selectedImageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding(.vertical, 8)
        }
    }


    
    
    private func savePerfume() {
        let newPerfume = CDPerfume(context: moc)
        newPerfume.id = UUID()
        newPerfume.name = name
        newPerfume.brand = brand
        newPerfume.notes = notes
        newPerfume.createdAt = Date()
        newPerfume.imageData = selectedImageData
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
