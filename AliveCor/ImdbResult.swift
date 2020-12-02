//
//  ImdbResult.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//

import Foundation


// MARK: - Welcome
struct NowPlayingResultsModel:Codable {
	var results: [Movie]?
	var page, totalResults: Int?
	var dates: Dates?
	var totalPages: Int?
}

// MARK: - Dates
struct Dates:Codable {
	var minimum, maximum: String?
}

// MARK: - Result
struct Movie:Codable {
	
	var isFavorite:Bool?;
	
	func getIsFavorite() -> Bool{
		return isFavorite ?? false;
	}
	
	var backdropPath: String?
	var genreIDS: [Int]?
	var originalLanguage, originalTitle, posterPath: String?
	var voteCount: Int?
	var video: Bool?
	var voteAverage: Double?
	var title, overview, releaseDate: String?
	var id: Int?
	var popularity: Double?
	var adult: Bool?
}
