//
//  Perfume.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 13.04.2025.
//

import Foundation

struct Perfume: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var brand: String
    var notes: String
    var createdAt: Date
}
