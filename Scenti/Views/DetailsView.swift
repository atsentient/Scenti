//
//  DetailsView.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 13.04.2025.
//

import SwiftUI

struct DetailsView: View {
    
    @Environment(\.managedObjectContext) var moc
    var perfume: Perfume
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(perfume.name )
            Text(perfume.brand )
            Text(perfume.notes )
        }
    }
}


