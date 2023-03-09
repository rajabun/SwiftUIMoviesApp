//
//  HomeView.swift
//  SwiftUIMoviesApp
//
//  Created by Rajab on 08/03/23.
//

import SwiftUI

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct HomeView: View
{
    @StateObject var obs = MovieInteractor()
    @State private var listSelection: String?
    @State var selectedGenreId = 0
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(obs.moviesList, id: \.id)
                    { listMovies in
                        ListRow(viewModel: listMovies)
                            .background(NavigationLink(destination: ReviewDetailView(viewModel: listMovies)) {}.opacity(0))
                            .padding(.all)
                    }
                }.navigationBarTitle("Movie List")
                    .padding(.all)
                    .onAppear { //Router
                        obs.getMovieData()
                    }
                    .refreshable { //Router
                        obs.getMovieData()
                    }
                HStack {
                    Text("Please Choose A Genre:")
                    Picker("Please Choose a genre", selection: $selectedGenreId) {
                        ForEach(obs.moviesGenreList, id: \.id) { review in
                            Text(review.name)
                        }
                    }
                    .onChange(of: selectedGenreId, perform: obs.filterResults(genreId:)) //Router
                    .pickerStyle(.menu)
                }
            }
        }
    }
}

struct ListRow: View {
    var viewModel: MovieList?
    
    var body: some View {
        HStack {
            VStack {
                if let vm = viewModel {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(vm.poster_path)"))
                    { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                            // Displays the loaded image.
                        } else if phase.error != nil {
                            // Indicates an error.
                        } else {
                            ProgressView()
                            // Acts as a placeholder.
                        }
                    }
                    Text(vm.title).fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    HStack {
                        if vm.genre_ids.isEmpty == false {
                            Text(vm.release_date)
                                .foregroundColor(.primary)
                            Image(systemName: "star")
                                .foregroundColor(Color.yellow)
                            Text(String(format: "%.1f", vm.vote_average))
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                    Text(vm.overview)
                    .multilineTextAlignment(.center)
                }
            }
            .padding(.all)
        }
    }
}
