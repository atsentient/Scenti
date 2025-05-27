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
        TextField("brand", text: $addPerfumeVM.brand)
        TextField("name", text: $addPerfumeVM.name)
        TextField("notes", text: $addPerfumeVM.notes)
        Section {
            imagePickerSection
        }
        saveButtonSection
    }
    
    private var saveButtonSection: some View {
        HStack {
            Spacer()
            Button("Save") {
                addPerfumeVM.savePerfume()
                onSave?()
                dismiss()
            }
            Spacer()
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

