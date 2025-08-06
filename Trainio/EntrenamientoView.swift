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
    @State private var showAddGrupoSheet = false
    @State private var selectedGruposMusculares: Set<GrupoMuscular> = []
    
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
                                .lineLimit(1)
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
            
            if entrenamiento.fin == nil {
                Button {
                    selectedGruposMusculares = Set(entrenamiento.gruposMusculares)
                    showAddGrupoSheet = true
                } label: {
                    Label("Añadir grupo muscular", systemImage: "plus")
                }
                .buttonStyle(.bordered)
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
        .sheet(isPresented: $showAddGrupoSheet) {
            VStack {
                Text("Selecciona los grupos musculares")
                    .font(.headline)
                let columns = [GridItem(.adaptive(minimum: 90, maximum: 140), spacing: 14)]
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(GrupoMuscular.allCases, id: \.self) { grupo in
                        Button(action: {
                            if selectedGruposMusculares.contains(grupo) {
                                selectedGruposMusculares.remove(grupo)
                            } else {
                                selectedGruposMusculares.insert(grupo)
                            }
                        }) {
                            Text(grupo.rawValue)
                                .font(.body)
                                .foregroundStyle(selectedGruposMusculares.contains(grupo) ? .white : .primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(selectedGruposMusculares.contains(grupo) ? Color.accentColor : Color(.systemGray5))
                                        .shadow(color: selectedGruposMusculares.contains(grupo) ? Color.accentColor.opacity(0.18) : .clear, radius: 3, x: 0, y: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                HStack {
                    Button("Guardar") {
                        entrenamiento.gruposMusculares = Array(selectedGruposMusculares)
                        showAddGrupoSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Cancelar") {
                        showAddGrupoSheet = false
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .onAppear {
                selectedGruposMusculares = Set(entrenamiento.gruposMusculares)
                print("Set de seleccionados en sheet:", selectedGruposMusculares)
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview("iPhone ejemplo") {
    let entrenamientoPreview = Entrenamiento(
        inicio: Date().addingTimeInterval(-3600),
        fin: nil,
        gruposMusculares: [.pecho, .espalda, .brazo]
    )
    return EntrenamientoView(entrenamiento: entrenamientoPreview)
        .modelContainer(for: Entrenamiento.self, inMemory: true)
}
