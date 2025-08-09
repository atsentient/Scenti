//
//  ScentiApp.swift
//  Scenti
//
//  Created by Sasha Obraztsova on 11.04.2025.
//

import SwiftUI

@main
struct ScentiApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            SwiftUI.TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "bottles.fill")
                        Text("Collection")
                    }
                
                Profile()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
