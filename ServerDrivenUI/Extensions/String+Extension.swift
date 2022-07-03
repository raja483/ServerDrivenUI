//
//  String+Extension.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 03/07/22.
//

import Foundation
extension String {
    
    func toDate() -> Date? {
        
        let formator = DateFormatter()
        formator.dateFormat = "dd/MM/yyyy"
        return formator.date(from: self)
    }
    
}
