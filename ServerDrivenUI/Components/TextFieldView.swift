//
//  TextFieldView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 28/04/22.
//

import Foundation
import SwiftUI
import Combine

struct TextFieldModel : Codable{
    let fieldName : String
    var fieldValue : String
    let hintText: String
    let isMandatoryField : String
    let minValue : String
    let maxValue  : String
    let inputType : String
    let validation_status : String
    let validation_URL : String
}

class TextFieldViewModel : ObservableObject{
    @Published var model : TextFieldModel
    
    init(model : TextFieldModel){
        self.model = model
    }
}

struct TextFieldView : View{
    
    let componentType: ComponentType = .textField

    @ObservedObject var vm : TextFieldViewModel
    @State var validDataLength : Bool = false
    
    @Binding var formData: [String: Any]
    @State private var fieldValue: String = ""
   
    var body : some View {
        
        VStack(alignment : .leading) {
            
            Text("\(vm.model.fieldName)\(vm.model.isMandatoryField == "true" ? "*" : "")")
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(.black)
            
            TextField(vm.model.hintText, text: $fieldValue)
                .onChange(of: fieldValue, perform: { newValue in
                    formData[vm.model.fieldName] = newValue
                    
                    print(formData)
                })
                .foregroundColor(validDataLength ? Color(#colorLiteral(red: 0.1334922638, green: 0.2985338713, blue: 0.1076392498, alpha: 1)) : .black)
                .font(.system(size: 16, weight: .regular, design: .default))
                .frame(height: 40)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.leading, .trailing], 8)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black))
        }
        .padding()
    }
}

extension TextFieldView : UIComponent {
    
    func render() -> AnyView {
        TextFieldView(vm: vm, formData: $formData).toAnyView()
    }
    
    func getFieldValues() -> String {
        return vm.model.fieldValue
    }
}


extension TextFieldView {
    
    static func prepareView(json: JSON, formData: Binding<[String: Any]>) -> TextFieldView {
        
        let name = json.label?.stringValue ?? ""
        
        let model = TextFieldModel(fieldName: name, fieldValue: "", hintText: name, isMandatoryField: "", minValue: "", maxValue: "", inputType: "", validation_status: "", validation_URL: "")
        
        let viewModel = TextFieldViewModel(model: model)
        let view = TextFieldView(vm: viewModel, formData: formData)
        
        return view
    }
    
}
