//
//  DetailsView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 13.04.2025.
//

import SwiftUI

struct DetailsView: View {
    
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var perfume: CDPerfume
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 4) {
                Section(header: Text("Name")) {
                    if editMode?.wrappedValue.isEditing == true {
                        TextField("Name", text: Binding(
                            get: { perfume.name ?? "" },
                            set: { perfume.name = $0 }
                        ))
                    } else {
                        Text(perfume.name ?? "No name")
                    }
                }
                Section(header: Text("Brand")) {
                    if editMode?.wrappedValue.isEditing == true {
                        TextField("Brand", text: Binding(
                            get: { perfume.brand ?? "" },
                            set: { perfume.brand = $0 }
                        ))
                    } else {
                        Text(perfume.brand ?? "No brand")
                    }
                }
                Section(header: Text("Notes")) {
                    if editMode?.wrappedValue.isEditing == true {
                        TextField("Notes", text: Binding(
                            get: { perfume.notes ?? "" },
                            set: { perfume.notes = $0 }
                        ))
                    } else {
                        Text(perfume.notes ?? "No notes")
                    }
                }
            }
            if editMode?.wrappedValue.isEditing == true {
                Button("Save") {
                    do {
                        try moc.save()
                    } catch {
                        print("Save error: \(error)")
                    }
                }
            }
            
        }
        .navigationTitle("Details")
        .toolbar {
            EditButton()
        }
        
    }
        
}


