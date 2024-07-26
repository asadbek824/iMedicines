//
//  MedicinesHistoryViewController.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 25/07/24.
//

import UIKit
import RealmSwift

final class MedicinesHistoryViewController: UIViewController {
    
    private let tableView = UITableView()
    private var historyItems: Results<MedicineHistory>?
    private var filteredHistoryItems: Results<MedicineHistory>?
    private var isFiltering: Bool {
        return navigationItem.searchController?.isActive == true && !(navigationItem.searchController?.searchBar.text?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGradientColor()
        setUpNavBar()
        setUpTableView()
        
        loadHistory()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadHistory), name: NSNotification.Name("HistoryUpdated"), object: nil)
    }
}

//MARK: - @objc Functions
extension MedicinesHistoryViewController {
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let touchPoint = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            showActions(for: indexPath)
        }
    }
    
    @objc private func loadHistory() {
        let realm = try! Realm()
        historyItems = realm.objects(MedicineHistory.self)
        tableView.reloadData()
    }
}

//MARK: - Private functions
extension MedicinesHistoryViewController {
    
    private func showActions(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            if let itemToDelete = self.isFiltering ? self.filteredHistoryItems?[indexPath.row] : self.historyItems?[indexPath.row] {
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(itemToDelete)
                }
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
            }
        }
        alertController.addAction(deleteAction)
        
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

//MARK: - SetUpViews
extension MedicinesHistoryViewController {
    
    private func setUpGradientColor() {
        
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
    }
    
    private func setUpNavBar() {
        title = "History"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        
        tableView.setConstraint(.right, from: view, 0)
        tableView.setConstraint(.left, from: view, 0)
        tableView.setConstraint(.bottom, from: view, 0)
        tableView.setConstraint(.top, from: view, 0)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - TableView Delegate & DataSource
extension MedicinesHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredHistoryItems?.count ?? 0 : historyItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let historyItem = isFiltering ? filteredHistoryItems?[indexPath.row] : historyItems?[indexPath.row]
        
        if let historyItem = historyItem {
            cell.nameMedicinesLabel.text = historyItem.name
            cell.dataMedicinesLabel.text = DateFormatter.localizedString(from: historyItem.date, dateStyle: .medium, timeStyle: .none)
            cell.timeMedicinesLabel.text = DateFormatter.localizedString(from: historyItem.time, dateStyle: .none, timeStyle: .short)
            cell.bacgroundView.backgroundColor = colorForImportance(historyItem.importance)
        }
        
        cell.selectionStyle = .none
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedHistory = isFiltering ? filteredHistoryItems?[indexPath.row] : historyItems?[indexPath.row]
        
        if let selectedHistory = selectedHistory {
            let detailsVC = MedicinesDetailsViewController()
            
            detailsVC.medicineName = selectedHistory.name
            detailsVC.medicineData = DateFormatter.localizedString(from: selectedHistory.date, dateStyle: .medium, timeStyle: .none)
            detailsVC.medicineTime = DateFormatter.localizedString(from: selectedHistory.time, dateStyle: .none, timeStyle: .short)
            detailsVC.medicineImportance = String(selectedHistory.importance)
            detailsVC.effects = selectedHistory.effects
            
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            if let itemToDelete = self.isFiltering ? self.filteredHistoryItems?[indexPath.row] : self.historyItems?[indexPath.row] {
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(itemToDelete)
                }
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
                completionHandler(true)
            }
        }
        
        deleteAction.backgroundColor = .appColor.deleteAction
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension MedicinesHistoryViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            filteredHistoryItems = historyItems
            tableView.reloadData()
            return
        }
        
        if searchText.isEmpty {
            filteredHistoryItems = historyItems
        } else {
            let _ = try! Realm()
            filteredHistoryItems = historyItems?.filter("name CONTAINS[c] %@", searchText)
        }
        
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }
}
