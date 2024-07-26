//
//  UIViewController.swift
//  iMedicines
//
//  Created by Asadbek Yoldoshev on 25/07/24.
//

import UIKit

protocol presenterVCProtocol {
    
    func present(with vc: UIViewController)
    func pushVC(with vc: UIViewController)
    func popVC()
}

extension UIViewController: presenterVCProtocol {
    
    func present(with vc: UIViewController) {
        present(vc, animated: true)
    }
    
    func pushVC(with vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
}

