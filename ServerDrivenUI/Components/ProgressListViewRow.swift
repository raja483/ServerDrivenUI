//
//  StepsRow.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 05/05/22.
//

import Foundation
import SwiftUI

class ProgressListViewRowViewModel : ObservableObject{
    
    @Published var isVisible = true

    let fieldValue : String
    let title: String
    let subTitle: String
    
    init(title: String, subTitle: String, fieldValue: String) {
        self.title = title
        self.subTitle = subTitle
        self.fieldValue = fieldValue
    }
}

struct ProgressListViewRow : View {
    
    @ObservedObject var vm : ProgressListViewRowViewModel
    @State var selectedValue = ""
    
    let componentType: ComponentType = .progressListViewRow
    var scope: String
    var rule: Rule
    
    var body : some View {
        
        HStack {
            if isVisibile {
                Image(systemName: vm.fieldValue == "" ? "circle" : "circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(getCircleColor(for: vm.fieldValue))
                
                VStack(alignment: .leading) {
                    Text(vm.title)
                        .font(.headline).padding()
                    if vm.subTitle.count > 0 {
                        Text(vm.subTitle).padding()
                    }
                }
            }
        }
    }
    
    func getCircleColor(for status: String) -> Color {
        return  status == "" ? .gray : .blue
    }
}

extension ProgressListViewRow : UIComponent {
    var isVisibile: Bool {
        get {
            vm.isVisible
        }
        set {
            vm.isVisible = newValue
        }
    }
    
    func getFieldValues() -> JSON {
        JSON.string(vm.fieldValue)
    }
    
    func render() -> AnyView {
        ProgressListViewRow(vm: vm, scope: scope, rule: rule).toAnyView()
    }
    
    func getFieldName() -> String {
        return "\(vm.fieldValue)"
    }
    
    func isRequired() -> Bool {
        return false
    }
    
}
