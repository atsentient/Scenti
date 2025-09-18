//
//  ProfileVM.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 18.06.2025.
//

import SwiftUI
import Foundation
import CoreData
import _PhotosUI_SwiftUI

class ProfileVM: ObservableObject {
    
    private let moc: NSManagedObjectContext
    
    let user: CDUserProfile
    
    @Published var tempUsername = ""
    @Published var profilePicture: PhotosPickerItem? = nil
    @Published var selectedProfilePictureData: Data? = nil
    @Published var selectedNotes: [String] = []
    
    init(moc: NSManagedObjectContext, user: CDUserProfile) {
        self.moc = moc
        self.user = user
        self.tempUsername = user.name ?? ""
        self.selectedNotes = user.favoriteNotes as? [String] ?? []
    }
    
    func toggleNote(_ note: String) {
        if selectedNotes.contains(note) {
            selectedNotes.removeAll { $0 == note }
        } else {
            selectedNotes.append(note)
        }
    }
    
    func saveDetails() {
        user.name = tempUsername
        user.favoriteNotes = selectedNotes as NSArray
        
        if let imageData = selectedProfilePictureData {
            user.profilePicture = imageData
        }

        do {
            try moc.save()
            print("✅ Profile saved")
        } catch {
            print("⛔️ Save error: \(error)")
        }
    }
}

   
    
