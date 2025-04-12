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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(perfume.name ?? "Unnamed")
            Text(perfume.brand ?? "No Brand")
            Text(perfume.notes ?? "No notes")
        }
    }
}


