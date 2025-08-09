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
        NavigationView {
            VStack {
                if !selectedTags.isEmpty {
                    Button("Clear All") {
                        selectedTags.removeAll()
                    }
                    .foregroundColor(.red)
                    .padding(.top)
                }
                List {
                    ForEach(perfumeNoteTags, id: \.self) { tag in
                        Text(tag)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedTags.contains(tag) ? Color.blue : Color.gray.opacity(0.3))
                            .cornerRadius(20)
                            .onTapGesture { toggleTag(tag) }
                    }
                  }
                }
                .navigationTitle("Filter Perfumes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
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
