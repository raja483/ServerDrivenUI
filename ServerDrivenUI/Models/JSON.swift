//
//  JSON.swift
//  CollegeHound
//
//  Created by Edward Psyk on 5/24/22.
//  Copyright © 2022 CollegeHound LLC. All rights reserved.
//

import Foundation

/// A JSON value representation. This is a bit more useful than the naïve `[String:Any]` type
/// for JSON values, since it makes sure only valid JSON values are present & supports `Equatable`
/// and `Codable`, so that you can compare values for equality and code and decode them into data
/// or strings.
@dynamicMemberLookup public enum JSON: Equatable {
    case string(String)
    case number(Double)
    case object([String:JSON])
    case array([JSON])
    case bool(Bool)
    case date(Date)
    case null
}

extension JSON: Codable {

    public func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()

        switch self {
        case let .array(array):
            try container.encode(array)
        case let .object(object):
            try container.encode(object)
        case let .string(string):
            try container.encode(string)
        case let .number(number):
            try container.encode(number)
        case let .bool(bool):
            try container.encode(bool)
        case let .date(date):
            try container.encode(date)
        case .null:
            try container.encodeNil()
        }
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()

        if let object = try? container.decode([String: JSON].self) {
            self = .object(object)
        } else if let array = try? container.decode([JSON].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let date = try? container.decode(Date.self) {
            self = .date(date)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Invalid JSON value.")
            )
        }
    }
}

extension JSON: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .string(let str):
            return str.debugDescription
        case .number(let num):
            return num.debugDescription
        case .bool(let bool):
            return bool.description
        case .date(let date):
            return date.description
        case .null:
            return "null"
        default:
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            return try! String(data: encoder.encode(self), encoding: .utf8)!
        }
    }
}

extension JSON: Hashable {}

public extension JSON {

    /// Return a new JSON value by merging two other ones
    ///
    /// If we call the current JSON value `old` and the incoming JSON value
    /// `new`, the precise merging rules are:
    ///
    /// 1. If `old` or `new` are anything but an object, return `new`.
    /// 2. If both `old` and `new` are objects, create a merged object like this:
    ///     1. Add keys from `old` not present in `new` (“no change” case).
    ///     2. Add keys from `new` not present in `old` (“create” case).
    ///     3. For keys present in both `old` and `new`, apply merge recursively to their values (“update” case).
    func merging(with new: JSON) -> JSON {

        // If old or new are anything but an object, return new.
        guard case .object(let lhs) = self, case .object(let rhs) = new else {
            return new
        }

        var merged: [String: JSON] = [:]

        // Add keys from old not present in new (“no change” case).
        for (key, val) in lhs where rhs[key] == nil {
            merged[key] = val
        }

        // Add keys from new not present in old (“create” case).
        for (key, val) in rhs where lhs[key] == nil {
            merged[key] = val
        }

        // For keys present in both old and new, apply merge recursively to their values.
        for key in lhs.keys where rhs[key] != nil {
            merged[key] = lhs[key]?.merging(with: rhs[key]!)
        }

        return JSON.object(merged)
    }
}

public extension JSON {

    /// Return the string value if this is a `.string`, otherwise `nil`
    var stringValue: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }

    /// Return the double value if this is a `.number`, otherwise `nil`
    var doubleValue: Double? {
        if case .number(let value) = self {
            return value
        }
        return nil
    }

    /// Return the bool value if this is a `.bool`, otherwise `nil`
    var boolValue: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    /// Return the bool value if this is a `.bool`, otherwise `nil`
    var dateValue: Date? {
        if case .date(let value) = self {
            return value
        }
        return nil
    }

    /// Return the object value if this is an `.object`, otherwise `nil`
    var objectValue: [String: JSON]? {
        if case .object(let value) = self {
            return value
        }
        return nil
    }

    /// Return the array value if this is an `.array`, otherwise `nil`
    var arrayValue: [JSON]? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }

    /// Return `true` iff this is `.null`
    var isNull: Bool {
        if case .null = self {
            return true
        }
        return false
    }

    /// If this is an `.array`, return item at index
    ///
    /// If this is not an `.array` or the index is out of bounds, returns `nil`.
    subscript(index: Int) -> JSON? {
        if case .array(let arr) = self, arr.indices.contains(index) {
            return arr[index]
        }
        return nil
    }

    /// If this is an `.object`, return item at key
    subscript(key: String) -> JSON? {
        if case .object(let dict) = self {
            return dict[key]
        }
        return nil
    }

    /// Dynamic member lookup sugar for string subscripts
    ///
    /// This lets you write `json.foo` instead of `json["foo"]`.
    subscript(dynamicMember member: String) -> JSON? {
        return self[member]
    }
    
    /// Return the JSON type at the keypath if this is an `.object`, otherwise `nil`
    ///
    /// This lets you write `json[keyPath: "foo.bar.jar"]`.
    subscript(keyPath keyPath: String) -> JSON? {
        return queryKeyPath(keyPath.components(separatedBy: "."))
    }
    
    func queryKeyPath<T>(_ path: T) -> JSON? where T: Collection, T.Element == String {
        
        // Only object values may be subscripted
        guard case .object(let object) = self else {
            return nil
        }
        
        // Is the path non-empty?
        guard let head = path.first else {
            return nil
        }
        
        // Do we have a value at the required key?
        guard let value = object[head] else {
            return nil
        }
        
        let tail = path.dropFirst()
        
        return tail.isEmpty ? value : value.queryKeyPath(tail)
    }
    
}
