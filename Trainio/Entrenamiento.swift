//
//  Item.swift
//  Trainio
//
//  Created by Sergio Comerón on 6/8/25.
//

import Foundation
import SwiftData

@Model
final class Entrenamiento {
    var inicio: Date
    var fin: Date?
    var grupoMuscular: GrupoMuscular?
    
    init(inicio: Date, fin: Date? = nil, grupoMuscular: GrupoMuscular) {
        self.inicio = inicio
        self.fin = fin
        self.grupoMuscular = grupoMuscular
    }
}

enum GrupoMuscular: String, CaseIterable, Codable {
    case pecho = "Pecho"
    case espalda = "Espalda"
    case femoral = "Femoral"
    case brazo = "Bíceps"
    case triceps = "Tríceps"
    case hombro = "Hombro"
    case cuadriceps = "Cuadriceps"
    case gemelo = "Gemelo"
    case abductor = "Abductor"
    case aductor = "Adductor"
    case gluteo = "Glúteo"
    
    // Agrega más grupos según desees
}
