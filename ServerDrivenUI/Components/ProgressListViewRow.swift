//
//  StepsRow.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 05/05/22.
//

import Foundation
import SwiftUI

struct ProgressListViewRowModel : Codable {
    let fieldValue : String
    let title: String
    let subTitle: String
}

class ProgressListViewRowViewModel : ObservableObject{
    @Published var model : ProgressListViewRowModel

    init(model : ProgressListViewRowModel){
        self.model = model
    }
}

struct ProgressListViewRow : View {
    
    @ObservedObject var vm : ProgressListViewRowViewModel
    @State var selectedValue = ""
    let componentType: ComponentType = .progressListViewRow
    
    var body : some View {
        
        HStack {
            
            Image(systemName: vm.model.fieldValue == "" ? "circle" : "circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(getCircleColor(for: vm.model.fieldValue))
            
            VStack(alignment: .leading) {
                Text(vm.model.title)
                    .font(.headline).padding()
                if vm.model.subTitle.count > 0 {
                    Text(vm.model.subTitle).padding()
                }
            }
        }
    }
    
    func getCircleColor(for status: String) -> Color {
        return  status == "" ? .gray : .blue
    }
}

extension ProgressListViewRow : UIComponent {
    
    func render() -> AnyView {
        ProgressListViewRow(vm: vm).toAnyView()
    }
    
    func getFieldValues() -> String {
        return vm.model.fieldValue
    }
    
    func getFieldName() -> String {
        return "\(vm.model.fieldValue)"
    }
    
    func isRequired() -> Bool {
        return false
    }
    
}
