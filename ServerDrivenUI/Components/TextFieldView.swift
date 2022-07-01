//
//  TextFieldView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 28/04/22.
//

import Foundation
import SwiftUI
import Combine

//struct TextFieldModel : Codable {
//    let fieldName : String
//    var fieldValue : String
//    let hintText: String
//    let isMandatoryField : String
//    let minValue : String
//    let maxValue  : String
//    let inputType : String
//    let validation_status : String
//    let validation_URL : String
//}

class TextFieldViewModel: ObservableObject {
    
//    @Published var model : TextFieldModel
    let fieldName : String
    @Published var fieldValue : String
    let isMandatoryField : Bool
    let hintText: String
        
    @Published var isVisible = true
    var isEnabled = true
    
    init(fieldName: String, fieldValue: String, hintText: String, isMandatoryField: Bool){
        self.fieldName = fieldName
        self.fieldValue = fieldValue
        self.hintText = hintText
        self.isMandatoryField = isMandatoryField
    }
}

struct TextFieldView : View{
    
    let componentType: ComponentType = .textField
    
    @ObservedObject var vm : TextFieldViewModel
    @State var validDataLength : Bool = false
    @State var fieldValue = ""
    
    var scope: String
    var rule: Rule
    
    
    var body : some View {
        
        VStack(alignment : .leading) {
            
            if vm.isVisible {
                
                Text("\(vm.fieldName)\(vm.isMandatoryField ? "*" : "")")
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                
                TextField(vm.hintText, text: $fieldValue)
                    .foregroundColor(validDataLength ? Color(#colorLiteral(red: 0.1334922638, green: 0.2985338713, blue: 0.1076392498, alpha: 1)) : .black)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .frame(height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.leading, .trailing], 8)
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black))
                    .onChange(of: fieldValue) { newValue in
                        
                        NotificationCenter.default.post(name: VALUE_CHANGE_NOTIF, object: newValue)
                    }
            }
        }
        
    }
    
    init(vm: TextFieldViewModel, scope: String, rule: Rule) {
        
        self.vm = vm
        self.fieldValue = vm.fieldValue
        self.scope = scope
        self.rule = rule
    }
}

extension TextFieldView : UIComponent {
   
    
    func render() -> AnyView {
        TextFieldView(vm: vm, scope: scope, rule: rule).toAnyView()
    }
    
    func getFieldValues() -> String {
        return vm.fieldValue
    }
    
    func getFieldName() -> String {
        return "\(vm.fieldName)"
    }
    
    func isRequired() -> Bool {
        let isReq = vm.isMandatoryField
        return isReq
    }
    
    var isVisibile: Bool {
        set{
            vm.isVisible = newValue
        }
        get{
            vm.isVisible
        }
    }
}


extension TextFieldView {
    
    static func prepareView(uiSchema: JSON, isRequired: Bool) -> TextFieldView {
    
        let name = uiSchema.label?.stringValue ?? ""
        let scope = uiSchema.scope?.stringValue ?? ""
        let rule = Rule.prepareObject(for: uiSchema)
        
        let viewModel = TextFieldViewModel(fieldName: name, fieldValue: "", hintText: name, isMandatoryField: false)
        
        let view = TextFieldView(vm: viewModel, scope: scope, rule: rule)
        viewModel.fieldValue = "test"
        return view
    }
    
}
