//
//  ViewModelFavorites.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//

import UIKit
import CoreData

class ViewModelFavorites {
	var results:[Movie] = [Movie]()
	
	var delegate:FavoriteViewModelDelegate?
	
	init(delegate:FavoriteViewModelDelegate) {
		self.delegate = delegate;
		self.loadDataFromLocalDatabase();
	}
	
	func loadDataFromLocalDatabase()  {
		self.results.removeAll()
		let context = AppDelegate.getAppDelegate().getContext();
		let request:NSFetchRequest<Favorite> = Favorite.fetchRequest()
		do {
			let fet = try context.fetch(request);
			fet.forEach({ (favorite) in
				let movie = Movie( backdrop_path: nil, genre_ids: nil, original_language: nil, original_title: nil, poster_path: favorite.poster_cover, vote_count: nil, video: nil, vote_average: nil, title: favorite.title, overview: nil, release_date: nil, id: favorite.id, popularity: nil, adult: nil)
				self.results.append(movie)
			})
			self.delegate?.refreshDataSource()
		}catch let error {
			print(error)
		}
		
	}
	
	func getMovieFor(index:Int) -> Movie? {
		return self.results[index] 
	}
	
	func numberOfRows() -> Int {
		return self.results.count 
	}
}
