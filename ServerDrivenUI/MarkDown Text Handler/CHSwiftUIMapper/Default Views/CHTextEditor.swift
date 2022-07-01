//
//  CHTextEditor.swift
//  ServerDrivenUI
//
//  Created by admin on 26/06/22.
//

import SwiftUI

struct CHTextEditorModel : Codable{
    var fieldValueType : FieldValueType
    let fieldName : String
    var fieldValue: String
    var styling: String
}

class CHTextEditorViewModel : ObservableObject{
    @Published var model : CHTextEditorModel
    
    init(model : CHTextEditorModel){
        self.model = model
    }
}

struct CHTextEditor: View {
    
    @ObservedObject var vm: CHTextEditorViewModel
    let componentType: ComponentType = .editText
    var scope: String
    var rule: Rule
    
    var body: some View {
       
        Text("\(vm.model.fieldName)")
            .font(.system(size: 14, weight: .semibold, design: .default))
            .foregroundColor(.black)
        TextEditor(text: $vm.model.fieldValue)
            .padding([.all],10)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black))
            
    }
}

extension CHTextEditor: UIComponent {
    func getFieldName() -> String {
        
        return ""
    }
    
    func getFieldValues() -> JSON {
        JSON.string(vm.model.fieldValue)
    }
    
    func render() -> AnyView {
        CHTextEditor(vm: vm, scope: scope, rule: rule).toAnyView()
    }
    
    func getFieldValues() -> String {
        return vm.model.fieldValue
    }
    
    func isRequired() -> Bool {
        return false
    }
}
extension CHTextEditor {
    
    static func prepareView(uiSchema: JSON) -> CHTextEditor {
    
        let name = uiSchema.label?.stringValue ?? ""
        let scope = uiSchema.scope?.stringValue ?? ""
        let rule = Rule.prepareObject(for: uiSchema)
        
        let model = CHTextEditorModel(fieldValueType: .plainText, fieldName:name, fieldValue: "", styling: "")
        let viewModel = CHTextEditorViewModel(model: model)
        
        let view = CHTextEditor(vm: viewModel, scope: scope, rule: rule)
        return view
    }
    
}

