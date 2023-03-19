//
//  EditorViewController.swift
//  testTask
//
//  Created by Павел Замулин on 14.03.2023.
//

import UIKit

// MARK: Протокол делегата для обновление коллекции по нажатию кнопок с этого окна

protocol TaskDeskDelegate {
    func updateDesk()
}

class EditorViewController: UIViewController {
    
// MARK: Переменные, необходимые для взаимодействия между экранами
    
    // Текст заметки
    var textOfTextField = ""
    
    // Индекс редактируемой заметки
    var indexOfEditingItem = 0
    
    // Цвет заметки
    var noteColour = ""
   
    // Цвет текста
    var textColour = ""
    
    // Маркер редактирования
    var changingMarker = true
    
    // Делегат
    var delegate: TaskDeskDelegate?

// MARK: Действия перед загрузкой окна

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Дублирование параметров ячейки в случае, если был вызван режим редактирования, и сокрытие кнопки "Удаление" в случае, если была нажата кнопка "Добавления новой ячейки"
        if changingMarker {
            taskTextField.text = textOfTextField
        } else {
            removeButton.isHidden = true
        }
    }
    
// MARK: Инициализация аутлетов
    
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var removeButton: UIButton!
   
    
    
// MARK: Инициализация кнопок и их функционал
    
    // Кнопка сохранения изменений или новой ячейки (функционал завиисит от переменной changingMarker)
    @IBAction func saveButton(_ sender: UIButton) {
        guard let text = taskTextField.text else {return}
        let note = Tasks(text: text, noteColour: noteColour, textColour: textColour)
        if changingMarker {
            changeNote(database: &tasksData, at: indexOfEditingItem, note: note)
        } else {
            addNote(database: &tasksData, note: note)
        }
        PersistanceRealm.shared.saveData(data: tasksData)
        delegate?.updateDesk()
        dismiss(animated: true)
    }
    
    // Кнопка удаления ячейки
    @IBAction func removeButton(_ sender: UIButton) {
        deleteNote(database: &tasksData, at: indexOfEditingItem)
        PersistanceRealm.shared.saveData(data: tasksData)
        delegate?.updateDesk()
        dismiss(animated: true)
    }
    
    // Кнопки цветов заметки
    @IBAction func orangeNoteButton(_ sender: Any) {
        noteColour = "оранжевый"
    }
    
    @IBAction func greenNoteButton(_ sender: Any) {
        noteColour = "зеленый"
    }
   
    @IBAction func blueNoteButton(_ sender: Any) {
        noteColour = "голубой"
    }
    
    @IBAction func yellowNoteButton(_ sender: Any) {
        noteColour = "желтый"
    }
    
    // Кнопки цветов текста
    @IBAction func blackTextColourButton(_ sender: Any) {
        textColour = "черный"
    }
    
    @IBAction func seaTextColourButton(_ sender: Any) {
        textColour = "белый"
    }
    
    @IBAction func grayTextColourButton(_ sender: Any) {
        textColour = "серый"
    }
   
    @IBAction func redTextColourButton(_ sender: Any) {
        textColour = "красный"
    }
    
}



