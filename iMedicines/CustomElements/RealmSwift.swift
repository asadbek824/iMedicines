//
//  RealmSwift.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 26/07/24.
//

import RealmSwift
import Foundation

class Medicine: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var time: Date = Date()
    @objc dynamic var importance: Int = 0
    let effects = List<String>()
}

class MedicineHistory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var time: Date = Date()
    @objc dynamic var importance: Int = 0
    var effects = List<String>()
}
