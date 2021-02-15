//
//  ContentView.swift
//  HelloCoreData
//
//  Created by Mohammad Azam on 2/14/21.
//

import SwiftUI

struct ContentView: View {
    
    let coreDM: CoreDataManager
    @State private var movieTitle: String = ""
    // NOT A GOOD IDEA TO USE STATE TO POPULATE DATA FROM
    // THIRD PARTY CALL
    @State private var movies: [Movie] = [Movie]()
    @State private var needsRefresh: Bool = false
    
    private func populateMovies() {
        movies = coreDM.getAllMovies()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter title", text: $movieTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Save") {
                    coreDM.saveMovie(title: movieTitle)
                    populateMovies()
                }
                
                List {
                    
                    ForEach(movies, id: \.self) { movie in
                        NavigationLink(
                            destination: MovieDetail(movie: movie, coreDM: coreDM, needsRefresh: $needsRefresh),
                            label: {
                                Text(movie.title ?? "")
                            })
                    }.onDelete(perform: { indexSet in
                        indexSet.forEach { index in
                            let movie = movies[index]
                            // delete it using Core Data Manager
                            coreDM.deleteMovie(movie: movie)
                            populateMovies()
                        }
                    })
                    
                }.listStyle(PlainListStyle())
                .accentColor(needsRefresh ? .white: .black)
                
                
                Spacer()
            }.padding()
            .navigationTitle("Movies")
            
            .onAppear(perform: {
                populateMovies()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(coreDM: CoreDataManager())
    }
}
