//
//  JsonFormCreator.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 20/06/22.
//

import Foundation
import SwiftUI

class JsonFormCreator {
    
   private let schema: JSON
   private let uiSchema: JSON
   private let initialData: JSON?
    
    init(schema: JSON, uiSchema: JSON, initialData: JSON? = nil) {
        self.schema = schema
        self.uiSchema = uiSchema
        self.initialData = initialData
    }

    func prepareForm() -> AnyView {
        
        let formManager = FormLayoutManager(schema: schema)
        let view = formManager.prepareLayout(uiSchema: uiSchema)
    
        return ScrollView {
            VStack {
                view
            }.padding([.leading, .trailing])
        }.toAnyView()
    }
    
    
}
