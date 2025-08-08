//
//  Profile.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 03.06.2025.
//

import SwiftUI

struct Profile: View {
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(
        entity: CDUserProfile.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CDUserProfile.joinDate, ascending: false)]
    ) var profiles: FetchedResults<CDUserProfile>
    
    private var currentProfile: CDUserProfile? {
        profiles.first ?? createDefaultProfile()
    }
    
    @StateObject var profileVM: ProfileVM
    @Environment(\.editMode) var editMode
    
    var body: some View {
        List {
            Section(header: Text("Username")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextField("Name", text: $profileVM.tempUsername)
                } else {
                    Text(profileVM.user.name ?? "No name")
                }
            }
        }
    }
    
    private func createDefaultProfile() -> CDUserProfile {
        let newProfile = CDUserProfile(context: moc)
        newProfile.id = UUID()
        newProfile.name = "New user"
        newProfile.joinDate = Date()
        try? moc.save()
        return newProfile
    }
    
}

