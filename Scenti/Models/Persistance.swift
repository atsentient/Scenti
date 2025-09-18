//
//  Persistance.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Scenti") // имя .xcdatamodeld
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        container.persistentStoreDescriptions.first?.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions.first?.shouldInferMappingModelAutomatically = true
    }
}
