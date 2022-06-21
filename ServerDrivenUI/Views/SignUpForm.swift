//
//  ServerDrivenForm.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 27/04/22.
//

import SwiftUI
import Resolver

struct ScheduledVisit: View {
    
    @InjectedObject var viewModel: DynamicFormViewModel
    
    var body: some View {
        
        ForEach (viewModel.formComponents, id:\.uniqueId){ component in
            component.render()
        }
        
    }
    
    init() {
        viewModel.loadData()
    }
}

struct ServerDrivenForm_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledVisit()
    }
}
