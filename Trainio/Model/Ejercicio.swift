//
//  Ejercicio.swift
//  Trainio
//
//  Created by Sergio Comerón on 7/8/25.
//

import SwiftData
import Foundation

@Model
final class Ejercicio {
    var id: String = ""
    var nombre: String = ""
    var descripcion: String = ""
    var gruposMusculares: [GrupoMuscular] = []

    init(id: String, nombre: String, descripcion: String, gruposMusculares: [GrupoMuscular]) {
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.gruposMusculares = gruposMusculares
    }
}

extension Ejercicio {
    static let ejerciciosPredefinidos: [(id: String, nombre: String, descripcion: String, gruposMusculares: [GrupoMuscular])] = [
        ("peso_muerto_rumano", "Peso muerto rumano", "Ejercicio enfocado en los femorales y glúteos con menos implicación lumbar", [.femoral]),
        ("curl_femoral_maquina", "Curl femoral en máquina", "Aislamiento de los isquiotibiales mediante flexión de rodilla", [.femoral]),
        ("curl_femoral_tumbado", "Curl femoral tumbado", "Variación del curl femoral para trabajar los isquiotibiales desde otra posición", [.femoral]),
        ("curl_femoral_sentado", "Curl femoral sentado", "Aislamiento del femoral con un ángulo diferente que favorece el estiramiento inicial", [.femoral]),
        ("peso_muerto_con_mancuernas", "Peso muerto con mancuernas", "Versión del peso muerto rumano con mancuernas para más control y rango", [.femoral]),
        ("hip_thrust", "Hip Thrust", "Principalmente glúteos, pero también trabajan los femorales en la extensión de cadera", [.femoral, .gluteo]),
        ("patada_atras", "Patada atrás", "Ejercicio para glúteos que simula una extensión de cadera. Se realiza en máquina, polea o con banda elástica. Desde una posición inclinada o a cuatro apoyos, se extiende la pierna hacia atrás manteniendo el torso estable y contrayendo el glúteo al final del movimiento.", [.gluteo, .femoral]),
        ("aductor_maquina", "Aductor en máquina", "Ejercicio para trabajar la parte interna de los muslos (aductores). Sentado en la máquina con las piernas separadas, se cierran las piernas contra la resistencia hasta que se juntan, haciendo fuerza con la parte interna de los muslos.", [.aductor]),
        ("abductor_maquina", "Abductor en máquina", "Ejercicio para trabajar la parte externa de las caderas y los glúteos medios. Sentado en la máquina con las piernas juntas, se abren las piernas contra la resistencia hacia fuera, manteniendo el tronco estable y apretando los glúteos.", [.abductor, .gluteo])
    ]

    static func poblarSiNecesario(context: ModelContext) {
        let fetch = FetchDescriptor<Ejercicio>()
        let existentes = (try? context.fetch(fetch)) ?? []
        if existentes.isEmpty {
            for base in ejerciciosPredefinidos {
                let ejercicio = Ejercicio(id: base.id, nombre: base.nombre, descripcion: base.descripcion, gruposMusculares: base.gruposMusculares)
                context.insert(ejercicio)
            }
            try? context.save()
        }
    }
}

