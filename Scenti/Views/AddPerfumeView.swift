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
    @StateObject var addPerfumeVM: AddPerfumeVM
    var onSave: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Section("Perfume Details") {
                    TextField("Brand", text: $addPerfumeVM.brand)
                    TextField("Name", text: $addPerfumeVM.name)
                    TextField("Notes", text: $addPerfumeVM.notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Photo") {
                    imagePickerSection
                }
                
                Section {
                    Button("Save") {
                        addPerfumeVM.savePerfume()
                        onSave?()
                        dismiss()
                    }
                    .disabled(addPerfumeVM.brand.isEmpty || addPerfumeVM.name.isEmpty)
                    .frame(maxWidth: .infinity)
                    
                }
                
            }
            .navigationTitle("Add Perfume")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            
        }
    }

    
    @ViewBuilder
    private var imagePickerSection: some View {
        PhotosPicker("Select photo", selection: $addPerfumeVM.selectedPhoto, matching: .images)
            .onChange(of: addPerfumeVM.selectedPhoto) { newItem in
                Task {
                    if let newItem {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            addPerfumeVM.selectedImageData = data
                        }
                    }
                }
            }

        if let imageData = addPerfumeVM.selectedImageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding(.vertical, 8)
        }
    }
}

