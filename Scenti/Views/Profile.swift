//
//  Profile.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 03.06.2025.
//

import SwiftUI

struct Profile: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.editMode) var editMode
    @State private var editMode: EditMode = .inactive
    
    @FetchRequest(
        entity: CDUserProfile.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CDUserProfile.joinDate, ascending: false)]
    ) var profiles: FetchedResults<CDUserProfile>
    
    private var currentProfile: CDUserProfile {
            if let existingProfile = profiles.first {
                return existingProfile
            } else {
                return createDefaultProfile()
            }
        }
    
    var body: some View {
        NavigationStack {
            ProfileContentView(
                profileVM: ProfileVM(moc: moc, user: currentProfile)
                    .environment(\.editMode, $editMode)
            )
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

struct ProfileContentView: View {
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
            
            if editMode?.wrappedValue.isEditing == true {
                Button("Save") {
                    profileVM.saveDetails()
                }
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            EditButton()
        }
    }
}

