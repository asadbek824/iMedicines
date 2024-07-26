//
//  AddMedicinesViewController.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 25/07/24.
//

import UIKit
import RealmSwift

final class AddMedicinesViewController: UIViewController {
    
    //MARK: UIElements
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let dataPickerStackView = UIStackView()
    private let timePickerStackView = UIStackView()
    private let segmentControllerStackView = UIStackView()
    private let nameMeidcinesStackView = UIStackView()
    private let nameMedicinesLabel  = UILabel()
    private let nameMedicinesTF = UITextView()
    private let dataPickerLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let timePickerLabel = UILabel()
    private let timePicker = UIDatePicker()
    private let nextButton = UIButton(type: .system)
    private let segmentControllerLabel = UILabel()
    private let importanceSegmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGradiendColor()
        setUpNavBar()
        setUpScrollView()
        setUpStackView()
        setUpNameStackView()
        setUpNameTextLabel()
        setUpNameTextField()
        setUpDataPickerStackView()
        setUpDatePickerLabel()
        setUpDatePicker()
        setUpTimePickerStackView()
        setUpTimePickerLabel()
        setUpTimePicker()
        setUpSegmentControllerStackView()
        setUpSegmentControllerLabel()
        setUpSegmentController()
        updateSegmentedControlColor()
        setUpNextButton()
        hideKeyboardWhenTappedAround()
        
        NotificationManager.shared.requestAuthorization()
    }
}

//MARK: - @objc Functions
extension AddMedicinesViewController {
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func datePickerValueChanged() {
        view.endEditing(true)
    }
    
    @objc private func rightBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonTapped() {
        guard let nameText = nameMedicinesTF.text, !nameText.isEmpty else {
            showAlert(title: "Xatolik!", message: "Iltimos, dori nomini kiriting.")
            return
        }
        
        let importanceIndex = importanceSegmentedControl.selectedSegmentIndex
        
        let newMedicine = Medicine()
        
        newMedicine.name = nameText
        newMedicine.date = datePicker.date
        newMedicine.time = timePicker.date
        newMedicine.importance = importanceIndex
        
        // Сохранение в Realm
        let realm = try! Realm()
        try! realm.write {
            realm.add(newMedicine)
        }
        
        let notificationDate = combineDateWithTime(date: datePicker.date, time: timePicker.date)
        
        NotificationManager.shared.scheduleNotification(
            at: notificationDate,
            title: "Doringizni qabul qilish vaqti keldi!",
            body: "\(nameText)ni qabul qilish esingizdan chiqmasin!"
        )
        
        // Передача данных в HomeViewController
        NotificationCenter.default.post(name: NSNotification.Name("MedicineAdded"), object: nil)
        
        clearTextFields()
        popVC()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateSegmentedControlColor()
    }
}

//MARK: - Private Functions
extension AddMedicinesViewController {
    
