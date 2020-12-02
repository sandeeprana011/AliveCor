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
	
	func getCoverUrl() -> String {
		if let imagePath = self.poster_path {
			return "https://image.tmdb.org/t/p/w500/\(imagePath)"
		}else {
			return "https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg"
		}
	}
	
	var backdrop_path: String?
	var genre_ids: [Int]?
	var original_language, original_title, poster_path: String?
	var vote_count: Int?
	var video: Bool?
	var vote_average: Double?
	var title, overview, release_date: String?
	var id: Int?
	var popularity: Double?
	var adult: Bool?
}
