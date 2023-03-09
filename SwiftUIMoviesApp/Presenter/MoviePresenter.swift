//
//  MoviePresenter.swift
//  SwiftUIMoviesApp
//
//  Created by Rajab on 10/03/23.
//

import Foundation

class MoviePresenter: ObservableObject {
    @Published var interactor: MovieInteractor = MovieInteractor()
    var getMovieData: () -> Void = {}
    var getMovieReviews: (String, String) -> Void = {_,_ in }
    var getMovieGenre: () -> Void = {}
    var filterResults: (Int) -> Void = {_ in }
    
    func setup() {
        getMovieData = {
            self.interactor.getMovieData()
        }
        
        getMovieGenre = {
            self.interactor.getMovieGenre()
        }
        
        getMovieReviews = { id, page in
            self.interactor.getMovieReviews(movieId: id, page: page)
        }
        
        filterResults = { id in
            self.interactor.filterResults(genreId: id)
        }
    }
    
    func getList(page: String) {
        interactor.getMovieData()
    }
}
