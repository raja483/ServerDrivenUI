//
//  JsonSchema+Utitlity.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 30/06/22.
//

import Foundation

struct Rule {
    
    let effect: String
    let scope: String
    let expectedValue: String
    
    static func prepareObject(for uiSchema: JSON) -> Rule {
        
        let rules = uiSchema.rule?.objectValue
        let effect = rules?["effect"]?.stringValue ?? ""
        let condition = rules?["condition"]?.objectValue
        let scope = condition?["scope"]?.stringValue ?? ""
        let expectedValue = condition?["expectedValue"]?.stringValue ?? ""
        
        return Rule(effect: effect, scope: scope, expectedValue: expectedValue)
    }
}


