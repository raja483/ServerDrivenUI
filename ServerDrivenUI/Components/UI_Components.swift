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
    func render() -> AnyView
    func getFieldValues() -> String
    func getFieldName() -> String
    func isRequired() -> Bool
}

extension UIComponent {
    var uniqueId: UUID { UUID() }
}


