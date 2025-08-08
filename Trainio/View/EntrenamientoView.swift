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
    
    @State private var showAddEjercicioSheet = false
    @State private var selectedEjercicio: Ejercicio? = nil
    @State private var nuevaSerieReps: String = ""
    @State private var nuevaSeriePeso: String = ""
    @State private var seriesTemp: [Serie] = []
    @Query private var ejerciciosBase: [Ejercicio]
    
    
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
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ejercicios realizados:")
                        .font(.headline)
                    if (entrenamiento.ejercicios ?? []).isEmpty {
                        Text("Ningún ejercicio añadido")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(entrenamiento.ejercicios ?? []) { ejercicio in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ejercicio.nombre)
                                    .font(.subheadline).bold()
                                ForEach(ejercicio.series ?? []) { serie in
                                    Text("Serie: \(serie.repeticiones) reps x \(serie.peso, specifier: "%.1f") kg")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }.padding(.vertical, 4)
                        }
                    }
                    Button {
                        showAddEjercicioSheet = true
                    } label: {
                        Label("Añadir ejercicio", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
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
        .sheet(isPresented: $showAddEjercicioSheet) {
            NavigationView {
                Form {
                    Picker("Ejercicio", selection: $selectedEjercicio) {
                        ForEach(ejerciciosBase) { ejer in
                            Text(ejer.nombre).tag(Optional(ejer))
                        }
                    }
                    .onChange(of: selectedEjercicio) { oldValue, newValue in
                        if let ejercicioSel = newValue {
                            // Busca ejercicio realizado existente
                            if let ejerciciosActuales = entrenamiento.ejercicios,
                               let encontrado = ejerciciosActuales.first(where: { $0.nombre == ejercicioSel.nombre }) {
                                seriesTemp = encontrado.series ?? []
                            } else {
                                seriesTemp = []
                            }
                            // Reset nuevos campos
                            nuevaSerieReps = ""
                            nuevaSeriePeso = ""
                        } else {
                            seriesTemp = []
                            nuevaSerieReps = ""
                            nuevaSeriePeso = ""
                        }
                    }
                    
                    if let ejercicioSel = selectedEjercicio {
                        Section("Grupo muscular") {
                            Text(ejercicioSel.gruposMusculares.map { $0.rawValue }.joined(separator: ", "))
                        }
                        Section("Series") {
                            TextField("Repeticiones", text: $nuevaSerieReps)
                                .keyboardType(.numberPad)
                            TextField("Peso (kg)", text: $nuevaSeriePeso)
                                .keyboardType(.decimalPad)
                            Button("Añadir serie") {
                                if let reps = Int(nuevaSerieReps), let peso = Double(nuevaSeriePeso), reps > 0, peso >= 0 {
                                    let nuevaSerie = Serie(repeticiones: reps, peso: peso)
                                    seriesTemp.append(nuevaSerie)
                                    nuevaSerieReps = ""
                                    nuevaSeriePeso = ""
                                }
                            }
                        }
                        Section("Series añadidas") {
                            if seriesTemp.isEmpty {
                                Text("Ninguna serie añadida")
                                    .foregroundStyle(.secondary)
                            } else {
                                ForEach(Array(seriesTemp.enumerated()), id: \.element.id) { index, serie in
                                    HStack {
                                        Text("Serie: \(serie.repeticiones) reps x \(serie.peso, specifier: "%.1f") kg")
                                        Spacer()
                                        Button(role: .destructive) {
                                            seriesTemp.remove(at: index)
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Section {
                        Button("Guardar ejercicio") {
                            guard let ejercicioSel = selectedEjercicio, !seriesTemp.isEmpty else { return }
                            var ejerciciosActuales = entrenamiento.ejercicios ?? []
                            if let idx = ejerciciosActuales.firstIndex(where: { $0.nombre == ejercicioSel.nombre }) {
                                ejerciciosActuales[idx].series = seriesTemp
                            } else {
                                let nuevoEjercicio = EjercicioRealizado(nombre: ejercicioSel.nombre, series: seriesTemp)
                                ejerciciosActuales.append(nuevoEjercicio)
                            }
                            entrenamiento.ejercicios = ejerciciosActuales
                            // Reset estados
                            nuevaSerieReps = ""
                            nuevaSeriePeso = ""
                            seriesTemp = []
                            selectedEjercicio = nil
                            showAddEjercicioSheet = false
                        }
                        .disabled(selectedEjercicio == nil || seriesTemp.isEmpty)
                    }
                }
                .navigationTitle("Añadir ejercicio")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cerrar") {
                            // Reset estados al cerrar
                            nuevaSerieReps = ""
                            nuevaSeriePeso = ""
                            seriesTemp = []
                            selectedEjercicio = nil
                            showAddEjercicioSheet = false
                        }
                    }
                }
            }
        }
    }
}
