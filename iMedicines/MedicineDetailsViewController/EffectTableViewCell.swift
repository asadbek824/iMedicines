//
//  EffectTableViewCell.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 26/07/24.
//

import UIKit

final class EffectTableViewCell: UITableViewCell {
    
    private let whiteView = UIView()
    let effectLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        backgroundColor = .clear
        
        setUpWhiteView()
        setUpEffectLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EffectTableViewCell {
    
    private func setUpWhiteView() {
        
        addSubview(whiteView)
        
        whiteView.setConstraint(.left, from: self, 0)
        whiteView.setConstraint(.right, from: self, 0)
        whiteView.setConstraint(.top, from: self, 4)
        whiteView.setConstraint(.bottom, from: self, 4)
        
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 16
    }
    
    private func setUpEffectLabel() {
        
        whiteView.addSubview(effectLabel)
        
        effectLabel.setConstraint(.left, from: whiteView, 8)
        effectLabel.setConstraint(.right, from: whiteView, 8)
        effectLabel.setConstraint(.top, from: whiteView, 8)
        effectLabel.setConstraint(.bottom, from: whiteView, 8)
        
        effectLabel.font = .boldSystemFont(ofSize: 16)
        effectLabel.numberOfLines = 0
    }
}

