//
//  DropdownView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 30/04/22.
//

import SwiftUI

class DropdownViewModel : ObservableObject{
    
    @Published var isVisible = true

    let fieldName : String
    let hintText: String
    var fieldValue : String
    var isRequired : Bool
    var dropdownData: String
    
    init(fieldName: String, hintText: String, fieldValue: String, isRequired: Bool, dropdownData: String) {
        self.fieldName = fieldName
        self.hintText = hintText
        self.fieldValue = fieldValue
        self.isRequired = isRequired
        self.dropdownData = dropdownData
    }
    
}

struct DropdownView : View {
    
    @ObservedObject var vm : DropdownViewModel
    @State var showPicker = false
    @State var selectedValue = ""
    let componentType: ComponentType = .dropdown
    
    var scope: String
    var rule: Rule
    
    var body : some View {
        
        VStack {
            
            if isVisibile {
            VStack(alignment : .leading) {
                
                Text("\(vm.fieldName)\(vm.isRequired ? "*" : "")")
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                
                HStack {
                    
                    let text = vm.fieldValue.count == 0 ? vm.hintText : vm.fieldValue
                    let textColor: Color = vm.fieldValue.count == 0 ? .gray : .black
                    Text(text)
                        .padding(.leading)
                        .foregroundColor(textColor)
                    Spacer()
                    Image(systemName: "chevron.down").padding()
                }
                .frame(height: 44)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                
                
            }
            .onTapGesture {
                showPicker = !showPicker
            }
            
            if showPicker {
                
                VStack {
                    
                    Picker("",selection: $selectedValue){
                        ForEach(vm.dropdownData.components(separatedBy: ","), id:\.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onChange(of: selectedValue) { newValue in
                        vm.fieldValue = newValue
                        NotificationCenter.default.post(name: VALUE_CHANGE_NOTIF, object: newValue)
                    }
                    Divider()
                }
            }
            }
        }
        
        
    }
}

extension DropdownView : UIComponent {
    var isVisibile: Bool {
        get {
            vm.isVisible
        }
        set {
            vm.isVisible = newValue
        }
    }
    
    func render() -> AnyView {
        DropdownView(vm: vm, scope: scope, rule: rule).toAnyView()
    }
    
    func getFieldValues() -> JSON {
        return JSON.string(vm.fieldValue)
    }
    
    func getFieldName() -> String {
        return "\(vm.fieldName)"
    }
    
    func isRequired() -> Bool {
        return false
    }
    
}

extension DropdownView {
    
    static func prepareView(schema: JSON, json: JSON) -> DropdownView {
        
        let name = schema.label?.stringValue ?? ""
        let data = json.enum?.arrayValue ?? []
        
        let scope = schema.scope?.stringValue ?? ""
        let rule = Rule.prepareObject(for: schema)
        
        let dropDownValues =  data.map { $0.stringValue ?? "" }.joined(separator: ",")
        let viewModel = DropdownViewModel(fieldName: name, hintText: name, fieldValue: "", isRequired: false, dropdownData: dropDownValues)
        let view = DropdownView(vm: viewModel, scope: scope, rule: rule)
        return view
    }
    
}
