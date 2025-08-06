//
//  ContentView.swift
//  TrainioWatch Watch App
//
//  Created by Sergio Comerón on 6/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var entrenamientos: [Entrenamiento]
//    
//    @State private var showAddSheet = false
//    @State private var selectedGrupoMuscular: GrupoMuscular = GrupoMuscular.allCases.first!
//    
//    private func deleteItems(at offsets: IndexSet) {
//        for index in offsets {
//            let item = entrenamientos[index]
//            modelContext.delete(item)
//        }
//    }
//    
//    private func addItem(grupoMuscular: GrupoMuscular) {
//        let nuevo = Entrenamiento(inicio: Date(), grupoMuscular: grupoMuscular)
//        modelContext.insert(nuevo)
//    }
    
    var body: some View {
//        NavigationStack {
//            Button(action: { showAddSheet = true }) {
//                Label("Nuevo Entrenamiento", systemImage: "plus")
//                    .font(.title2)
//                    .padding(8)
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .padding(.bottom, 6)
//            List {
//                ForEach(entrenamientos) { entrenamiento in
//                    NavigationLink(destination: EntrenamientoView(entrenamiento: entrenamiento)) {
//                        Text(entrenamiento.inicio, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//        }
//        .sheet(isPresented: $showAddSheet) {
//            VStack {
//                Text("Selecciona el grupo muscular")
//                    .font(.headline)
//                ForEach(GrupoMuscular.allCases, id: \.self) { grupo in
//                    Button(action: {
//                        addItem(grupoMuscular: grupo)
//                        showAddSheet = false
//                    }) {
//                        Text(grupo.rawValue)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.accentColor.opacity(0.2))
//                            .cornerRadius(8)
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .padding(.vertical, 2)
//                }
//                Button("Cancelar") {
//                    showAddSheet = false
//                }
//                .padding(.top, 8)
//            }
//            .padding()
//            .presentationDetents([.medium])
//        }
        Text("Hola")
    }
}


#Preview {
    ContentView()
}
