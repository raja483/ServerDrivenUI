//
//  DateRangeFieldView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 01/05/22.
//

import SwiftUI

class DateRangeFieldViewModel : ObservableObject {
    
    @Published var isVisibile = true
    
    var startDate = Date()
    var endDate = Date()
    
    var fieldName: String
    var isRequired: Bool
    var isEnabled = true
    
    init(fieldName: String, isRequired: Bool){
        self.fieldName = fieldName
        self.isRequired = isRequired
    }
    
}

struct DateRangeFieldView : View{
    
    @ObservedObject var vm : DateRangeFieldViewModel
    @State var startDate = Date()
    @State var endDate = Date()
        
    let componentType: ComponentType = .dateRangeField
    var scope: String
    var rule: Rule
    
    var body : some View {
        
        VStack(alignment : .leading) {
            VStack(alignment: .leading) {
            Text("\(vm.fieldName)\(vm.isRequired ? "*" : "")")
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(.black)
            
            HStack {
                
                //Start Date
                HStack {
                    
                    DatePicker("", selection: $startDate, displayedComponents: [.date])
                        .disabled(!vm.isEnabled)
                        .pickerStyle(InlinePickerStyle())
                        .onChange(of: startDate) { newValue in
                            vm.startDate = newValue
                            NotificationCenter.default.post(name: VALUE_CHANGE_NOTIF, object: newValue)
                        }.fixedSize().frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Image(systemName: "chevron.down").padding()
                    
                }
                .frame(height: 44)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                
                // End Date
                HStack {
                    
                    DatePicker("", selection: $endDate, displayedComponents: [.date])
                        .disabled(!vm.isEnabled)
                        .pickerStyle(InlinePickerStyle())
                        .onChange(of: endDate) { newValue in
                            vm.endDate = newValue
                            NotificationCenter.default.post(name: VALUE_CHANGE_NOTIF, object: newValue)
                        }.fixedSize().frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Image(systemName: "chevron.down").padding()
                    
                }
                .frame(height: 44)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                
            }
            }.padding()
            
        }

    }
}

extension DateRangeFieldView : UIComponent {
    
    var isVisibile: Bool {
        get {
            vm.isVisibile
        }
        set {
            vm.isVisibile = newValue
        }
    }
    
    func render() -> AnyView {
        DateRangeFieldView(vm: vm, scope: scope, rule: rule).toAnyView()
    }
    
    func getFieldValues() -> JSON {
        let obj = JSON.object(["startDate": JSON.date(startDate), "endDate": JSON.date(endDate)])
        return obj
    }
    
    func getFieldName() -> String {
        return vm.fieldName
    }
    
    func isRequired() -> Bool {
        return false
    }
}
