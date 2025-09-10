//
//  PerfumeListViewModel.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 06.05.2025.
//

import CoreData
import SwiftUI
import Combine

class PerfumeListViewModel: ObservableObject {
    @Published var perfumes: [CDPerfume] = []
    @Published var searchText: String = ""
    @Published var selectedTags: Set<String> = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private var moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        fetchPerfumes()
        setupCoreDataObserver()
    }
    
    let request = CDPerfume.fetchRequest()
    
    private func setupCoreDataObserver() {
            NotificationCenter.default
                .publisher(for: .NSManagedObjectContextDidSave, object: moc)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.fetchPerfumes()
                    print("🟢 Данные Core Data изменились - список обновлён")
                }
                .store(in: &cancellables)
        }
    
    func fetchPerfumes() {
        print("🔵 Запущен fetchPerfumes()")
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
        
        print("🟢 Загружено парфюмов: \(perfumes.count)")
    }
    
    func toggleFavourite(for perfume: CDPerfume) {
        perfume.favourite.toggle()
        
        do {
            try moc.save()
            print("Favourite status saved: \(perfume.favourite)")
            objectWillChange.send()
        } catch {
            print("Error saving favourite: \(error.localizedDescription)")
        }
    }
    
    func removePerfume(at index: Int) {
        guard perfumes.indices.contains(index) else { return }
        moc.delete(perfumes[index])
        saveContext()
        fetchPerfumes()
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
            guard let perfumeTags = perfume.tags else { return false }
            return selectedTags.isSubset(of: Set(perfumeTags))
        }
    }
}
