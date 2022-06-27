//
//  DateRangeFieldView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 01/05/22.
//

import SwiftUI

struct DateRangeFieldModel : Codable{
    let fieldName: String
    var startdate: String
    var endData: String
    let startDateHint: String
    let endDateHint: String
    var isMandatoryField : String
    let minValue: String
    let maxValue: String
}

class DateRangeFieldViewModel : ObservableObject{
    @Published var model : DateRangeFieldModel
    
    var date = Date()
    
    init(model : DateRangeFieldModel){
        self.model = model
    }
    
}

struct DateRangeFieldView : View{
    
    @ObservedObject var vm : DateRangeFieldViewModel
    @State var showStartDatePicker : Bool = false
    @State var showEndDatePicker : Bool = false

    @State var selectedDate = Date()
        
    let componentType: ComponentType = .dateRangeField

    var body : some View{
        
        VStack(alignment : .leading){
            VStack(alignment: .leading) {
            Text("\(vm.model.fieldName)\(vm.model.isMandatoryField == "1" ? "*" : "")")
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(.black)
            
            HStack {
                
                HStack {
                    let text = vm.model.startdate.count == 0 ? vm.model.startDateHint : vm.model.startdate
                    let textColor: Color = vm.model.startdate.count == 0 ? .gray : .black
                    Text(text)
                        .padding(.leading)
                        .foregroundColor(textColor)
                    
                    Spacer()
                    Image(systemName: "chevron.down").padding()
                }
                .frame(height: 44)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                .onTapGesture {
                    showEndDatePicker = false
                    showStartDatePicker = !showStartDatePicker
                }
                
                HStack {
                    let text = vm.model.endData.count == 0 ? vm.model.endDateHint : vm.model.endData
                    let textColor: Color = vm.model.endData.count == 0 ? .gray : .black
                    Text(text)
                        .padding(.leading)
                        .foregroundColor(textColor)
                    
                    Spacer()
                    Image(systemName: "chevron.down").padding()
                }
                .frame(height: 44)
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                .onTapGesture {
                    showStartDatePicker = false
                    showEndDatePicker = !showEndDatePicker
                }
                
            }
            }.padding()
            
            if showStartDatePicker || showEndDatePicker {
                VStack {
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .onChange(of: selectedDate) { newValue in
                            let dateFormater = DateFormatter()
                            dateFormater.dateFormat = "dd/MM/yyyy"
                            
                            if showEndDatePicker {
                                vm.model.endData = dateFormater.string(from: newValue)
                            }else {
                                vm.model.startdate = dateFormater.string(from: newValue)
                            }
                            
                        }
                    
                }.padding()
            }
        }

    }
}

extension DateRangeFieldView : UIComponent {
    
    func render() -> AnyView {
        DateRangeFieldView(vm: vm).toAnyView()
    }
    
    func getFieldValues() -> String {
        return "\(vm.model.startdate),\(vm.model.endData)"
    }
    func getFieldName() -> String {
        return "\(vm.model.fieldName)"
    }
    func isRequired() -> Bool {
        return false
    }
}