    private func combineDateWithTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents) ?? Date()
    }
    
    private func clearTextFields() {
        nameMedicinesTF.text = ""
        datePicker.date = Date()
        timePicker.date = Date()
        importanceSegmentedControl.selectedSegmentIndex = 0
        updateSegmentedControlColor()
    }

    private func updateSegmentedControlColor() {
        switch importanceSegmentedControl.selectedSegmentIndex {
        case 0:
            importanceSegmentedControl.selectedSegmentTintColor = .appColor.greenColor
        case 1:
            importanceSegmentedControl.selectedSegmentTintColor = .appColor.orangeColor
        case 2:
            importanceSegmentedControl.selectedSegmentTintColor = .appColor.redColor
        default:
            importanceSegmentedControl.selectedSegmentTintColor = .appColor.greenColor
        }
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - SetUpView
extension AddMedicinesViewController {
    
    private func setUpGradiendColor() {
        
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .appColor.primaryButton
        
        title = "Dori qo'shish"
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
        stackView.spacing = 20
        stackView.alignment = .center
    }
    
    private func setUpNameStackView() {
        
        stackView.addArrangedSubview(nameMeidcinesStackView)
        
        nameMeidcinesStackView.axis = .vertical
        nameMeidcinesStackView.spacing = 4
        nameMeidcinesStackView.alignment = .center
    }
    
    private func setUpNameTextLabel() {
        
        nameMeidcinesStackView.addArrangedSubview(nameMedicinesLabel)
        
        nameMedicinesLabel.setConstraint(.height, from: stackView, 20)
        nameMedicinesLabel.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        
        nameMedicinesLabel.text = "Dorining nomini kiriting"
        nameMedicinesLabel.numberOfLines = 0
        nameMedicinesLabel.textAlignment = .center
        nameMedicinesLabel.textColor = .darkGray
    }
    
    private func setUpNameTextField() {
        
        nameMeidcinesStackView.addArrangedSubview(nameMedicinesTF)
        
        nameMedicinesTF.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        nameMedicinesTF.setConstraint(.left, from: stackView, 16)
        nameMedicinesTF.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        nameMedicinesTF.textAlignment = .center
        nameMedicinesTF.layer.borderWidth = 1
        nameMedicinesTF.layer.cornerRadius = 8
        nameMedicinesTF.backgroundColor = .clear
        nameMedicinesTF.isScrollEnabled = false
        nameMedicinesTF.font = .systemFont(ofSize: 20)
    }
    
    private func setUpDataPickerStackView() {
        
        stackView.addArrangedSubview(dataPickerStackView)
        
        dataPickerStackView.axis = .vertical
        dataPickerStackView.spacing = 4
        dataPickerStackView.alignment = .center
    }
    
    private func setUpDatePickerLabel() {
        
        dataPickerStackView.addArrangedSubview(dataPickerLabel)
        
        dataPickerLabel.setConstraint(.height, from: stackView, 20)
        dataPickerLabel.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        
        dataPickerLabel.text = "Dorining iste'mol qilish sanasini tanlang"
        dataPickerLabel.numberOfLines = 0
        dataPickerLabel.textAlignment = .center
        dataPickerLabel.textColor = .darkGray
    }
    
    private func setUpDatePicker() {
        
        dataPickerStackView.addArrangedSubview(datePicker)
        
        datePicker.setConstraint(.height, from: stackView, 150)
        datePicker.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    private func setUpTimePickerStackView() {
        
        stackView.addArrangedSubview(timePickerStackView)
        
        timePickerStackView.axis = .vertical
        timePickerStackView.spacing = 4
        timePickerStackView.alignment = .center
    }
    
    private func setUpTimePicker() {
        
        timePickerStackView.addArrangedSubview(timePicker)
        
        timePicker.setConstraint(.height, from: stackView, 120)
        
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
    }
    
    private func setUpTimePickerLabel() {
        
        timePickerStackView.addArrangedSubview(timePickerLabel)
        
        timePickerLabel.setConstraint(.height, from: stackView, 20)
        timePickerLabel.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        
        timePickerLabel.text = "Dorining iste'mol qilish vaqtini tanlang"
        timePickerLabel.numberOfLines = 0
        timePickerLabel.textAlignment = .center
        timePickerLabel.textColor = .darkGray
    }
    
    private func setUpSegmentControllerStackView() {
        
        stackView.addArrangedSubview(segmentControllerStackView)
        
        segmentControllerStackView.axis = .vertical
        segmentControllerStackView.spacing = 4
        segmentControllerStackView.alignment = .center
    }
    
    private func setUpSegmentControllerLabel() {
        
        segmentControllerStackView.addArrangedSubview(segmentControllerLabel)
        
        segmentControllerLabel.setConstraint(.height, from: stackView, 20)
        segmentControllerLabel.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        
        segmentControllerLabel.text = "Dorining muhimlik darajasini tanlang"
        segmentControllerLabel.numberOfLines = 0
        segmentControllerLabel.textAlignment = .center
        segmentControllerLabel.textColor = .darkGray
    }
    
    private func setUpSegmentController() {
        
        segmentControllerStackView.addArrangedSubview(importanceSegmentedControl)
        
        importanceSegmentedControl.setConstraint(.height, from: stackView, 40)
        importanceSegmentedControl.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        
        importanceSegmentedControl.insertSegment(withTitle: "Green", at: 0, animated: false)
        importanceSegmentedControl.insertSegment(withTitle: "Orange", at: 1, animated: false)
        importanceSegmentedControl.insertSegment(withTitle: "Red", at: 2, animated: false)
        importanceSegmentedControl.selectedSegmentIndex = 0
        
        importanceSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func setUpNextButton() {
        
        stackView.addArrangedSubview(nextButton)
        
        nextButton.setConstraint(.height, from: stackView, 40)
        nextButton.setConstraint(.width, from: stackView, UIScreen.main.bounds.width - 32)
        
        nextButton.setTitle("ENTER", for: .normal)
        nextButton.tintColor = .black
        nextButton.backgroundColor = .appColor.primaryButton
        nextButton.layer.cornerRadius = 8
        nextButton.layer.shadowColor = UIColor(white: 0.7, alpha: 1).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowRadius = 5
        nextButton.layer.masksToBounds = false
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
}

