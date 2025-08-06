import SwiftUI
import SwiftData

struct EntrenamientosList: View {
    @Query private var entrenamientos: [Entrenamiento]
    
    var body: some View {
        NavigationStack {
            List(entrenamientos) { entrenamiento in
                NavigationLink(destination: EntrenamientoView(entrenamiento: entrenamiento)) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(entrenamiento.inicio, format: Date.FormatStyle(date: .numeric, time: .shortened))
                                .font(.headline)
                            Spacer()
                            if entrenamiento.fin != nil {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(.green)
                                    .font(.caption)
                            } else {
                                Image(systemName: "hourglass")
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
                    .padding(.vertical, 2)
                }
            }
        }
    }
}

#Preview {
    EntrenamientosList()
        .modelContainer(for: Entrenamiento.self, inMemory: true)
}
