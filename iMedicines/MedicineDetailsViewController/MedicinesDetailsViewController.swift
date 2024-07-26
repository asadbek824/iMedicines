//
//  MedicinesDetailsViewController.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 26/07/24.
//

import UIKit
import RealmSwift

final class MedicinesDetailsViewController: UIViewController {
    
    var medicineName: String = ""
    var medicineData: String = ""
    var medicineTime: String = ""
    var medicineImportance: String = ""
    
    var effects: List<String>?
    
    //MARK: UIElements
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let medicineDetailsStackView = UIStackView()
    private let medicineDataLabel = UILabel()
    private let medicineTimeLabel = UILabel()
    private let medicineImportancelabel = UILabel()
    private let effectsLabel = UILabel()
    private let effectsTableView = UITableView()
    private var effectsTableViewHeightConstraint: NSLayoutConstraint?
    
    private var isObserverAdded = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpScrollView()
        setUpStackView()
        setUpMedicineDetailsStackView()
        setUpMedicineDataLabel()
        setUpMedicineTimeLabel()
        setUpMedicineImportanceLabel()
        setUpEffectsLabel()
        setUpEffectTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadEffects), name: NSNotification.Name("EffectAdded"), object: nil)
        loadEffects()
    }
    
    @objc private func loadEffects() {
        let realm = try! Realm()
        if let medicine = realm.objects(Medicine.self).filter("name == %@", medicineName).first {
            effects = medicine.effects
        } else if let histrory = realm.objects(MedicineHistory.self).filter("name == %@", medicineName).first {
            effects = histrory.effects
        } else {
            print("Error: Medicine not found")
        }
        effectsTableView.reloadData()
    }
    
    @objc private func rightBarButtonTapped() {
        
        let effectVC = MedicineEffectsViewController()
        effectVC.medicineName = medicineName
        
        pushVC(with: effectVC)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                effectsTableViewHeightConstraint?.constant = newSize.height
            }
        }
    }

    deinit {
        effectsTableView.removeObserver(self, forKeyPath: "contentSize")
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Private Functions
extension MedicinesDetailsViewController {
    
    private func colorToString(hex: String) -> String {
        switch hex {
        case "0":
            return "Yashil"
        case "2":
            return "Qizil"
        case "1":
            return "To'q sariq"
        default:
            return "неизвестный цвет"
        }
    }
    
    private func getColorForHex(hex: String) -> UIColor {
        switch hex {
        case "0":
            return .appColor.greenColor
        case "2":
            return .appColor.redColor
        case "1":
            return .appColor.orangeColor
        default:
            return .black
        }
    }
}

//MARK: - SetUpView
extension MedicinesDetailsViewController {
    
    private func setUpNavBar() {
        
        title = medicineName
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "pencil.and.list.clipboard.rtl"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .appColor.primaryButton
    }
    
    private func setUpScrollView() {
        
        view.addSubview(scrollView)
        
        scrollView.setConstraint(.bottom, from: view, 0)
        scrollView.setConstraint(.left, from: view, 0)
        scrollView.setConstraint(.right, from: view, 0)
        scrollView.setConstraint(.top, from: view, 0)
    }
    
    private func setUpStackView() {
        
        scrollView.addSubview(stackView)
        
        stackView.setConstraint(.bottom, from: scrollView, 24)
        stackView.setConstraint(.left, from: scrollView, 0)
        stackView.setConstraint(.right, from: scrollView, 0)
        stackView.setConstraint(.top, from: scrollView, 24)
        
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
    }
    
    private func setUpMedicineDetailsStackView() {
        
        stackView.addArrangedSubview(medicineDetailsStackView)
        
        medicineDetailsStackView.spacing = 16
        medicineDetailsStackView.axis = .vertical
        medicineDetailsStackView.alignment = .fill
    }
    
    private func setUpMedicineDataLabel() {
        
        medicineDetailsStackView.addArrangedSubview(medicineDataLabel)
        
        medicineDataLabel.text = "Dorining istemol qilish sanasi: \(medicineData)"
        
        medicineDataLabel.setConstraint(.left, from: medicineDetailsStackView, 16)
        medicineDataLabel.setConstraint(.width, from: medicineDetailsStackView, UIScreen.main.bounds.width - 32)
        
        medicineDataLabel.textColor = .black
        medicineDataLabel.numberOfLines = 0
        medicineDataLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    private func setUpMedicineTimeLabel() {
        
        medicineDetailsStackView.addArrangedSubview(medicineTimeLabel)
        
        medicineTimeLabel.text = "Dorining istemol qilish vaqti: \(medicineTime)"
        
        medicineTimeLabel.setConstraint(.left, from: medicineDetailsStackView, 16)
        medicineTimeLabel.setConstraint(.width, from: medicineDetailsStackView, UIScreen.main.bounds.width - 32)
        
        medicineTimeLabel.textColor = .black
        medicineTimeLabel.numberOfLines = 0
        medicineTimeLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    private func setUpMedicineImportanceLabel() {
        
        medicineDetailsStackView.addArrangedSubview(medicineImportancelabel)
        
        medicineImportancelabel.setConstraint(.left, from: medicineDetailsStackView, 16)
        medicineImportancelabel.setConstraint(.width, from: medicineDetailsStackView, UIScreen.main.bounds.width - 32)
        
        let attributedText = NSMutableAttributedString(string: "Dorining muhimlik darajasi: ", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ])
        
        let colorString = colorToString(hex: medicineImportance)
        
        let colorAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: getColorForHex(hex: medicineImportance)
        ]
        
        attributedText.append(NSAttributedString(string: colorString, attributes: colorAttributes))
        
        medicineImportancelabel.attributedText = attributedText
        
        medicineImportancelabel.numberOfLines = 0
    }
    
    private func setUpEffectsLabel() {
        
        stackView.addArrangedSubview(effectsLabel)
        
        effectsLabel.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        effectsLabel.setConstraint(.left, from: stackView, 16)
        
        effectsLabel.textColor = .black
        effectsLabel.numberOfLines = 0
        effectsLabel.font = .boldSystemFont(ofSize: 24)
        effectsLabel.text = "Effects"
    }
    
    private func setUpEffectTableView() {
        
        stackView.addArrangedSubview(effectsTableView)
        
        effectsTableView.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        
        effectsTableViewHeightConstraint = effectsTableView.heightAnchor.constraint(equalToConstant: 0)
        effectsTableViewHeightConstraint?.isActive = true
        
        effectsTableView.delegate = self
        effectsTableView.dataSource = self
        
        effectsTableView.register(EffectTableViewCell.self, forCellReuseIdentifier: "cell")
        
        effectsTableView.isScrollEnabled = false
        effectsTableView.backgroundColor = .clear
        effectsTableView.separatorStyle = .none
        
        effectsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
}

//MARK: - TableView Delegate & DataSourse
extension MedicinesDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return effects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EffectTableViewCell else { return UITableViewCell() }
        
        cell.effectLabel.text = effects?[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            try! realm.write {
                effects?.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

