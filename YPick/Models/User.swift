//
//  User.swift
//  YPick
//
//  Created by Chris Moreira on 12/2/23.
//

import Foundation


struct User: Identifiable, Codable{
    let id: String
    let fullname: String
    let email: String
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        if let componets = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from:componets)
            
        }
        return ""
    }
    
}


extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Christopher Moreira", email: "test@gmail.com")
}
