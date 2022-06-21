//
//  AddSchoolViewModel.swift
//  ServerDrivenUI
//
//  Created by Venkat Pericharla on 19/06/22.
//

import Foundation
import JSONSchema
import SwiftUI

class AddSchoolViewModel: ObservableObject {
    
    @Published var view = Text("").toAnyView()
    
    init() {
        
        if let jsonSchema = loadSchema(), let uiSchema = loadUISchema() {
            self.view = prepareFormUI(for: jsonSchema, uiSchema: uiSchema)
        }
    }
    
    func loadSchema() -> JSON? {
        
        guard let filePath = Bundle.main.path(forResource: "JsonSchema", ofType: "json") else {return nil}
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let json = try JSONDecoder().decode(JSON.self, from: data)
            return json
        } catch { return nil }
    }
    
    func loadUISchema() -> JSON? {
        
        guard let filePath = Bundle.main.path(forResource: "UISchema", ofType: "json") else { return nil}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let json = try JSONDecoder().decode(JSON.self, from: data)
            return json
        }catch {return nil}
    }
    
    func prepareFormUI(for schema: JSON, uiSchema: JSON) -> AnyView {
        let formCreator = JsonFormCreator(schema: schema, uiSchema: uiSchema)
        return formCreator.prepareForm()
    }
    
}
