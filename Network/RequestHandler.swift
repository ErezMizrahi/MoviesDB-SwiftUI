//
//  RequestHandler.swift
//  SwiftUICheatSheet
//
//  Created by Erez Mizrahi on 29/11/2019.
//  Copyright © 2019 Erez Mizrahi. All rights reserved.
//

import Foundation
import Combine


enum MovieCategory: String, CaseIterable {
    case PopularMovies = "Popular Movies"
    case LatestMovies = "Latest Movies"
    case topRated = "Top Rated"
}

class Manager: ObservableObject {
    
    static let shared = Manager()
    
    @Published var test : [[MoviesVM]] = []
    
    @Published var catgortys : [MovieCategory] = MovieCategory.allCases

    
    @Published var castModel: [CastVM] = []
    @Published var crewModel: [CrewVM] = []


    
    func parallel() {
        let latest = RequstsApi.getLatestMovies()!
        let popular = RequstsApi.getPopularMovies()!
        let topRated = RequstsApi.getTopRatedMovies()!
        
       let firstCall = Publishers.Zip3(latest, popular, topRated)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { (latest, popular, top) in
                    let vm1 = popular.results.compactMap{MoviesVM.init(dataSource: $0)}
                    let vm2 = latest.results.compactMap{MoviesVM.init(dataSource: $0)}
                    let vm3 = top.results.compactMap{MoviesVM.init(dataSource: $0)}
                    print(vm1, vm2)
                    self.test += [vm1]
                    print(self.test.count)
                    self.test += [vm2]
                    self.test += [vm3]
                    print(self.test.count)

            })
        
        withExtendedLifetime(firstCall, {})

    }
    
    
    func getCredits(id: Int) {
        let cast = RequstsApi.getCast(withID: id)!
        let credits = cast.sink(receiveCompletion: { (_) in
        }) { (credit) in
            let castVM = credit.cast.compactMap{CastVM.init(dataSource: $0)}
            let crewVM = credit.crew.compactMap{CrewVM.init(dataSource: $0)}
         
            self.castModel = castVM
            self.crewModel = crewVM
            print(self.castModel)
        }
        
        withExtendedLifetime(credits, {})
    }
}


struct EndPoint {
    static let url: String = "https://api.themoviedb.org/3"
<<<<<<< HEAD
    static let apiKey: String = "???????"
=======
    static let apiKey: String = "??????????????????"
>>>>>>> e7fe5c9f274fbcbfd8800f63d8b5cbbd406a8813
    
    enum HttpMethods: String {
        case get = "GET"
        case post = "POST"
    }

    let baseUrl: String
    let path: String
    let apiKey: String
    let httpMethod: HttpMethods
    
    static var popularMovies: EndPoint {
        return EndPoint(baseUrl: url, path: "movie/popular", apiKey: apiKey, httpMethod: HttpMethods.get)
    }
    
    static var topRatedMovies: EndPoint {
        return EndPoint(baseUrl: url, path: "movie/top_rated", apiKey: apiKey, httpMethod: HttpMethods.get)
    }
    
    static var inTheatrsMovies: EndPoint {
        return EndPoint(baseUrl: url, path: "movie/now_playing", apiKey: apiKey, httpMethod: .get)
    }
    
}


struct RequestHandler {
    
    enum RequestError: Error {
        case serialze
        case badRequest
        case failedToDecode
    }

    let endpoint: EndPoint
    let params: [String:String]
    let path: String?
    
    init(endPoint: EndPoint,
         params: [String:String] = ["api_key": "?????????????"],
         path: String = "") {
        self.endpoint = endPoint
        self.params = params
        self.path = path
    }
    
}


extension RequestHandler {
struct RequestSerializer {
    func serializeRequest(with request: RequestHandler) -> URLRequest? {
        let endpoint = request.endpoint
        let urlString = [endpoint.baseUrl,
                         endpoint.path]
                        .compactMap{ $0 }.joined(separator: "/")
        
        guard var components = URLComponents(string: urlString) else{ return nil}
            print(components)
            components.queryItems = request.params.compactMap{ URLQueryItem(name: $0.key, value: $0.value) }
        
        
        guard let url = components.url else{ return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        return urlRequest
    }
}
}


extension RequestHandler {
    
    struct HTTPResult {
        let data: Data
        let headers : [String:String]
    }
    
    struct RequestExcuter {
        func fetchRequest<T:Codable>(with request: URLRequest) -> AnyPublisher<T,Error> {
            return RequestAgent.shared.run(request)
                .map(\.data)
            .eraseToAnyPublisher()
        }
    }
}


enum RequstsApi {
    static let serializer = RequestHandler.RequestSerializer()
    static let requestExecuter = RequestHandler.RequestExcuter()

  static func getPopularMovies()-> AnyPublisher<Movies,Error>? {
     let request = RequestHandler(endPoint: .popularMovies)
      if let url = serializer.serializeRequest(with: request) {
         return requestExecuter.fetchRequest(with: url)
     }
    return nil
 }
    
     static func getLatestMovies()-> AnyPublisher<Movies,Error>? {
        let request = RequestHandler(endPoint: .inTheatrsMovies)
         if let url = serializer.serializeRequest(with: request) {
            return requestExecuter.fetchRequest(with: url)
        }
       return nil
    }
    
     static func getTopRatedMovies()-> AnyPublisher<Movies,Error>? {
        let request = RequestHandler(endPoint: .topRatedMovies)
         if let url = serializer.serializeRequest(with: request) {
            return requestExecuter.fetchRequest(with: url)
        }
       return nil
    }
    
    static func getCast(withID id: Int)-> AnyPublisher<Credit,Error>? {
        let endPoint = EndPoint(baseUrl: EndPoint.url, path: "movie/\(id)/credits", apiKey: EndPoint.apiKey, httpMethod: .get)
        let request = RequestHandler(endPoint: endPoint)
         if let url = serializer.serializeRequest(with: request) {
            return requestExecuter.fetchRequest(with: url)
        }
       return nil
    }
 }
