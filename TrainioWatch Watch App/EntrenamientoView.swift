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
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Grupos musculares:")
                    .font(.title3)
                    .bold()
                
                if entrenamiento.gruposMusculares.isEmpty {
                    Text("No especificado")
                        .font(.body)
                        .padding(.bottom, 4)
                } else {
                    ForEach(entrenamiento.gruposMusculares, id: \.self) { grupo in
                        Text(grupo.rawValue)
                            .font(.body)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                    }
                }
                
                Text("Entrenamiento iniciado el \(entrenamiento.inicio, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    .font(.body)
                    .padding(.top, 4)
                
                if let fin = entrenamiento.fin {
                    Text("Finalizado el \(fin, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        .font(.body)
                        .padding(.top, 2)
                } else {
                    Button("Finalizar entrenamiento") {
                        showConfirmationAlert = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.top, 8)
                }
            }
            .padding(12)
        }
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
