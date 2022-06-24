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
                
                let text = vm.model.fieldValue.count == 0 ? vm.model.hintText : vm.model.fieldValue
                let textColor: Color = vm.model.fieldValue.count == 0 ? .gray : .black
                Text(text)
                    .padding(.leading)
                    .foregroundColor(textColor)
                Spacer()
                Image(systemName: "chevron.down").padding()
                
            }
            .frame(height: 44)
            .cornerRadius(5)
            .onTapGesture {
                showDatePicker = !showDatePicker
            }
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
            
            if showDatePicker {
                VStack {
                    
                    DatePicker("", selection: $dateSelected, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .onChange(of: dateSelected) { newValue in
                            let dateFormater = DateFormatter()
                            dateFormater.dateFormat = "dd/MM/yyyy"
                            vm.model.fieldValue = dateFormater.string(from: newValue)
                        }
                }
            }
            
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
