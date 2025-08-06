//
//  EntrenamientoView.swift
//  Trainio
//
//  Created by Sergio Comerón on 6/8/25.
//

import SwiftData
import SwiftUI

struct EntrenamientoView: View {
    @Environment(\.modelContext) private var modelContext
    var entrenamiento: Entrenamiento
    @State private var showConfirmationAlert = false
    
    private func finalizarEntrenamiento() {
        entrenamiento.fin = Date()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Grupo muscular: \(entrenamiento.grupoMuscular?.rawValue ?? "No especificado")")
            Text("Entrenamiento iniciado el \(entrenamiento.inicio, format: Date.FormatStyle(date: .numeric, time: .standard))")
            if let fin = entrenamiento.fin {
                Text("Finalizado el \(fin, format: Date.FormatStyle(date: .numeric, time: .standard))")
            } else {
                Button("Finalizar entrenamiento") {
                    showConfirmationAlert = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .alert(
            "¿Seguro que quieres finalizar el entrenamiento?",
            isPresented: $showConfirmationAlert
        ) {
            Button("Finalizar", role: .destructive) {
                finalizarEntrenamiento()
            }
            Button("Cancelar", role: .cancel) {}
        }
    }
}
