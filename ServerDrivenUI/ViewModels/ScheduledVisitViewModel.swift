//
//  DynamicFormViewModel.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 27/04/22.
//

import Foundation
import SwiftUI

class ScheduledVisitViewModel: ObservableObject {
    
    @Published var formComponents = [UIComponent]()
    @Published var formModel = FormModel()

    func loadData(){
        
        guard let filePath = Bundle.main.path(forResource: "ScheduledVisit", ofType: "json") else {return}
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let formModel = try JSONDecoder().decode(FormModel.self , from: data)
            self.formModel = formModel
            for component in formModel.components {
                
//                if let anyView = component.getAnyView() {
//                    self.formComponents.append(anyView)
//                }
            }
        
        }catch{
            print(error)
        }
    }
    
}
