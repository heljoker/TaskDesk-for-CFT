//
//  PersistanceTasksData.swift
//  testTask
//
//  Created by Павел Замулин on 16.03.2023.
//

import Foundation
import UIKit
import RealmSwift

// MARK: Класс объекта Realm

// Класс объекта базы данных Realm с необходимым набором параметров
class Notes: Object {
    
    // Текст заметки
    @objc dynamic var text: String = ""
    
    // Цвета заметки и текста
    @objc dynamic var noteColour: String = ""
    @objc dynamic var textColour: String = ""
 
}

class PersistanceRealm {

    static let shared = PersistanceRealm()
    private let realm = try! Realm()

// MARK: Типовые функции взаимодействия с Realm
   
    // Функция сохранения данных в базу данных Realm путём полной перезаписи базы данных (можно придумать более эффективный и оптимизированный способ сохранения (?) )
    func saveData(data: [Tasks]) {
        try! realm.write {
            realm.deleteAll()
        }
        for (_,item) in data.enumerated() {
            let note = Notes()
            note.text = item.text
            note.textColour = item.textColour
            note.noteColour = item.noteColour
            try! realm.write {
                realm.add(note)
            }
        }
    }
    
    // Функция подгрузки данных с базы данных Realm
    func loadData(data: inout [Tasks]) {
        let notes = realm.objects(Notes.self)
        for note in notes{
            let task = Tasks(text: note.text, noteColour: note.noteColour, textColour: note.textColour)
            data.append(task)
        }
    }
}
