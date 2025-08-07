//
//  Serie.swift
//  Trainio
//
//  Created by Sergio Comerón on 7/8/25.
//

import SwiftData

@Model
final class Serie {
    var repeticiones: Int = 0
    var peso: Double = 0.0
    @Relationship(inverse: \EjercicioRealizado.series) var ejercicioRealizado: EjercicioRealizado?

    init(repeticiones: Int, peso: Double, ejercicioRealizado: EjercicioRealizado? = nil) {
        self.repeticiones = repeticiones
        self.peso = peso
        self.ejercicioRealizado = ejercicioRealizado
    }
}
