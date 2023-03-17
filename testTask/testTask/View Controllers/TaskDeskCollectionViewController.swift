//
//  TaskDeskCollectionViewController.swift
//  testTask
//
//  Created by Павел Замулин on 13.03.2023.
//

import UIKit

class TaskDeskCollectionViewController: UICollectionViewController {

// MARK: Действия перед загрузкой окна
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Подгрузка данных с Realm
        PersistanceRealm.shared.loadData(data: &tasksData)
        collectionView.reloadData()
    
        // Создание жеста для перемещения ячейки по списку
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        collectionView.addGestureRecognizer(longPress)

    }

// MARK: Создание Collection View
    
    // Количество секций
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // Количество ячеек определяем как количество элементов в массиве "базы данных" tasksData
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksData.count
    }

    // Кастомизация ячейки
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor.init(gray: 2/3, alpha: 1)
        cell.mainLabel.text = tasksData[indexPath.item].text
        return cell
    }

// MARK: Перестроение ячеек доски по нажатию кнопки
    
    @IBAction func rebuildDesk(_ sender: Any) {
        if cellsInLine == 1 {
            cellsInLine = 2
        } else { cellsInLine = 1 }
        collectionView.performBatchUpdates({collectionView.reloadData()}, completion: nil)
    }
    

// MARK: Подготовка форм редактирования и создания заметок
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Подготовка формы окна режима редактирования заметки по нажатию на саму заметку
        if let editVC = segue.destination as? EditorViewController, segue.identifier == "editSegue" {
            let cell = sender as! TaskCell
            guard let preparedText = cell.mainLabel.text else {return}
            editVC.textOfTextField = preparedText
            guard let index = collectionView.indexPath(for: cell) else {return}
            editVC.indexOfEditingItem = index.item
            editVC.changingMarker = true
            editVC.delegate = self
        }
        
        // Подготовка формы окна режима создания новой заметки по нажатию на кнопку "Добавления новой заметки"
        if let addVC = segue.destination as? EditorViewController, segue.identifier == "addSegue" {
            addVC.changingMarker = false
            addVC.delegate = self
        }
    }
    
// MARK: Обработка жеста перемещения ячеек
    
    // Определение состояния объекта в зависимости от стадии жеста
    @objc private func longPressGesture (_ gesture: UILongPressGestureRecognizer) {
        let touchLocation = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: touchLocation) else {return}
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed: collectionView.updateInteractiveMovementTargetPosition(touchLocation)
        case .ended: collectionView.endInteractiveMovement()
        default: collectionView.cancelInteractiveMovement()
        }
    }
    
    // Передвижение элемента массива в зависимости от передвижения ячейки
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = tasksData.remove(at: sourceIndexPath.item)
        tasksData.insert(item, at: destinationIndexPath.item)
        PersistanceRealm.shared.saveData(data: tasksData)
        print("Массив на стадии перемещения ячейки: \(tasksData)")
    }
    
}

// MARK: Настройка Layout

extension TaskDeskCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // Задание размеров ячейки в зависимости от количества ячеек в одной строке и размера экрана устройства
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let summOfPaddings = 20 * (cellsInLine + 1)
        let avalibleWidth = collectionView.frame.width - summOfPaddings - 10
        let w = avalibleWidth / cellsInLine
        let h = 75 * cellsInLine
        return CGSize(width: w, height: h)
    }
    
    // Отступы от секции до Safe Area, внутри секции и между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: Обновление коллекции по нажатию на кнопки с другого экрана через делегата

extension TaskDeskCollectionViewController: TaskDeskDelegate {
    func updateDesk() {
        collectionView.reloadData()
    }
}

