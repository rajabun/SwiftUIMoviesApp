//
//  ContentView.swift
//  SwiftUIMoviesApp
//
//  Created by Rajab on 08/03/23.
//

import SwiftUI

struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDetailView()
    }
}

struct ReviewDetailView: View {
    @StateObject var obs = MovieInteractor()
    var viewModel: MovieList?
        
    var body: some View {
        if let vm = viewModel {
            VStack
            {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(vm.backdrop_path)"))
                { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                        // Displays the loaded image.
                    } else {
                        ProgressView()
                        // Acts as a placeholder.
                    }
                }
                Text(vm.title).fontWeight(.heavy)
                HStack {
                    Text(vm.release_date)
                    Image(systemName: "star")
                        .foregroundColor(Color.yellow)
                    Text(String(format: "%.1f", vm.vote_average))
                }
                Spacer()
                if obs.moviesReviewList.isEmpty {
                    Text("There are no reviews for this film yet")
                }
                List(obs.moviesReviewList)
                { review in
                    HStack {
                        AsyncImage(url: URL(string: "\(review.author_details.avatar_path?.dropFirst() ?? "")"))
                        { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                // Displays the loaded image.
                            } else {
                                Image(systemName: "star")
                                // Acts as a placeholder.
                            }
                        }
                        Text(review.author_details.username ?? "-")
                    }
                    Text(review.content)
                }
            }
            .padding(.all)
            .navigationBarTitle("Review")
            .onAppear { //Router
                obs.getMovieReviews(movieId: "\(vm.id)", page: "1")
            }
        }
    }
}
