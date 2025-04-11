//
//  AddPerfumeView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI
import SwiftData

struct AddPerfumeView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = ""
    @State var brand: String = ""
    @State var notes: String = ""

    var body: some View {
        TextField("brand", text: $brand)
        TextField("name", text: $name)
        TextField("notes", text: $notes)
        saveButtonSection
    }
    
    private var saveButtonSection: some View {
        HStack {
            Spacer()
            Button("Save") {
                savePerfume()
            }
            Spacer()
        }
    }
    
    private func savePerfume() {
        let newPerfume = CDPerfume(context: moc)
        newPerfume.id = UUID()
        newPerfume.name = name
        newPerfume.brand = brand
        newPerfume.notes = notes
        newPerfume.createdAt = Date()

        do {
            try moc.save()
            print("Perfume saved!")
        } catch {
            print("Failed to save perfume: \(error.localizedDescription)")
        }

    }
}

#Preview {
    AddPerfumeView()
}
