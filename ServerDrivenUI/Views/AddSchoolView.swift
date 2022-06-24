//
//  AddSchoolView.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 19/06/22.
//

import SwiftUI
import Resolver

struct AddSchoolView: View {
    
   @Injected var viewModel: AddSchoolViewModel
    
    var body: some View {
        viewModel.view
        Spacer()
        Button("Done") {
            print(viewModel.formData)
        }.frame(width: 300, height: 44)
    }
}

struct AddSchoolView_Previews: PreviewProvider {
    static var previews: some View {
        AddSchoolView()
    }
}
