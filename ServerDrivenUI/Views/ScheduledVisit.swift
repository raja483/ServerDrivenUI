//
//  ServerDrivenForm.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 27/04/22.
//

import SwiftUI
import Resolver

struct ScheduledVisit: View {
    
    var viewModel: ScheduledVisitViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showDatePicker = false
    @State var showSuccessView = false
    
    var body: some View {
        //        GeometryReader { geometry in
        Divider()
        ScrollView {
            VStack {
                ForEach (viewModel.formComponents, id:\.uniqueId){ component in
                    component.render()
                }
                NavigationLink(isActive: $showSuccessView) {
                    SuccessView(viewModel: getViewModelForSuccessView())
                } label: {
                    Button("Done"){
                        showSuccessView = true
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.size.width - 60 ,height: 44)
                    .background(Color.doneButton)
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.clear))
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.formModel.pageTitle).font(.headline)
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancle"){
                    self.presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.gray)
            }
        }
        //            }
        
    }
    
    init(viewModel: ScheduledVisitViewModel) {
        self.viewModel = viewModel
        self.viewModel.loadData()
    }
    
    
    func getViewModelForSuccessView() -> SuccessViewModel {
        
        var vm = SuccessViewModel()
        
        for (i, model) in viewModel.formComponents.enumerated() {
            
            let str = model.getFieldValues()
            let fieldName = viewModel.formModel.components[i].componentName()
            
            switch model.componentType {
                
            case .textField:
                if fieldName == "Tour Start Location" {
                    vm.startLocation = str.stringValue ?? ""
                }else{
                    vm.parkingLocation = str.stringValue ?? ""
                }
            case .dropdown:
                vm.fromWhichScool = str.stringValue ?? ""
                
            case .dateField:
                vm.tourDate = "" //(str.dateValue ?? Date())

            case .dateRangeField:
//                let array = str.components(separatedBy: ",")
                vm.startDate = "" //array.first ?? ""
                vm.endDate = "" //array.last ?? ""
                
            default:
                print("")
            }
            
        }
        
        return vm
    }
    
}

