//
//  DateFieldView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 28/04/22.
//

import Foundation
import SwiftUI
import Combine

class DateFieldViewModel : ObservableObject {
    
    @Published var isVisible = true
    @Published var isEnabled = true

    let fieldName : String
    var fieldValue : Date?
    var isRequired: Bool
    
    init(fieldName: String, isRequired: Bool) {
        self.fieldName = fieldName
        self.isRequired = isRequired
    }
    
}

struct DateFieldView : View{
    
    @ObservedObject var vm : DateFieldViewModel
    
    @State var showDatePicker : Bool = false
    @State var dateSelected = Date()
    
    let componentType: ComponentType = .dateField

    var scope: String
    var rule: Rule
    
    var body : some View{
        
        VStack(alignment : .leading) {
            
            if vm.isVisible {
                Text("\(vm.fieldName)\(vm.isRequired ? "*" : "")")
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                
                HStack {
                    
                    DatePicker("", selection: $dateSelected, displayedComponents: [.date])
                        .disabled(!vm.isEnabled)
                        .pickerStyle(InlinePickerStyle())
                        .onChange(of: dateSelected) { newValue in
                            vm.fieldValue = newValue
                            NotificationCenter.default.post(name: VALUE_CHANGE_NOTIF, object: newValue)
                        }.fixedSize().frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Image(systemName: "chevron.down").padding()
                    
                }
                .frame(height: 44)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
            }
        }
        
    }
}

extension DateFieldView : UIComponent {
    
    var isVisibile: Bool {
        get {
            vm.isVisible
        }
        set {
            vm.isVisible = newValue
        }
    }
    
    func render() -> AnyView {
        DateFieldView(vm: vm, scope: scope, rule: rule).toAnyView()
    }
    
    func getFieldValues() -> JSON {
        
        if let date = vm.fieldValue {
            return JSON.date(date)
        }
        return JSON.null
    }
    
    func getFieldName() -> String {
        return "\(vm.fieldName)"
    }
    
    func isRequired() -> Bool {
        return false
    }
    
}

extension DateFieldView {
    
    static func prepareView(uiSchema: JSON) -> DateFieldView {
        
        let name = uiSchema.label?.stringValue ?? ""
        let scope = uiSchema.scope?.stringValue ?? ""
        let rule = Rule.prepareObject(for: uiSchema)
                
        let viewModel = DateFieldViewModel(fieldName: name, isRequired: false)
        let view = DateFieldView(vm: viewModel, scope: scope, rule: rule)
        return view
    }
    
}
