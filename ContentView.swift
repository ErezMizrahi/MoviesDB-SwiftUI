//
//  ContentView.swift
//  SwiftUICheatSheet
//
//  Created by Erez Mizrahi on 21/11/2019.
//  Copyright © 2019 Erez Mizrahi. All rights reserved.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var manager: Manager = Manager.shared
    
    var body: some View {
        Group {
            if manager.test.isEmpty {
                LoadingView()
            } else {
                NavigationView {
                    List{
//                        ForEach(manager.test, id: \.self) { vm in
//                            SectionView(manager: vm, title: )
//                        }
                        ForEach(0..<manager.test.count) { index in
                            SectionView(manager: self.manager.test[index], title:self.manager.catgortys[index].rawValue)
                        }
                        
                    }
                }
            }
        }.onAppear {
            self.manager.parallel()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Row: View {
    let model: MoviesVM
    var body: some View {
        return VStack(alignment: .leading, spacing: 2) {
            Image(uiImage: model.image)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 170)
                .cornerRadius(10)
                .shadow(radius: 10)
            
            Text(model.title)
                .foregroundColor(.primary)
                .font(.headline)
        } .padding(.leading, 30)
    }
}

struct SectionView: View {
    let manager: [MoviesVM]
    let title: String
    var body: some View {
        return VStack(alignment: .leading){
            Text(self.title)
                .font(.title)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    ForEach(manager, id: \.self) { vm in
                        NavigationLink(destination: MovieDetailsView(vm: vm)) {
                                                    ExtractedView(vm: vm)
                        }
                        
                    }
                }
                .padding(40)
            }
        } .navigationBarTitle("Movies")
    }
}


struct MovieDetailsView: View {
    @ObservedObject var manager: Manager = Manager.shared
    let vm: MoviesVM
    @State var flag = false
    
    var body: some View {
        return Group {
            if manager.castModel.isEmpty {
           LoadingView()

            } else {
                VStack {
                               ScrollView {
                                   VStack(spacing: 8) {
                                       Image(uiImage: self.vm.image)
                                           .resizable()
                                           .renderingMode(.original)
                                           .aspectRatio(contentMode: .fill)
                                       
                                       Text(self.vm.overView)
                                           .font(.body)
                                           .foregroundColor(.primary)
                                           .multilineTextAlignment(.center)
                                           .lineLimit(nil)
                                           .padding(.all, 16)
                                       
                                       
                                       ZStack {
                                           Circle()
                                               .trim(from: 0, to: self.vm.rating)
                                               .stroke(self.vm.rating > 6.0 ? Color.green : Color.red, lineWidth:5)
                                               .frame(width:60, height: 60.0)
                                               .rotationEffect(Angle(degrees:-90))
                                           Text("\(Int(self.vm.rating))/10")
                                       }
                                       
                                       Spacer(minLength: 16)
                                       Button(action: {self.flag = true} ) {
                                           Text("Show Cast")
                                               .padding(.all, 16)
                                               .padding(.trailing, 32)
                                               .padding(.leading, 32)
                                               .font(.callout)
                                               .foregroundColor(.white)
                                               .background(Color.blue)
                                               .cornerRadius(10)
                                           
                                       }
                                   }
                                   
                               }
                               
                           } .navigationBarTitle(Text(vm.title), displayMode: .inline)
                               
                               
                               .sheet(isPresented: $flag){
                                   CreditsView(cast: Manager.shared.castModel, crew: Manager.shared.crewModel)
                           }
            }
        }.onAppear {
            Manager.shared.getCredits(id: self.vm.movieID)
        }
        .onDisappear {
            self.manager.castModel = [CastVM]()
            self.manager.crewModel = [CrewVM]()
        }
    }
}


struct CreditsView: View {
    var cast: [CastVM]
    var crew: [CrewVM]
        
    var body: some View {
        
        Group {
            
                TabView {
                    CastTabView(cast: cast)
                    .tabItem {
                            VStack {
                                Image(systemName: "1.circle")
                                Text("Cast Members")
                            }
                    // 4
                    }.tag(1)
                    
                        CrewTabView(crew: crew)
                        .tabItem {
                            VStack{
                                Image(systemName: "2.circle")
                                Text("Crew Members")
                            }
                            
                    }.tag(2)
                    
                }
            
        }
    }
}

struct ExtractedView: View {
    let vm : MoviesVM
    var body: some View {
        VStack {
            GeometryReader { geo in
                
                Row(model: self.vm)
                    .rotation3DEffect(.degrees(Double(-(geo.frame(in: .global).minX - 40 / 20) / 15) ), axis: (x: 0, y: 10, z: 0))
                    .shadow(radius: 10)
            }
            
        } .frame(width: 246, height: 150)
            .font(.headline)
    }
}

struct CrewTabView: View {
    let crew : [CrewVM]
    var body: some View {
        List {
            ForEach(crew, id: \.self) { vm  in
                HStack (spacing: 15) {
                        Image(uiImage: vm.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 120)

                    
                    VStack (alignment: .leading, spacing: 8)
                    {
                        Text(vm.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(vm.job)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}


struct CastTabView: View {
    let cast : [CastVM]
    var body: some View {
        List {
            ForEach(cast, id: \.self) { vm  in
                HStack (spacing: 15) {
                    Image(uiImage: vm.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 120)
                    VStack (alignment: .leading, spacing: 8)
                    {
                        Text(vm.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(vm.character)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
