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
    @Query(sort: \Ejercicio.nombre) var ejerciciosDisponibles: [Ejercicio]
    var entrenamiento: Entrenamiento
    @State private var showConfirmationAlert = false
    
    @State private var showAddSerieSheet = false
    @State private var selectedEjercicio: Ejercicio? = nil
    @State private var repeticiones: Int = 10
    @State private var peso: Double = 20
    
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
                
                // Ejercicios realizados
                Text("Ejercicios:")
                    .font(.headline)
                if let ejercicios = entrenamiento.ejercicios, !ejercicios.isEmpty {
                    ForEach(ejercicios, id: \.nombre) { ejercicio in
                        Text("\(ejercicio.nombre) (\(ejercicio.series?.count ?? 0) series)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("Sin ejercicios registrados")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Botón para añadir serie
                Button("Añadir serie") {
                    showAddSerieSheet = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.vertical, 4)
                
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
        .onAppear {
            print("Ejercicios disponibles:")
            for ejercicio in ejerciciosDisponibles {
                print("- \(ejercicio.nombre)")
            }
            print("Total: \(ejerciciosDisponibles.count)")
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
        .sheet(isPresented: $showAddSerieSheet) {
            Form {
                Section(header: Text("Ejercicio")) {
                    Picker("Selecciona un ejercicio", selection: $selectedEjercicio) {
                        ForEach(ejerciciosDisponibles, id: \.self) { ejercicio in
                            Text(ejercicio.nombre).tag(Optional(ejercicio))
                        }
                    }
                }
                Section(header: Text("Repeticiones")) {
                    Picker("Repeticiones", selection: $repeticiones) {
                        ForEach(Array(1..<30), id: \.self) { Text("\($0)") }
                    }
                    .pickerStyle(.wheel)
                }
                Section(header: Text("Peso")) {
                    Picker("Peso", selection: $peso) {
                        ForEach(Array(stride(from: 0.0, through: 200.0, by: 0.5)), id: \.self) { valor in
                            Text("\(String(format: "%.1f", valor)) kg")
                        }
                    }
                    .pickerStyle(.wheel)
                }
                Section {
                    Button("Guardar serie") {
                        guard let ejercicio = selectedEjercicio else { return }
                        let ejercicioRealizado = EjercicioRealizado(nombre: ejercicio.nombre, entrenamiento: entrenamiento)
                        let nuevaSerie = Serie(repeticiones: repeticiones, peso: peso, ejercicioRealizado: ejercicioRealizado)
                        if ejercicioRealizado.series == nil {
                            ejercicioRealizado.series = [nuevaSerie]
                        } else {
                            ejercicioRealizado.series?.append(nuevaSerie)
                        }
                        if entrenamiento.ejercicios == nil {
                            entrenamiento.ejercicios = [ejercicioRealizado]
                        } else {
                            entrenamiento.ejercicios?.append(ejercicioRealizado)
                        }
                        showAddSerieSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedEjercicio == nil)
                    Button("Cancelar") {
                        showAddSerieSheet = false
                    }
                }
            }
            .presentationDetents([.fraction(0.75), .large])
        }
    }
}

