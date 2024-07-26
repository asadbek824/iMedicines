//
//  MedicineEffectsViewController.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 26/07/24.
//

import UIKit
import RealmSwift

final class MedicineEffectsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let textViewStackView = UIStackView()
    private let textView = UITextView()
    private let textViewLabel = UILabel()
    private let nextButton = UIButton(type: .system)
    
    var medicineName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpNavBar()
        setUpScrollView()
        setUpStackView()
        setUpTextViewStackView()
        setUpTextViewLabel()
        setUpTextView()
        setUpNextButton()
        setUpGradientBackground()
        setUpTapGesture()
        registerForKeyboardNotifications()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardFrame.height
        
        if let activeField = textView.isFirstResponder ? textView : nil {
            if !visibleRect.contains(activeField.frame.origin) {
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func nextButtonTapped() {
        guard let effectText = textView.text, !effectText.isEmpty else { return }

        let realm = try! Realm()
        try! realm.write {
            
            let allMedicines = realm.objects(Medicine.self)
            print("All medicines in database:")
            for med in allMedicines {
                print("Medicine name: \(med.name)")
            }
            
            let allHistory = realm.objects(MedicineHistory.self)
            print("All History in database:")
            for his in allHistory {
                print("History name: \(his.name)")
            }
            
            if let medicine = allMedicines.filter("name == %@", medicineName).first {
                medicine.effects.append(effectText)
                NotificationCenter.default.post(name: NSNotification.Name("EffectAdded"), object: nil)
                popVC()
            } else if let history = allHistory.filter("name == %@", medicineName).first {
                history.effects.append(effectText)
                NotificationCenter.default.post(name: NSNotification.Name("EffectAdded"), object: nil)
                popVC()
            } else {
                print("Error: Medicine with name \(medicineName) not found")
            }
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension MedicineEffectsViewController {
    
    private func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension MedicineEffectsViewController {
    
    private func setUpNavBar() {
        title = "Medicine Effects"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setUpGradientBackground() {
        let startPointX: CGFloat = 0
        let startPointY: CGFloat = 0
        let endPointX: CGFloat = 1
        let endPointY: CGFloat = 1
        
        let gradientColor = CAGradientLayer()
        gradientColor.frame = view.bounds
        gradientColor.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientColor.endPoint = CGPoint(x: endPointX, y: endPointY)
        gradientColor.colors = [
            UIColor.systemCyan.cgColor,
            UIColor.white.cgColor
        ]
        
        view.layer.insertSublayer(gradientColor, at: 0)
    }
    
    private func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.setConstraint(.left, from: view, 0)
        scrollView.setConstraint(.right, from: view, 0)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setUpStackView() {
        scrollView.addSubview(stackView)
        stackView.setConstraint(.left, from: scrollView, 0)
        stackView.setConstraint(.top, from: scrollView, 0)
        stackView.setConstraint(.right, from: scrollView, 0)
        stackView.setConstraint(.bottom, from: scrollView, 0)
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
    }
    
    private func setUpTextViewStackView() {
        stackView.addArrangedSubview(textViewStackView)
        textViewStackView.axis = .vertical
        textViewStackView.spacing = 8
        textViewStackView.alignment = .fill
    }
    
    private func setUpTextViewLabel() {
        textViewStackView.addArrangedSubview(textViewLabel)
        textViewLabel.text = "Iltimos, quyidagi sohada dorining har qanday nojo'ya ta'siri yoki ijobiy ta'sirini kiriting:"
        textViewLabel.textAlignment = .center
        textViewLabel.textColor = .darkGray
        textViewLabel.numberOfLines = 0
        textViewLabel.textAlignment = .left
        textViewLabel.setConstraint(.width, from: textViewStackView, UIScreen.main.bounds.width - 32)
    }
    
    private func setUpTextView() {
        textViewStackView.addArrangedSubview(textView)
        textView.setConstraint(.width, from: textViewStackView, UIScreen.main.bounds.width - 32)
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.layer.shadowColor = UIColor.gray.cgColor
        textView.layer.shadowOffset = CGSize(width: 0, height: 2)
        textView.layer.shadowOpacity = 0.3
        textView.layer.shadowRadius = 4
        textView.delegate = self
    }
    
    private func setUpNextButton() {
        stackView.addArrangedSubview(nextButton)
        nextButton.setConstraint(.width, from: view, UIScreen.main.bounds.width - 32)
        nextButton.setConstraint(.left, from: view, 16)
        nextButton.setConstraint(.height, from: view, 40)
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

extension MedicineEffectsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

