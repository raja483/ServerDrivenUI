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
        CHTextEditor(vm: vm).toAnyView()
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
        let text = """
        Styling a view is the most important part of building beautiful user interfaces. When it comes to the actual code syntax, we want reusable, customizable and clean solutions in our code.

        This article will show you these 3 ways of styling a `SwiftUI.View`:

        1. Initializer-based configuration
        2. Method chaining using return-self
        3. Styles in the Environment
        """
        let model = CHTextEditorModel(fieldValueType: .markdownText, fieldName:name, fieldValue: text, styling: "")
        let viewModel = CHTextEditorViewModel(model: model)
        
        let view = CHTextEditor(vm: viewModel)
        return view
    }
    
}

