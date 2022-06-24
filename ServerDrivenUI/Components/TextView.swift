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

struct TextModel : Codable {
    var fieldValueType : FieldValueType
    var fieldValue: String
    var styling: String
}

class TextViewModel : ObservableObject {
    @Published var model : TextModel
    init(model : TextModel) {
        self.model = model
    }
}

struct TextView: View {
    
    let componentType: ComponentType = .text
    
    @ObservedObject var vm : TextViewModel
    
    var text: Text {
        var text = Text(vm.model.fieldValue)
        text = text.font(.title)
        return text
    }
    
    var body: some View {
        
        if vm.model.fieldValueType == .markdownText {
            let data = Data(base64Encoded: vm.model.fieldValue) ?? Data()
            CHMarkdownDefaultView(text: String(data: data, encoding: .utf8) ?? "")
        }else {
            
            text
        }
    }
}

extension TextView : UIComponent {
    
    func render() -> AnyView {
        TextView(vm: vm).toAnyView()
    }
    
    func getFieldValues() -> String {
        return vm.model.fieldValue
    }
    
    func getFieldName() -> String {
        return "\(vm.model.fieldValue)"
    }
}
