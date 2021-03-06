//
//  DateFieldView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 28/04/22.
//

import Foundation
import SwiftUI
import Combine

struct DateFieldModel : Codable{
    let fieldName : String
    var fieldValue : String
    let hintText: String
    var isMandatoryField : String
    let minValue : String
    let maxValue  : String
}

class DateFieldViewModel : ObservableObject {
    
    @Published var model : DateFieldModel
    
    var date = Date()
    
    init(model : DateFieldModel){
        self.model = model
    }
    
}

struct DateFieldView : View{
    
    let componentType: ComponentType = .dateField

    @ObservedObject var vm : DateFieldViewModel
    @State var showDatePicker : Bool = false
    
    @State var dateSelected = Date()
    
    var body : some View{
        
        VStack(alignment : .leading) {
            
            Text("\(vm.model.fieldName)\(vm.model.isMandatoryField == "1" ? "*" : "")")
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(.black)
            
            HStack {
                
                DatePicker("", selection: $dateSelected, displayedComponents: [.date])
                                  .pickerStyle(InlinePickerStyle())
                                  .onChange(of: dateSelected) { newValue in
                                      let dateFormater = DateFormatter()
                                      dateFormater.dateFormat = "dd/MM/yyyy"
                                      vm.model.fieldValue = dateFormater.string(from: newValue)
                                  }.fixedSize().frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "chevron.down").padding()
                
            }
            .frame(height: 44)
            .cornerRadius(5)
            .onTapGesture {
                //showDatePicker = !showDatePicker
            }
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
            
            
        }
        .padding()
    }
}

extension DateFieldView : UIComponent {
    
    func render() -> AnyView {
        DateFieldView(vm: vm).toAnyView()
    }
    
    func getFieldValues() -> String {
        return vm.model.fieldValue
    }
    func getFieldName() -> String {
        return "\(vm.model.fieldName)"
    }
    
    func isRequired() -> Bool {
        return false
    }
    
}

extension DateFieldView {
    
    static func prepareView(json: JSON) -> DateFieldView {
        
        let name = json.label?.stringValue ?? ""
        let model = DateFieldModel(fieldName: name, fieldValue: "", hintText: "", isMandatoryField: "", minValue: "", maxValue: "")
        let viewModel = DateFieldViewModel(model: model)
        let view = DateFieldView(vm: viewModel)
        return view
    }
    
}
