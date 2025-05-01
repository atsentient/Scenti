//
//  FilterView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 01.05.2025.
//

import SwiftUI

struct FilterView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTags: Set<String>
    
    var body: some View {
        List {
            ForEach(perfumeNoteTags, id: \.self) { tag in
                Text(tag)
                    .background(selectedTags.contains(tag) ? Color.purple.opacity(0.8) : Color.gray.opacity(0.2))
                    .foregroundColor(selectedTags.contains(tag) ? .white : .black)
                    .onTapGesture {
                        toggleTag(tag)
                    }
            }
            .padding()
        }
        
        Button(selectedTags.isEmpty ? "Close" : "Search") {
                        dismiss()
                    }
                
    }
    
    private func toggleTag(_ tag: String) {
            if selectedTags.contains(tag) {
                selectedTags.remove(tag)
            } else {
                selectedTags.insert(tag)
            }
        }
}
