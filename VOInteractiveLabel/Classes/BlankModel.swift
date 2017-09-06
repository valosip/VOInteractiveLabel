//
//  BlankModel.swift
//  Pods
//
//  Created by Val Osipenko on 9/5/17.
//
//

import Foundation

public struct BlankModel {
    
    public var text: String?
    public var hint: String?
    public var placeholder: String?
    public var type: BlankType!
    public var range: NSRange?
    public var url: String?
    public var attributes: [String : Any]? = [String: Any]()
    public var data: Any?
    
    public init(type: BlankType, text: String?, hint: String?, placeholder: String?, url: String?, attributes: [String : Any]?, data: Any?) {
        
        self.type = type
        self.text = text
        self.hint = hint
        self.placeholder = placeholder
        self.range = nil
        self.url = url
        self.attributes = attributes
        self.data = data
    }
    
    public init(type: BlankType, text: String?, hint: String?, placeholder: String, attributes: [String : Any]?) {
        self.init(type: type, text: text, hint: hint, placeholder: placeholder, url: nil, attributes: attributes, data: nil)
    }
}

public enum BlankType {
    case date
    case string
    case link
    case mention
    case hashtag
}
