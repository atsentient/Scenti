//
//  Models.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import Foundation

struct Perfume: Identifiable {
    let id = UUID()
    let name: String
    let brand: String
    let notes: String
    let createdAt: Date
}
