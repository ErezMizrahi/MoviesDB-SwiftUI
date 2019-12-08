//
//  CrewVM.swift
//  SwiftUICheatSheet
//
//  Created by Erez Mizrahi on 01/12/2019.
//  Copyright © 2019 Erez Mizrahi. All rights reserved.
//

import SwiftUI
struct CastVM: Identifiable, Hashable {
    let id = UUID()
    let character: String
      let name: String
      let image: UIImage
}


extension CastVM {
    init?(dataSource: Cast) {
        self.name = dataSource.name ?? ""
        self.character = dataSource.character ?? ""
        
let imageString = "https://image.tmdb.org/t/p/w500\(dataSource.profilePath ?? "")"
        guard let imageURL = URL(string: imageString) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        self.image = UIImage(data: imageData) ?? UIImage()
}
}
