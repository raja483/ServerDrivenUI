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
            if let elements = uiSchema.elements?.arrayValue {
                if let layout = prepareHorizontalLayout(elements: elements) {
                    view = layout
                }
            }
            else {
#if DEBUG
                print("No elements Found")
#endif
            }
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
            }
            
            // check for controller
            if let controller = getController(uiSchema: component) {
                viewComponentsArray.append(controller)
            }
        }
        
        return VStack(alignment: .leading) {
            ForEach(0..<viewComponentsArray.count) { index in
                viewComponentsArray[index]
            }
        }.toAnyView()
    }
    
    private func prepareView(for cmpType: ComponentType, uiSchema: JSON) -> AnyView {
        
        var anyView = Text("").toAnyView()
        
        switch cmpType {
        case .text:
            anyView = Text("").toAnyView()
            
        case .textField:
           
            anyView = TextFieldView.prepareView(json: uiSchema).toAnyView()
            
        case .dropdown:
            anyView = DropdownView.prepareView(json: uiSchema).toAnyView()
            
        case .dateField:
            anyView = DateFieldView.prepareView(json: uiSchema).toAnyView()
            
        case .dateRangeField:
            anyView = Text("").toAnyView()
            
        case .progressListViewRow:
            anyView = Text("").toAnyView()
            
        case .none:
            print("None")
        }
        return anyView
    }
    
    private func prepareHorizontalLayout(elements: [JSON]) -> AnyView? {
        
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
            if let controller = getController(uiSchema: component) {
                viewComponentsArray.append(controller)
            }
        }
        
        return HStack {
            ForEach(0..<viewComponentsArray.count) { index in
                viewComponentsArray[index]
            }
        }.toAnyView()
        
    }
    
    private func getLayoutType(uiSchema: JSON) -> FormLayoutType {
        
        if let layout = uiSchema.type?.stringValue {
            
            if layout == "VerticalLayout" || layout == "HorizontalLayout" {
                return (layout == "VerticalLayout") ? .vertical : .horizontal
            }
        }
        return .none
    }
    
    private func getController(uiSchema: JSON) -> AnyView? {
        
        guard let type = uiSchema.type?.stringValue
        else {return nil}
        
        var controller = Text("").toAnyView()
        switch type {
            
        case "Label":
            let text = uiSchema.text?.stringValue ?? ""
            controller = Text(text).font(.title3).toAnyView()
            
        case "Control":
            let scope = uiSchema.scope?.stringValue
            let cmpType = getComponent(scope: scope ?? "")
            controller = prepareView(for: cmpType, uiSchema: uiSchema)
            
        default:
            controller = Text("").toAnyView()
        }
        
        return controller
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
        let dateType = component.format?.stringValue ?? ""
        let dropdownType = component.enum?.arrayValue ?? []
        let dropdwonCount = dropdownType.count

        switch (cmpType, dateType, dropdwonCount) {
        case ("string", "", 0) :
            return .textField
        case ("string", "date", 0) :
            return .dateField
        case ("string", "", dropdwonCount) :
            return .dropdown
        default:
            print("No componet found")
        }
        
        return .none
    }
    
}



