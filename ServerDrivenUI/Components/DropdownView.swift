//
//  DropdownView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 30/04/22.
//

import SwiftUI

struct DropdownModel : Codable {
    let fieldName : String
    let hintText: String
    var fieldValue : String
    var isMandatoryField : String
    var dropdownData: String
}

class DropdownViewModel : ObservableObject{
    @Published var model : DropdownModel
    
    init(model : DropdownModel){
        self.model = model
    }
    
}

struct DropdownView : View {
    
    @ObservedObject var vm : DropdownViewModel
    @State var showPicker = false
    @State var selectedValue = ""
    let componentType: ComponentType = .dropdown
    
    var body : some View {
        
        VStack{
            
            VStack(alignment : .leading) {
                
                Text("\(vm.model.fieldName)\(vm.model.isMandatoryField == "true" ? "*" : "")")
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
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                
                
            }
            .onTapGesture {
                showPicker = !showPicker
            }
            
            if showPicker {
                
                VStack {
                    
                    Picker("",selection: $selectedValue){
                        ForEach(vm.model.dropdownData.components(separatedBy: ","), id:\.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onChange(of: selectedValue) { newValue in
                        vm.model.fieldValue = newValue
                    }
                    Divider()
                }
            }
            
        }
        .padding()
        
    }
}

extension DropdownView : UIComponent {
    
    func render() -> AnyView {
        DropdownView(vm: vm).toAnyView()
    }
    
    func getFieldValues() -> String {
        return vm.model.fieldValue
    }
    
}
