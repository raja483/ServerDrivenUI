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
    private var formCreator: JsonFormCreator?
    
    init() {
        
        if let jsonSchema = loadSchema(), let uiSchema = loadUISchema() {
            self.view = prepareFormUI(for: jsonSchema, uiSchema: uiSchema)
        }
        
        NotificationCenter.default.addObserver(forName: VALUE_CHANGE_NOTIF, object: nil, queue: .current) { notif in
            self.reloadLayout()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func reloadLayout() {
        if let updatedView = formCreator?.reloadLayout() {
            view = updatedView
        }
    }
    
    private func loadSchema() -> JSON? {
        
        guard let filePath = Bundle.main.path(forResource: "JsonSchema", ofType: "json") else {return nil}
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let json = try JSONDecoder().decode(JSON.self, from: data)
            return json
        } catch { return nil }
    }
    
    private func loadUISchema() -> JSON? {
        
        guard let filePath = Bundle.main.path(forResource: "UISchema", ofType: "json") else { return nil}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let json = try JSONDecoder().decode(JSON.self, from: data)
            return json
        }catch {return nil}
    }
    
    func prepareFormUI(for schema: JSON, uiSchema: JSON) -> AnyView {
        formCreator = JsonFormCreator(schema: schema, uiSchema: uiSchema)
        return formCreator!.prepareForm()
    }
    
    func getData()-> [String: String]? {
        
        if let formCreator = formCreator {
            
            return formCreator.getFormData()
        }
        return nil
        
    }
}
