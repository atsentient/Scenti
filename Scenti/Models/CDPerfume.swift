//
//  Models.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import Foundation

struct Perfume: Identifiable, Codable {
    var id = UUID()
    var name: String
    var brand: String
    var notes: String
    var createdAt: Date
}
