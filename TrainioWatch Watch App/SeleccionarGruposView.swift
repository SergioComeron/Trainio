import SwiftUI

struct SeleccionarGruposView: View {
    @Binding var seleccionados: Set<GrupoMuscular>
    var onGuardar: () -> Void
    
    var body: some View {
        VStack {
            Text("Selecciona los grupos musculares")
                .font(.headline)
            ScrollView {
                let columnas = [GridItem(.adaptive(minimum: 90, maximum: 140), spacing: 14)]
                LazyVGrid(columns: columnas, spacing: 12) {
                    ForEach(GrupoMuscular.allCases, id: \.self) { grupo in
                        Button(action: {
                            if seleccionados.contains(grupo) {
                                seleccionados.remove(grupo)
                            } else {
                                seleccionados.insert(grupo)
                            }
                        }) {
                            Text(grupo.rawValue)
                                .font(.body)
                                .foregroundStyle(seleccionados.contains(grupo) ? .white : .primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(seleccionados.contains(grupo) ? Color.accentColor : Color.gray.opacity(0.2))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
            }
            Button("Guardar") {
                onGuardar()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
    }
}

#Preview("Vista de selección de grupos") {
    struct SeleccionPreview: View {
        @State private var seleccionados: Set<GrupoMuscular> = [.pecho, .espalda]
        var body: some View {
            SeleccionarGruposView(seleccionados: $seleccionados) {
                print("Guardado: \(seleccionados)")
            }
        }
    }
    return SeleccionPreview()
}
