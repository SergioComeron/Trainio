//
//  EjercicioRealizado.swift
//  Trainio
//
//  Created by Sergio Comerón on 7/8/25.
//

import SwiftData

@Model
final class EjercicioRealizado {
    var nombre: String = ""
    var series: [Serie]? = []
    @Relationship(inverse: \Entrenamiento.ejercicios) var entrenamiento: Entrenamiento?

    init(nombre: String, series: [Serie]? = [], entrenamiento: Entrenamiento? = nil) {
        self.nombre = nombre
        self.series = series
        self.entrenamiento = entrenamiento
    }
}
