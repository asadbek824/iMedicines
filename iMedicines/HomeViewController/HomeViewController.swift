//
//  ViewController.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 25/07/24.
//

import UIKit
import RealmSwift

final class HomeViewController: UIViewController {
    
    private let tableView = UITableView()
    private var medicines: [Medicine] = []
    private var filteredMedicines: [Medicine] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadMedicines), name: NSNotification.Name("MedicineAdded"), object: nil)
        loadMedicines()
    }
}

//MARK: - @objc Functions
extension HomeViewController {
    
    @objc private func rightBarButtonTapped() {
        pushVC(with: AddMedicinesViewController())
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchPoint = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            showActions(for: indexPath)
        }
    }
    
    @objc private func loadMedicines() {
        let realm = try! Realm()
        medicines = Array(realm.objects(Medicine.self))
        filteredMedicines = medicines
        tableView.reloadData()
    }
}

//MARK: - Private Functions
extension HomeViewController {
    
    private func showActions(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let realm = try! Realm()
            try! realm.write {
                realm.delete(self.filteredMedicines[indexPath.row])
            }
            self.filteredMedicines.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        alertController.addAction(deleteAction)
        
        let addToHistoryAction = UIAlertAction(title: "Add to History", style: .default) { _ in
            let realm = try! Realm()
            try! realm.write {
                let medicine = self.filteredMedicines[indexPath.row]
                let historyItem = MedicineHistory()
                historyItem.name = medicine.name
                historyItem.date = medicine.date
                historyItem.time = medicine.time
                historyItem.importance = medicine.importance
                historyItem.effects.append(objectsIn: medicine.effects)
                realm.delete(medicine)
                
                realm.add(historyItem)
            }
            self.filteredMedicines.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            NotificationCenter.default.post(name: NSNotification.Name("HistoryUpdated"), object: nil)
        }
        alertController.addAction(addToHistoryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func colorForImportance(_ importance: Int) -> UIColor {
        switch importance {
        case 0: return .appColor.greenColor
        case 1: return .appColor.orangeColor
        case 2: return .appColor.redColor
        default: return .black
        }
    }
}

//MARK: - SetUpView
extension HomeViewController {
    
    private func setUpNavBar() {
        let startPointX: CGFloat = 0
        let startPointY: CGFloat = 0
        let endPointX: CGFloat = 1
        let endPointY: CGFloat = 1
        
        let gradientColor = CAGradientLayer()
        gradientColor.frame = view.frame
        
        gradientColor.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientColor.endPoint = CGPoint(x: endPointX, y: endPointY)
        
        gradientColor.colors = [
            UIColor.appColor.gradientColor.cgColor,
            UIColor.white.cgColor
        ]
        
        view.layer.addSublayer(gradientColor)
        
        title = "Medicines"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .appColor.primaryButton
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Medicines"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.backgroundColor = .clear
        
        tableView.setConstraint(.top, from: view, 0)
        tableView.setConstraint(.bottom, from: view, 0)
        tableView.setConstraint(.left, from: view, 0)
        tableView.setConstraint(.right, from: view, 0)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelectionDuringEditing = false
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - TableView Delegate & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredMedicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let medicine = filteredMedicines[indexPath.row]
        
        cell.nameMedicinesLabel.text = medicine.name
        cell.dataMedicinesLabel.text = DateFormatter.localizedString(from: medicine.date, dateStyle: .medium, timeStyle: .none)
        cell.timeMedicinesLabel.text = DateFormatter.localizedString(from: medicine.time, dateStyle: .none, timeStyle: .short)
        cell.bacgroundView.backgroundColor = colorForImportance(medicine.importance)
        
        cell.selectionStyle = .none
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMedicine = medicines[indexPath.row]
        
        let detailsVC = MedicinesDetailsViewController()
        detailsVC.medicineName = selectedMedicine.name
        detailsVC.medicineData = DateFormatter.localizedString(from: selectedMedicine.date, dateStyle: .medium, timeStyle: .none)
        detailsVC.medicineTime = DateFormatter.localizedString(from: selectedMedicine.time, dateStyle: .none, timeStyle: .short)
        detailsVC.medicineImportance = String(selectedMedicine.importance)
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            let realm = try! Realm()
            try! realm.write {
                realm.delete(self.filteredMedicines[indexPath.row])
            }
            self.filteredMedicines.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.backgroundColor = .appColor.deleteAction
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToHistoryAction = UIContextualAction(style: .normal, title: "Add to History") { _, _, completionHandler in
            let realm = try! Realm()
            try! realm.write {
                let medicine = self.filteredMedicines[indexPath.row]
                let historyItem = MedicineHistory()
                historyItem.name = medicine.name
                historyItem.date = medicine.date
                historyItem.time = medicine.time
                historyItem.importance = medicine.importance
                historyItem.effects.append(objectsIn: medicine.effects)
                realm.delete(medicine)
                
                realm.add(historyItem)
            }
            self.filteredMedicines.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name("HistoryUpdated"), object: nil)
            completionHandler(true)
        }
        addToHistoryAction.backgroundColor = .appColor.secondaryButton
        
        let configuration = UISwipeActionsConfiguration(actions: [addToHistoryAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            filteredMedicines = medicines
        } else {
            filteredMedicines = medicines.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // Animate the table view update
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }
}
