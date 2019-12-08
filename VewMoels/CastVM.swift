//
//  CastVM.swift
//  SwiftUICheatSheet
//
//  Created by Erez Mizrahi on 01/12/2019.
//  Copyright © 2019 Erez Mizrahi. All rights reserved.
//

import SwiftUI

struct CrewVM: Identifiable, Hashable {
    let id = UUID() 
    let department: String
    var job: String
    let name: String
    let image: UIImage
}


extension CrewVM {
    init?(dataSource: Crew) {
        self.department = dataSource.department ?? ""
        self.job = dataSource.job ?? ""
        self.name = dataSource.name ?? ""
        
        let imageString = "https://image.tmdb.org/t/p/w500\(dataSource.profilePath ?? "")"
        guard let imageURL = URL(string: imageString) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        self.image = UIImage(data: imageData) ?? UIImage()
    }
}
