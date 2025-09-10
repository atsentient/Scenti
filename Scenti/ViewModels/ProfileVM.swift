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
    
    init(moc: NSManagedObjectContext, user: CDUserProfile) {
        self.moc = moc
        self.user = user
        self.tempUsername = user.name ?? ""
    }
    
    func saveDetails() {
        user.name = tempUsername
        
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
   
    
