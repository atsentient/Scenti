//
//  CDPerfume+Extension.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import Foundation

extension CDPerfume {
    func toModel() -> Perfume {
        Perfume(
            id: UUID(),
            name: self.name ?? "Unnamed",
            brand: self.brand ?? "No Brand",
            notes: self.notes ?? "No notes",
            createdAt: self.createdAt ?? Date(),
            favourite: self.favourite,
            imageData: self.imageData,
            tags: (self.tags ?? [] as NSObject as! Array<String>)
        )
    }
}
