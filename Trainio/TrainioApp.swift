//
//  TrainioApp.swift
//  Trainio
//
//  Created by Sergio Comerón on 6/8/25.
//

import SwiftUI
import SwiftData

@main
struct TrainioApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Entrenamiento.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
