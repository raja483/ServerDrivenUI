//
//  FormLayoutManager.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 20/06/22.
//

import Foundation
import SwiftUI

enum FormLayoutType {
    case vertical
    case horizontal
    case none
}

enum ControllerType {
    case label(text: String)
    case controller(componentType: ComponentType)
    case none
}

class FormLayoutManager {
    
    private let schema: JSON
    init(schema: JSON) {
        self.schema = schema
    }
    
    func prepareLayout(uiSchema: JSON) -> AnyView {
        
        var view = Text("").toAnyView()
        let layout = getLayoutType(uiSchema: uiSchema)
        
        switch layout {
        case .vertical:
            if let elements = uiSchema.elements?.arrayValue {
                if let layout = prepareVerticalLayout(elements: elements) {
                    view = layout
                }
            }
            else {
#if DEBUG
                print("No elements Found")
#endif
            }
            
        case .horizontal:
            prepareHorizontalLayout()
        case .none:
            print("No layout found")
        }
        return view
    }
    
    private func prepareVerticalLayout(elements: [JSON]) -> AnyView? {
        
        var viewComponentsArray = [AnyView]()
        
        for component in elements {
            
            // check for layout type
            let layout = getLayoutType(uiSchema: component)
            if  layout != .none {
               let layout = prepareLayout(uiSchema: component)
                viewComponentsArray.append(layout)
                return nil
            }
            
            // check for controller
            let controller = getControllerType(uiSchema: component)
            switch controller {
                
            case .label(let text):
                
                let label = Text(text).toAnyView()
                viewComponentsArray.append(label)
                
            case .controller(let componentType):
                
                let cmp = prepareView(for: componentType)
                viewComponentsArray.append(cmp)
                
            case .none:
                print("")
                
            }
        }
        
        return VStack(alignment: .leading) {
            ForEach(0..<viewComponentsArray.count) { index in
                viewComponentsArray[index]
            }
        }.toAnyView()
    }
    
    private func prepareView(for cmpType: ComponentType) -> AnyView {
        
        var anyView = Text("").toAnyView()
        
        switch cmpType {
        case .text:
            anyView = Text("").toAnyView()
            
        case .textField:
            let model = TextFieldViewModel(model: TextFieldModel(fieldName: "", fieldValue: "", hintText: "", isMandatoryField: "", minValue: "", maxValue: "", inputType: "", validation_status: "", validation_URL: ""))
            anyView = TextFieldView(vm: model).toAnyView()
            
        case .dropdown:
            anyView = Text("").toAnyView()
            
        case .dateField:
            anyView = Text("").toAnyView()
            
        case .dateRangeField:
            anyView = Text("").toAnyView()
            
        case .progressListViewRow:
            anyView = Text("").toAnyView()
            
        case .none:
            print("None")
        }
        return anyView
    }
    
    private func prepareHorizontalLayout() {
        
        
    }
    
    private func getLayoutType(uiSchema: JSON) -> FormLayoutType {
        
        if let layout = uiSchema.type?.stringValue {
            
            if layout == "VerticalLayout" || layout == "HorizontalLayout" {
                return (layout == "VerticalLayout") ? .vertical : .horizontal
            }
        }
        return .none
    }
    
    private func getControllerType(uiSchema: JSON) -> ControllerType {
        
        guard let type = uiSchema.type?.stringValue
        else {return .none}
        
        var controllerType = ControllerType.none
        switch type {
            
        case "Label":
            let text = uiSchema.text?.stringValue ?? ""
            controllerType = .label(text: text)
            
        case "Control":
            let scope = uiSchema.scope?.stringValue
            let cmpType = getComponent(scope: scope ?? "")
            controllerType = .controller(componentType:cmpType)
        default:
            controllerType = .none
        }
        
        return controllerType
    }
    
    private func getComponent(scope: String) -> ComponentType {
        
        let schemaPath = scope.replacingOccurrences(of: "#/", with: "")
        let pathComponents = schemaPath.components(separatedBy: "/")
        
        var component = schema
        for pathComponent in pathComponents {
            if let cmp = component[pathComponent] {
                component = cmp
            }
        }
        
        let cmpType = component.type?.stringValue ?? ""
        
        switch cmpType {
        case "string":
            return .textField
        default:
            print("No componet found")
        }
        
        return .none
    }
    
}



