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
    
    @Binding var formData: [String: Any]
    
    init(schema: JSON, uiSchema: JSON, initialData: JSON? = nil, formData: Binding<[String: Any]>) {
        self.schema = schema
        self.uiSchema = uiSchema
        self.initialData = initialData
        self._formData = formData
    }
    
    func prepareForm() -> AnyView {
        
        let title = schema.title?.stringValue ?? ""
        let formManager = FormLayoutManager(schema: schema, formData: $formData)
        let view = formManager.prepareLayout(uiSchema: uiSchema)
        
        return ScrollView {
            VStack {
                view
            }.padding([.leading, .trailing])
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toAnyView()
    }
    
    
}
