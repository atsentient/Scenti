//
//  AddPerfumeVM.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 22.05.2025.
//

import Foundation
import CoreData
import _PhotosUI_SwiftUI


class AddPerfumeVM: ObservableObject {
    private let moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    @Published var selectedNotesTags: Set<String> = []
    @Published var selectedPhoto: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    @Published var name = ""
    @Published var brand = ""
    @Published var notes = ""
    
    func savePerfume() {
        let newPerfume = CDPerfume(context: moc)
        newPerfume.id = UUID()
        newPerfume.name = name
        newPerfume.brand = brand
        newPerfume.notes = notes
        newPerfume.createdAt = Date()
        newPerfume.tags = Array(selectedNotesTags) // Используем выбранные теги
        newPerfume.imageData = selectedImageData
        
        do {
            try moc.save()
        } catch {
            print("Failed to save perfume: \(error.localizedDescription)")
        }
    }
}
