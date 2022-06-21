//
//  Dictionary+Extension.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 28/04/22.
//

import Foundation

extension Dictionary {
    
    func decode<T: Codable>() -> T? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
}
