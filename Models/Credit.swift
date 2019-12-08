//
//  Credit.swift
//  SwiftUICheatSheet
//
//  Created by Erez Mizrahi on 01/12/2019.
//  Copyright © 2019 Erez Mizrahi. All rights reserved.
//

import Foundation

struct Credit: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
    
}

struct Cast: Codable {
    let character: String?
    let name: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case character
        case name
        case profilePath = "profile_path"
        
    }
}
   
   struct Crew: Codable {
    let department: String?
    var job: String?
    let name: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case department
        case job
        case name
        case profilePath = "profile_path"
    }
   }
