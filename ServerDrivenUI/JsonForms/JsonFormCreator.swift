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
    
    private var formManager: FormLayoutManager?
    
    init(schema: JSON, uiSchema: JSON, initialData: JSON? = nil) {
        self.schema = schema
        self.uiSchema = uiSchema
        self.initialData = initialData
    }
    
    func prepareForm() -> AnyView {
        
        let title = schema.title?.stringValue ?? ""
        formManager = FormLayoutManager(schema: schema)
        let view = formManager!.prepareLayout(uiSchema: uiSchema)
        
        return ScrollView {
            VStack {
                view
            }.padding([.leading, .trailing])
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toAnyView()
    }
    
    func getFormData() -> [String: String]? {
        if let formManager = formManager {
           let values = formManager.getFormData()
            return values
        }
        return nil
    }
    
    func reloadLayout() -> AnyView? {
        let view = formManager?.reloadLayout(uiSchema: uiSchema)
        return view
    }
}
