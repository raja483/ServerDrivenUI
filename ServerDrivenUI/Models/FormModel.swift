//
//  FormModel.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 27/04/22.
//

import Foundation

enum ComponentType: String, Codable {
    case text
    case textField
    case textView
    case editText
    case dropdown
    case dateField
    case dateRangeField
    case progressListViewRow
    case none
}

struct Component: Codable {
    let type: ComponentType
    let data: [String: String]
//    func getAnyView() -> UIComponent? {
//        
//        var anyView: UIComponent?
//        switch self.type {
//        case .text:
//            guard let textModel : TextModel = self.data.decode() else {
//                return nil
//            }
//            anyView = TextView(vm: TextViewModel(model: textModel))
//            
//        case .textField:
//            guard let textModel : TextModel = self.data.decode() else {
//                return nil
//            }
//            anyView = TextView(vm: TextViewModel(model: textModel))
////            guard let textFieldModel : TextFieldModel = self.data.decode() else {
////                return nil
////            }
////            anyView = TextFieldView(vm: TextFieldViewModel(model: textFieldModel))
//        case .dateField:
//            
//            guard let dateFieldModel : DateFieldModel = self.data.decode() else {
//                return nil
//            }
//            anyView = DateFieldView(vm: DateFieldViewModel(model: dateFieldModel))
//            
//        case .dropdown:
//            
//            guard let dropdownModel : DropdownModel = self.data.decode() else {
//                return nil
//            }
////            anyView = DropdownView(vm: DropdownViewModel(model: dropdownModel))
//        
//        case .dateRangeField:
//            
//            guard let dateRangeModel : DateRangeFieldModel = self.data.decode() else {
//                return nil
//            }
//            anyView = DateRangeFieldView(vm: DateRangeFieldViewModel(model: dateRangeModel))
//            
//        case .progressListViewRow:
//            
//            guard let viewModel : ProgressListViewRowModel = self.data.decode() else {
//                return nil
//            }
//            anyView = ProgressListViewRow(vm: ProgressListViewRowViewModel(model: viewModel))
//            
//        default:
//            print("default")
//        }
//        
//        return anyView
//    }
    
    func componentName() -> String {
        return self.data["fieldName"] ?? ""
    }
}

enum FormType: String, Codable {
    case steps
    case guidance
    case addAScheduledVisit
    case none
}

struct FormModel: Codable {
    var pageTitle: String = ""
    var pageSubTitle: String?
    var pageType: FormType = .none
    var components: [Component] = []
}


