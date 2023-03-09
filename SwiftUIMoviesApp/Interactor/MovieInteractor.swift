//
//  MovieInteractor.swift
//  SwiftUIMoviesApp
//
//  Created by Rajab on 09/03/23.
//

import Foundation

class MovieInteractor: ObservableObject {
    @Published var filteredMoviesList = [MovieList]()
    @Published var originalMoviesList = [MovieList]()
    @Published var moviesList = [MovieList]()
    @Published var moviesReviewList = [MovieReview]()
    @Published var moviesGenreList = [MovieGenre]()
    var selectedMovies: MovieList?
    
    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true
    
    private var movieUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=1d7d9a8ddce6212c0d9ab76119aa9893&language=en-US&page="
    private var movieGenreUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=1d7d9a8ddce6212c0d9ab76119aa9893&language=en-US"
    private var movieReviewUrl = "https://api.themoviedb.org/3/movie/"
    
    func getMovieData() {
        movieUrl = movieUrl + "\(currentPage)"
        let sess = URLSession(configuration: .default)
        guard let listUrl = URL(string: movieUrl) else { return }
        sess.dataTask(with: listUrl)
        { (data, _, _) in
            guard let fetchedData = data else { return }
            do {
                let fetch = try JSONDecoder().decode(MovieType.self, from: fetchedData)
                DispatchQueue.main.async
                {
                    guard let result = fetch.results else { return }
                    
                    if self.moviesList.isEmpty {
                        self.moviesList = result
                        self.originalMoviesList = result
                    } else if self.moviesList.last?.id != result.last?.id {
                        self.moviesList.append(contentsOf: result)
                        self.originalMoviesList.append(contentsOf: result)
                    }
                    self.getMovieGenre()
                }
                
            } catch {
                print("ISI ERROR MOVIE DATA =", error)
            }
        }.resume()
    }
    
    func getMovieReviews(movieId: String, page: String) {
        movieReviewUrl = movieReviewUrl + movieId + "/reviews?api_key=1d7d9a8ddce6212c0d9ab76119aa9893&language=en-US&page=" + "\(currentPage)"
        let sess = URLSession(configuration: .default)
        guard let reviewUrl = URL(string: movieReviewUrl) else { return }
        
        sess.dataTask(with: reviewUrl)
        { (data, _, _) in
            guard let fetchedData = data else { return }
            do {
                let fetch = try JSONDecoder().decode(ReviewType.self, from: fetchedData)
                DispatchQueue.main.async {
                    guard let result = fetch.results else { return }
                    
                    if self.moviesReviewList.isEmpty {
                        self.moviesReviewList = result
                    } else if self.moviesReviewList.last?.id != result.last?.id {
                        self.moviesReviewList.append(contentsOf: result)
                    }
                }
            } catch {
                print("ISI ERROR MOVIE REVIEW =", error)
            }
        }.resume()
    }
    
    func getMovieGenre() {
        let sess = URLSession(configuration: .default)
        guard let listUrl = URL(string: movieGenreUrl) else { return }
        sess.dataTask(with: listUrl)
        { (data, _, _) in
            guard let fetchedData = data else { return }
            do {
                let fetch = try JSONDecoder().decode(GenreType.self, from: fetchedData)
                DispatchQueue.main.async {
                    self.moviesGenreList = fetch.genres
                    self.moviesGenreList.insert(MovieGenre(id: 0, name: "All"), at: 0)
                }
            } catch {
                print("ISI ERROR MOVIE GENRE =", error)
            }
        }.resume()
    }
    
    func filterResults(genreId: Int) {
        filteredMoviesList.removeAll()
        for movie in originalMoviesList {
            for genre in movie.genre_ids {
                if genreId == genre {
                    filteredMoviesList.append(movie)
                }
            }
        }
        if filteredMoviesList.isEmpty {
            let emptyData = MovieList(id: 0, poster_path: "", title: "No Movie Available For This Genre", release_date: "", overview: "", backdrop_path: "", popularity: 0, vote_average: 0, vote_count: 0, genre_ids: [])
            filteredMoviesList.append(emptyData)
        }
        moviesList = filteredMoviesList
        if genreId == 0 {
            moviesList = originalMoviesList
        }
    }
}
