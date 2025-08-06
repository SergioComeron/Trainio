import SwiftUI
import SwiftData

struct ListadoEntrenamientosView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entrenamientos: [Entrenamiento]
    
    var body: some View {
        List(entrenamientos.sorted { $0.inicio > $1.inicio }, id: \.id) { entrenamiento in
            Text("Entrenamiento: \(entrenamiento.inicio.formatted(date: .abbreviated, time: .shortened)) (\(entrenamiento.gruposMusculares.count) grupos)")
        }
    }
}

#Preview {
    ListadoEntrenamientosView()
}
