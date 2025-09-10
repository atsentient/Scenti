//
//  Profile.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 03.06.2025.
//

import SwiftUI

struct Profile: View {
    
    @State private var currentProfile: CDUserProfile?
    @State private var editMode: EditMode = .inactive 
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(
        entity: CDUserProfile.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CDUserProfile.joinDate, ascending: false)]
    ) var profiles: FetchedResults<CDUserProfile>

    
    var body: some View {
        NavigationStack {
            if let profile = currentProfile {
                ProfileContentView(profileVM: ProfileVM(moc: moc, user: profile))
                    .environment(\.editMode, $editMode)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if let existingProfile = profiles.first {
                currentProfile = existingProfile
            } else {
                currentProfile = createDefaultProfile()
            }
        }
    }
    
    private func createDefaultProfile() -> CDUserProfile {
        let newProfile = CDUserProfile(context: moc)
        newProfile.id = UUID()
        newProfile.name = "New user"
        newProfile.joinDate = Date()
        do {
            try moc.save()
        } catch {
            print("Save error creating default profile: \(error)")
        }
        return newProfile
    }
}

struct ProfileContentView: View {
    @ObservedObject var profileVM: ProfileVM
    @Environment(\.editMode) var editMode
    
    @State private var tempName: String = ""
    
    var body: some View {
        List {
            Section(header: Text("Username")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextField("Name", text: $tempName)
                        .onAppear { tempName = profileVM.tempUsername }
                } else {
                    Text(profileVM.user.name ?? "No name")
                }
            }
            
            if editMode?.wrappedValue.isEditing == true {
                Button("Save") {
                    profileVM.tempUsername = tempName
                    profileVM.saveDetails()
                    editMode?.wrappedValue = .inactive
                }
            }
        }
        .navigationTitle("Profile")
        .toolbar { EditButton() }
        .animation(.default, value: editMode?.wrappedValue)
    }
}
