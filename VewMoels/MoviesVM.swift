//
//  MoviesVM.swift
//  SwiftUICheatSheet
//
//  Created by Erez Mizrahi on 30/11/2019.
//  Copyright © 2019 Erez Mizrahi. All rights reserved.
//

import SwiftUI

struct MoviesVM: Identifiable, Hashable {
    var id = UUID()
    let movieID : Int
    let title: String
    let overView: String
    let image: UIImage
    let rating: CGFloat
   
}

extension MoviesVM {
    init?(dataSource: Results) {
        self.title = dataSource.title ?? ""
        self.overView = dataSource.overview ?? ""
        self.rating = CGFloat(dataSource.voteAverage ?? 0.0) 
        self.movieID = dataSource.id ?? 0
        
        let imageString = "https://image.tmdb.org/t/p/w500/\(dataSource.posterPath ?? "")"
        guard let imageURL = URL(string: imageString) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        self.image = UIImage(data: imageData) ?? UIImage()
    }
}
