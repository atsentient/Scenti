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
    
    init(moc: NSManagedObjectContext) {
            self.moc = moc
    }
    
    @Published var tempUsername = ""
    @Published var myFaveTempNotes = []
    @Published var profilePicture: PhotosPickerItem? = nil
    @Published var selectedProfilePictureData: Data? = nil
    @Published var faveNotes = ""
    
    let user: CDUserProfile
    
    init(moc: NSManagedObjectContext, user: CDUserProfile) {
        self.moc = moc
        self.user = user
        self.tempUsername = user.name ?? ""
        self.myFaveTempNotes = Set(user.preferences ?? [])
    }
    
    func saveDetails() {
        user.name = tempUsername
        user.preferences = myFaveTempNotes as NSObject
        user.profilePicture = selectedProfilePictureData

        do {
            try moc.save()
        } catch {
            print("Save error: \(error)")
        }
    }

    
}
    
