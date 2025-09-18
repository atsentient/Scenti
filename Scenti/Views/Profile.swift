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
        ZStack(alignment: .bottom) {
        List {
            Section(header: Text("Username")) {
                if editMode?.wrappedValue.isEditing == true {
                    TextField("Name", text: $tempName)
                        .onAppear { tempName = profileVM.tempUsername }
                } else {
                    Text(profileVM.user.name ?? "No name")
                }
            }
            
            Section(header: Text("Favorite Notes")) {
                if editMode?.wrappedValue.isEditing == true {
                    ForEach(perfumeNoteTags, id: \.self) { note in
                        HStack {
                            Text(note.capitalized)
                            Spacer()
                            if profileVM.selectedNotes.contains(note) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle()) // чтобы кликалась вся строка
                        .onTapGesture {
                            profileVM.toggleNote(note)
                        }
                    }
                } else {
                    if profileVM.selectedNotes.isEmpty {
                        Text("No favorite notes yet")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(profileVM.selectedNotes, id: \.self) { note in
                            Text("• \(note.capitalized)")
                        }
                    }
                }
            }
        }
            
            if editMode?.wrappedValue.isEditing == true {
                            Button(action: {
                                profileVM.tempUsername = tempName
                                profileVM.saveDetails()
                                editMode?.wrappedValue = .inactive
                            }) {
                                Text("Save")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .padding()
                    }
                }
        }
        .navigationTitle("Profile")
        .toolbar { EditButton() }
        .animation(.default, value: editMode?.wrappedValue)
    }
}

