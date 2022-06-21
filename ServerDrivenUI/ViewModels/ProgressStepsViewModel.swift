//
//  ProgressStepsViewModel.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 06/05/22.
//

import Foundation
import SwiftUI

class ProgressStepsViewModel: ObservableObject {
    
    @Published var formModel: FormModel? = nil
    @Published var components: [UIComponent] = []
    
    func loadData() {
        
        guard let filePath = Bundle.main.path(forResource: "ProgressSteps", ofType: "json") else {return}
        
        let url = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: url)
            let form = try JSONDecoder().decode(FormModel.self, from: data)
            
            for component in form.components {
                
                if let cmp = component.getAnyView() {
                    self.components.append(cmp)
                }
            }
            
        } catch {}
    }
}
