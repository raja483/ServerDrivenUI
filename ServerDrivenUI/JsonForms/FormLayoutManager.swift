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

let VALUE_CHANGE_NOTIF = Notification.Name("ComponentValueChanged")

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
            anyView = cmp.padding().toAnyView()
        case .textView:
            
            let cmp = TextView.prepareView(uiSchema: uiSchema)
            formViewModes.append(cmp)
            anyView = cmp.toAnyView()
            
        case .editText:
            
            let cmp = CHTextEditor.prepareView(uiSchema: uiSchema)
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
            let cmpType = getComponent(scope: scope ?? "", uiSchema: uiSchema)
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
    
    private func getComponent(scope: String, uiSchema: JSON) -> ComponentType {
        
        let component = getComponentData(scope: scope)
        
        let cmpType = component.type?.stringValue ?? ""
        let dateType = component.format?.stringValue ?? ""
        let dropdownType = component.enum?.arrayValue ?? []
        let dropdwonCount = dropdownType.count
        
        let isOtherNotes = scope.hasSuffix("otherNotes")
        var isMultiType = false
        if isOtherNotes {
            let textViewFormatType = uiSchema.options?.objectValue ?? [:]
            isMultiType =  (textViewFormatType["multi"] != nil)
            
        }
        
        switch (cmpType, dateType, dropdwonCount, isMultiType) {
        case ("string", "", 0, false) :
            return .textField
        case ("string", "date", 0, false) :
            return .dateField
        case ("string", "", 0, isMultiType) :
            return .editText
        case ("string", "", dropdwonCount, false) :
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
    
    func getFormData() -> [String: String]? {
        
        var valuesDictionary: [String: String]?  = [String: String]()
        for model in formViewModes {
            
            let name = model.getFieldName()
            let value = model.getFieldValues()
            valuesDictionary?[name] = value
            
            if model.isRequired() && value.isEmpty {
                valuesDictionary = nil
                return valuesDictionary
            }
            
        }
        return valuesDictionary
    }
}

// Reload Formlayout
extension FormLayoutManager {
    
    func reloadLayout(uiSchema: JSON)-> AnyView  {
        self.prepareComponentes()
        let updatedView = self.prepareUpdatedLayout(uiSchema: uiSchema)
        return updatedView
    }
    
    private func prepareComponentes() {
        
        for i in 0..<formViewModes.count {
            var cmp = formViewModes[i]
            let scope = cmp.rule.scope
            let exptValue = cmp.rule.expectedValue
            let matchedComp = formViewModes.filter {
                $0.scope == scope
            }.first
            
            let isConditionMet = (exptValue == matchedComp?.getFieldValues() && !exptValue.isEmpty)
            
            let effect = cmp.rule.effect
            switch effect {
            case "HIDE":
                cmp.isVisibile = !isConditionMet
                
            case "SHOW":
                cmp.isVisibile = isConditionMet
                
            case "DISABLE":
                cmp.isVisibile = !isConditionMet
                
            case "ENABLE":
                cmp.isVisibile = isConditionMet
                
            default:
                print("No Effect")
            }

        }
    }
    
    private func prepareUpdatedLayout(uiSchema: JSON) -> AnyView {
        
        var view = Text("").toAnyView()
        let layout = getLayoutType(uiSchema: uiSchema)
        
        switch layout {
        case .vertical:
            if let elements = uiSchema.elements?.arrayValue {
                if let layout = prepareUpdatedVerticalLayout(elements: elements) {
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
                if let layout = prepareUpdatedHorizontalLayout(elements: elements) {
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
    
    private func prepareUpdatedVerticalLayout(elements: [JSON]) -> AnyView? {
        
        var viewComponentsArray = [AnyView]()
        
        for component in elements {
            
            // check for layout type
            let layout = getLayoutType(uiSchema: component)
            if  layout != .none {
                let layout = prepareUpdatedLayout(uiSchema: component)
                viewComponentsArray.append(layout)
            }
            
            // check for controller
            if let controller = getComponent(for: component) {
                viewComponentsArray.append(controller)
            }
        }
        
        return VStack(alignment: .leading) {
            ForEach(0..<viewComponentsArray.count) { index in
                viewComponentsArray[index]
            }
        }.toAnyView()
    }
    
    private func prepareUpdatedHorizontalLayout(elements: [JSON]) -> AnyView? {
        
        var viewComponentsArray = [AnyView]()
        
        for component in elements {
            
            // check for layout type
            let layout = getLayoutType(uiSchema: component)
            if  layout != .none {
                let layout = prepareUpdatedLayout(uiSchema: component)
                viewComponentsArray.append(layout)
                return nil
            }
            
            // check for controller
            if let controller = getComponent(for: component) {
                viewComponentsArray.append(controller)
            }
        }
        
        return HStack {
            ForEach(0..<viewComponentsArray.count) { index in
                viewComponentsArray[index]
            }
        }.toAnyView()
        
    }
    
    private func getComponent(for uiSchema: JSON) -> AnyView? {
        
        let scope = uiSchema.scope?.stringValue
        let cmp = formViewModes.filter { $0.scope == scope }.first
        return cmp?.render()
    }
}
