//
//  ContentView.swift
//  Trainio
//
//  Created by Sergio Comerón on 6/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entrenamientos: [Entrenamiento]
    
    @State private var showAddSheet = false
    @State private var selectedGruposMusculares: Set<GrupoMuscular> = []
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(entrenamientos) { entrenamiento in
                    NavigationLink {
                        EntrenamientoView(entrenamiento: entrenamiento)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(entrenamiento.inicio, format: Date.FormatStyle(date: .numeric, time: .standard))
                                    .font(.headline)
                                Spacer()
                                if entrenamiento.fin != nil {
                                    Label("Finalizado", systemImage: "checkmark.seal.fill")
                                        .foregroundStyle(.green)
                                        .font(.caption)
                                } else {
                                    Label("En progreso", systemImage: "hourglass")
                                        .foregroundStyle(.orange)
                                        .font(.caption)
                                }
                            }
                            if entrenamiento.gruposMusculares.isEmpty {
                                Text("Grupos: No especificado")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Grupos: " + entrenamiento.gruposMusculares.map { $0.rawValue }.joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: { showAddSheet = true }) {
                        Label("Add Entrenamiento", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an entrenamiento")
        }
        .sheet(isPresented: $showAddSheet) {
            let isPad = horizontalSizeClass == .regular
            Group {
                if isPad {
                    ScrollView {
                        sheetContent
                    }
                } else {
                    sheetContent
                }
            }
#if os(iOS)
            .presentationDetents(isPad ? [.large] : [.medium])
#else
            .frame(minHeight: 400) // 👈 Añade esto para macOS
#endif
        }
    }

    private var sheetContent: some View {
        GeometryReader { geometry in
            let sidePadding: CGFloat = 16
            let buttonWidth = (geometry.size.width - (2 * sidePadding) - 12) / 2
            let columns = [
                GridItem(.fixed(buttonWidth), spacing: 12),
                GridItem(.fixed(buttonWidth))
            ]
            VStack {
                Text("Selecciona el grupo muscular")
                    .font(.headline)
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
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(width: buttonWidth, alignment: .center)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(selectedGruposMusculares.contains(grupo) ? Color.accentColor : Color.gray.opacity(0.2))
                                        .shadow(color: selectedGruposMusculares.contains(grupo) ? Color.accentColor.opacity(0.25) : .clear, radius: 4, x: 0, y: 2)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, sidePadding)
                HStack {
                    Button("Añadir") {
                        addItem(gruposMusculares: Array(selectedGruposMusculares))
                        showAddSheet = false
                        selectedGruposMusculares = []
                    }
                    .padding()
                    Button("Cancelar") {
                        showAddSheet = false
                        selectedGruposMusculares = []
                    }
                }
            }
            .padding(.vertical)
            .onAppear {
                Ejercicio.poblarSiNecesario(context: modelContext)
            }
        }
    }

    private func addItem(gruposMusculares: [GrupoMuscular]) {
        withAnimation {
            let newItem = Entrenamiento(inicio: Date(), gruposMusculares: gruposMusculares)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(entrenamientos[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Entrenamiento.self, inMemory: true)
}
