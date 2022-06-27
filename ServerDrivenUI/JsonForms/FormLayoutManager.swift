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
    
    private var formViewModes = [UIComponent]()
    
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
    
    private func prepareView(for cmpType: ComponentType, uiSchema: JSON, jsonSchema:JSON) -> AnyView {
        
        var anyView = Text("").toAnyView()
        
        switch cmpType {
        case .text:
            anyView = Text("").toAnyView()
            
        case .textField:
            
            let scope = uiSchema.scope?.stringValue
            let name = scope?.components(separatedBy: "/").last ?? ""
            let isRequired = checkIsRequiredField(for: scope, fieldName: name)
            
            let cmp = TextFieldView.prepareView(uiSchema: uiSchema, isRequired: isRequired)
            formViewModes.append(cmp)
            anyView = cmp.toAnyView()
            
        case .dropdown:
            let cmp = DropdownView.prepareView(schema: uiSchema, json: jsonSchema)
            formViewModes.append(cmp)
            anyView = cmp.toAnyView()
            
        case .dateField:
            let cmp = DateFieldView.prepareView(json: uiSchema)
            formViewModes.append(cmp)
            anyView = cmp.toAnyView()
            
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
            let cmpData = getComponentData(scope: scope ?? "")
            controller = prepareView(for: cmpType, uiSchema: uiSchema, jsonSchema: cmpData)
            
        default:
            controller = Text("").toAnyView()
        }
        
        return controller
    }
    
    private func getComponentData(scope:String) -> JSON {
        
        let schemaPath = scope.replacingOccurrences(of: "#/", with: "")
        let pathComponents = schemaPath.components(separatedBy: "/")
        
        var component = schema
        for pathComponent in pathComponents {
            if let cmp = component[pathComponent] {
                component = cmp
            }
        }
        return component
    }
    
    private func getComponent(scope: String) -> ComponentType {
        
        let component = getComponentData(scope: scope)
        
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
    
    private func checkIsRequiredField(for scope: String?, fieldName: String) -> Bool {
        
        var pathComponents = scope?.components(separatedBy: "/")
        let _ = pathComponents?.popLast()
        var requiredFields = [String]()
        
        if let path = pathComponents?.joined(separator: "/") {
            
            var object = schema
            if path != "#/properties" {
                object = getComponentData(scope: path)
            }
            
            requiredFields = object.required?.arrayValue?.map { js -> String in
                let str = js.stringValue ?? ""
                return str
            } ?? []
        }
        
        return requiredFields.contains(fieldName)
    }
}

extension FormLayoutManager {
    
    func getFormData() -> [String: String] {
        
        var valuesDictionary = [String: String]()
        for model in formViewModes {
            
            let name = model.getFieldName()
            let value = model.getFieldValues()
            valuesDictionary[name] = value
            
            if model.isRequired() && value.isEmpty {
                
            }
            
        }
        return valuesDictionary
    }
}

