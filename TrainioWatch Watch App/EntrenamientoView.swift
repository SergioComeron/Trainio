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
            VStack(alignment: .leading, spacing: 6) {
                Text("Grupos musculares:")
                    .font(.headline)
                if entrenamiento.gruposMusculares.isEmpty {
                    Text("No especificado")
                        .foregroundStyle(.secondary)
                } else {
                    let columns = [GridItem(.adaptive(minimum: 80, maximum: 120), spacing: 10)]
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                        ForEach(entrenamiento.gruposMusculares, id: \.self) { grupo in
                            Text(grupo.rawValue)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(Color.accentColor)
                                        .shadow(color: Color.accentColor.opacity(0.18), radius: 2, x: 0, y: 1)
                                )
                        }
                    }
                }
            }
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
