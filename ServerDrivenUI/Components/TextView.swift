//
//  TextView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 30/04/22.
//

import SwiftUI

enum FieldValueType: String, Codable {
    case markdownText
    case plainText
}

class TextViewModel : ObservableObject {
    
    @Published var fieldValue: String

    var fieldValueType : FieldValueType
    var isVisible = true
    var styling: String
    
    init(fieldValueType: FieldValueType, fieldValue: String, styling: String) {
        self.fieldValue = fieldValue
        self.fieldValueType = fieldValueType
        self.styling = styling
    }
}

struct TextView: View {
    
    @ObservedObject var vm : TextViewModel

    let componentType: ComponentType = .text
    var scope: String
    var rule: Rule
    
    var text: Text {
        var text = Text(vm.fieldValue)
        text = text.font(.title)
        return text
    }
    
    var body: some View {
        if vm.fieldValueType == .markdownText {
            let data = Data(base64Encoded: vm.fieldValue) ?? Data()
            CHMarkdownDefaultView(text: String(data: data, encoding: .utf8) ?? "")
        }else {
            text
        }
    }
}

extension TextView : UIComponent {
    var isVisibile: Bool {
        get {
            vm.isVisible
        }
        set {
            vm.isVisible = newValue
        }
    }
    
    
    func render() -> AnyView {
        TextView(vm: vm, scope: scope, rule: rule).toAnyView()
    }
    
    func getFieldValues() -> JSON {
        return JSON.string(vm.fieldValue)
    }
    
    func getFieldName() -> String {
        return vm.fieldValue
    }
    
    func isRequired() -> Bool {
        return false
    }
}

extension TextView {
    
    static func prepareView(uiSchema: JSON) -> TextView {
    
        let name = uiSchema.label?.stringValue ?? ""
        let scope = uiSchema.scope?.stringValue ?? ""
        let rule = Rule.prepareObject(for: uiSchema)
        
        let viewModel = TextViewModel(fieldValueType: .markdownText, fieldValue: name, styling: "" )
        let view = TextView(vm: viewModel, scope: scope, rule: rule)
        return view
    }
    
}
