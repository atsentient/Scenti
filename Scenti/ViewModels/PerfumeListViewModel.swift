//
//  PerfumeListViewModel.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 06.05.2025.
//

import CoreData
import SwiftUI

class PerfumeListViewModel: ObservableObject {
    @Published var perfumes: [CDPerfume] = []
    @Published var searchText: String = ""
    @Published var selectedTags: Set<String> = []
    
    private let moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        fetchPerfumes()
    }
    
    func fetchPerfumes() {
        let request = CDPerfume.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDPerfume.createdAt, ascending: false)]
        
        if !searchText.isEmpty {
            request.predicate = NSPredicate(
                format: "name CONTAINS[cd] %@ OR brand CONTAINS[cd] %@ OR notes CONTAINS[cd] %@ OR tags CONTAINS[cd] %@",
                searchText, searchText, searchText, searchText
            )
        }
        
        do {
            perfumes = try moc.fetch(request)
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
    
    func toggleFavourite(for perfume: CDPerfume) {
        perfume.favourite.toggle()
        
        do {
            try moc.save()
            print("Favourite status saved: \(perfume.favourite)") // Отладочный вывод
            objectWillChange.send() // Принудительное обновление
        } catch {
            print("Error saving favourite: \(error.localizedDescription)")
        }
    }
    
    func removePerfume(at index: Int) {
        guard perfumes.indices.contains(index) else { return }
        moc.delete(perfumes[index])
        saveContext()
        fetchPerfumes() // Обновляем список
    }
    
    private func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error occured while saving: \(error)")
        }
    }
}

extension PerfumeListViewModel {
    var filteredPerfumes: [CDPerfume] {
        if selectedTags.isEmpty {
            return perfumes
        }
        
        return perfumes.filter { perfume in
            let perfumeTags = Set(perfume.tags ?? [])
            return selectedTags.isSubset(of: perfumeTags)
        }
    }
}
