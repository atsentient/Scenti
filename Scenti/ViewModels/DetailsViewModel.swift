//
//  DetailsViewModel.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 20.05.2025.
//

import CoreData
import SwiftUI

class DetailsViewModel: ObservableObject {
    
    @Published var tempName: String = ""
    @Published var tempBrand: String = ""
    @Published var tempNotes: String = ""
    @Published var selectedNotesTags: Set<String> = [] 
    
    private let moc: NSManagedObjectContext
    
    let perfume: CDPerfume
    
    init(moc: NSManagedObjectContext, perfume: CDPerfume) {
        self.moc = moc
        self.perfume = perfume
        self.tempName = perfume.name ?? ""
        self.tempBrand = perfume.brand ?? ""
        self.tempNotes = perfume.notes ?? ""
        self.selectedNotesTags = Set(perfume.tags ?? [])
    }
    
    func saveDetails() {
        perfume.name = tempName
        perfume.brand = tempBrand
        perfume.notes = tempNotes
        perfume.tags = Array(selectedNotesTags)

        do {
            try moc.save()
        } catch {
            print("Save error: \(error)")
        }
    }

}
