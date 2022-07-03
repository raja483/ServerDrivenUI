//
//  TextFieldView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 28/04/22.
//

import Foundation
import SwiftUI
import Combine

class TextFieldViewModel: ObservableObject {
    
    @Published var fieldValue : String
    @Published var isVisible = true
    @Published var isEnabled = true
    
    let isRequired : Bool
    let fieldName : String
    let hintText: String
        
    init(fieldName: String, fieldValue: String, hintText: String, isRequired: Bool) {
        self.fieldName = fieldName
        self.fieldValue = fieldValue
        self.hintText = hintText
        self.isRequired = isRequired
    }
}

struct TextFieldView : View{
        
    @ObservedObject var vm : TextFieldViewModel
    @State var validDataLength : Bool = false
    @State var fieldValue = ""
    
    let componentType: ComponentType = .textField

    var scope: String
    var rule: Rule
    
    var body : some View {
        
        VStack(alignment : .leading) {
            
            if vm.isVisible {
                
                Text("\(vm.fieldName)\(vm.isRequired ? "*" : "")")
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                
                TextField(vm.hintText, text: $fieldValue)
                    .disabled(!vm.isEnabled)
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
        self.rule = rule
        self.scope = scope
        self.fieldValue = vm.fieldValue
    }
}

extension TextFieldView : UIComponent {
   
    func render() -> AnyView {
        TextFieldView(vm: vm, scope: scope, rule: rule).toAnyView()
    }
    
    func getFieldValues() -> JSON {
        return  JSON.string(vm.fieldValue)
    }
    
    func getFieldName() -> String {
        return "\(vm.fieldName)"
    }
    
    func isRequired() -> Bool {
        let isReq = vm.isRequired
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
        let rule = Rule.prepareObject(for: uiSchema)
        let scope = uiSchema.scope?.stringValue ?? ""

        let viewModel = TextFieldViewModel(fieldName: name, fieldValue: "", hintText: name, isRequired: false)
        
        let view = TextFieldView(vm: viewModel, scope: scope, rule: rule)
        viewModel.fieldValue = "test"
        return view
    }
    
}
