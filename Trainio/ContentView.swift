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
    @State private var selectedGrupoMuscular: GrupoMuscular = GrupoMuscular.allCases.first!

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(entrenamientos) { entrenamiento in
                    NavigationLink {
                        EntrenamientoView(entrenamiento: entrenamiento)
                    } label: {
                        Text(entrenamiento.inicio, format: Date.FormatStyle(date: .numeric, time: .standard))
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
            VStack {
                Text("Selecciona el grupo muscular")
                    .font(.headline)
                Picker("Grupo Muscular", selection: $selectedGrupoMuscular) {
                    ForEach(GrupoMuscular.allCases, id: \.self) { grupo in
                        Text(grupo.rawValue).tag(grupo)
                    }
                }
                .pickerStyle(.wheel)
                Button("Añadir") {
                    addItem(grupoMuscular: selectedGrupoMuscular)
                    showAddSheet = false
                }
                .padding()
                Button("Cancelar") {
                    showAddSheet = false
                }
            }
            .padding()
            .presentationDetents([.medium])
        }
    }

    private func addItem(grupoMuscular: GrupoMuscular) {
        withAnimation {
            let newItem = Entrenamiento(inicio: Date(), grupoMuscular: grupoMuscular)
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
