//
//  TaskDeskModel.swift
//  testTask
//
//  Created by Павел Замулин on 15.03.2023.
//

import Foundation
import UIKit

// MARK: Структура базы данных

struct Tasks: Equatable {
    
    // Текст заметки
    var text: String
    // Цвет заметки
    var noteColour: String
    // Цвет текста
    var textColour: String
}

// MARK: Необходимые функциональные переменные

// Переменная-индикатор количества ячеек в одной строке (трансформирование коллекции из вида таблицы в вид коллекции и обратно)
var cellsInLine: CGFloat = 1

// Переменная-массив с базой данных, на основе которой строится коллекция
var tasksData: [Tasks] = []

// MARK: Типовые функции

// Типовая функция добавления заметки
func addNote(database: inout [Tasks], note: Tasks) {
    database.append(note)
}

//Типовая функция изменения заметки
func changeNote(database: inout [Tasks], at index: Int, note: Tasks){
    database[index] = note
}

//Типовая функция удаления заметки
func deleteNote(database: inout [Tasks], at index: Int){
    database.remove(at: index)
    
}
