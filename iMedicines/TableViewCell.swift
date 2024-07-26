//
//  TableViewCell.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 25/07/24.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    let bacgroundView = UIView()
    let nameMedicinesLabel = UILabel()
    let dataMedicinesLabel = UILabel()
    let timeMedicinesLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(bacgroundView)
        
        bacgroundView.setConstraint(.bottom, from: self, 4)
        bacgroundView.setConstraint(.top, from: self, 4)
        bacgroundView.setConstraint(.left, from: self, 16)
        bacgroundView.setConstraint(.right, from: self, 16)
        
        bacgroundView.layer.cornerRadius = 36
        bacgroundView.backgroundColor = .white
        
        bacgroundView.addSubview(nameMedicinesLabel)
        
        nameMedicinesLabel.setConstraint(.top, from: bacgroundView, 8)
        nameMedicinesLabel.setConstraint(.bottom, from: bacgroundView, 8)
        nameMedicinesLabel.setConstraint(.left, from: bacgroundView, 16)
        nameMedicinesLabel.setConstraint(.right, from: bacgroundView, 120)
        
        nameMedicinesLabel.text = ""
        nameMedicinesLabel.font = .systemFont(ofSize: 20)
        nameMedicinesLabel.numberOfLines = .zero
        
        bacgroundView.addSubview(dataMedicinesLabel)
        
        dataMedicinesLabel.setConstraint(.yCenter, from: bacgroundView, -14)
        dataMedicinesLabel.setConstraint(.right, from: bacgroundView, 16)
        
        dataMedicinesLabel.text = ""
        dataMedicinesLabel.font = .systemFont(ofSize: 16)
        
        bacgroundView.addSubview(timeMedicinesLabel)
        
        timeMedicinesLabel.setConstraint(.yCenter, from: bacgroundView, 14)
        timeMedicinesLabel.setConstraint(.right, from: bacgroundView, 16)
        
        timeMedicinesLabel.text = ""
        timeMedicinesLabel.font = .systemFont(ofSize: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

