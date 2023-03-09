//
//  MovieEntity.swift
//  SwiftUIMoviesApp
//
//  Created by Rajab on 09/03/23.
//

import Foundation

struct MovieType: Decodable {
    var results: [MovieList]?
}

struct ReviewType: Decodable {
    var results: [MovieReview]?
}

struct GenreType: Decodable {
    var genres: [MovieGenre]
}

struct MovieList: Identifiable, Decodable {
    let id: Int
    let poster_path: String
    let title: String
    let release_date: String
    let overview: String
    
    let backdrop_path: String
    let popularity: Float
    let vote_average: Double
    let vote_count: Int
    let genre_ids: [Int]
}

struct MovieReview: Identifiable, Decodable {
    let id: String
    let author_details: AuthorDetails
    let content: String
    let created_at: String
    let updated_at: String
}

struct AuthorDetails: Decodable {
    let username: String?
    let avatar_path: String?
    let rating: Int?
}

struct MovieGenre: Identifiable, Decodable {
    let id: Int
    let name: String
}
