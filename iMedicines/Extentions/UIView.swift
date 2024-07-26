//
//  UIView.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 25/07/24.
//

import UIKit

//MARK: - extension to UIView Constraint
extension UIView {
    enum Anchor {
        case left
        case right
        case top
        case bottom
        case width
        case height
        case xCenter
        case yCenter
    }
    
    func setConstraint(_ anchor: Anchor, from view: UIView, _ constraint: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch anchor {
        case .left:
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraint).isActive = true
        case .right:
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraint).isActive = true
        case .top:
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: constraint).isActive = true
        case .bottom:
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constraint).isActive = true
        case .width:
            self.widthAnchor.constraint(equalToConstant: constraint).isActive = true
        case .height:
            self.heightAnchor.constraint(equalToConstant: constraint).isActive = true
        case .xCenter:
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:  constraint).isActive = true
        case .yCenter:
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constraint).isActive = true
        }
    }
}

