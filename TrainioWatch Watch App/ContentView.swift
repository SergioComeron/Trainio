//
//  ContentView.swift
//  TrainioWatch Watch App
//
//  Created by Sergio Comerón on 6/8/25.
//

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var mostrarSeleccionGrupos = false
    @State private var gruposSeleccionados = Set<GrupoMuscular>()
    @State private var mostrarListadoEntrenamientos = false
    @State private var entrenamientoReciente: Entrenamiento? = nil
    
    var body: some View {
        VStack {
            Button("Añadir entrenamiento") {
                mostrarSeleccionGrupos = true
            }
            Button("Ver entrenamientos") {
                mostrarListadoEntrenamientos = true
            }
        }
        .sheet(isPresented: $mostrarSeleccionGrupos) {
            SeleccionarGruposView(seleccionados: $gruposSeleccionados) {
                mostrarSeleccionGrupos = false
                let nuevo = addItem(gruposMusculares: Array(gruposSeleccionados))
                entrenamientoReciente = nuevo
            }
        }
        .sheet(isPresented: $mostrarListadoEntrenamientos) {
            EntrenamientosList() // Placeholder, asumiendo que esta vista existe
        }
        .sheet(item: $entrenamientoReciente) { entrenamiento in
            EntrenamientoView(entrenamiento: entrenamiento)
        }
    }
    
    private func addItem(gruposMusculares: [GrupoMuscular]) -> Entrenamiento {
        let newItem = Entrenamiento(inicio: Date(), gruposMusculares: gruposMusculares)
        modelContext.insert(newItem)
        return newItem
    }
}


#Preview {
    ContentView()
}
