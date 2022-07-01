//
//  Server Driven UI
//
//  Created by Venkat Pericharla on 28/04/22.
//

import Foundation
import SwiftUI

protocol UIComponent {
    var uniqueId: UUID { get }
    var componentType: ComponentType {get}
    var isVisibile: Bool { set get }
    var scope: String{set get}
    var rule: Rule {set get}
    
    func render() -> AnyView
    func getFieldValues() -> String
    func getFieldName() -> String
    func isRequired() -> Bool
}

extension UIComponent {
    var uniqueId: UUID { UUID() }
    var isVisibile: Bool { set{} get {return true} }
    var scope:String{ set{} get { return ""}}
    var rule: Rule{ set{} get{ return Rule(effect: "", scope: "", expectedValue: "")}}
}


