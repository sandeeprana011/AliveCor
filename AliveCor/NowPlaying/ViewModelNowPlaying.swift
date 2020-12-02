//
//  ViewModelNowPlaying.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//

import UIKit
import CoreData

class ViewModelNowPlaying {
	var results:[Movie] = [Movie]()
	
	var delegate:NowPlayingViewModelDelegate?
	
	init(delegate:NowPlayingViewModelDelegate) {
		self.delegate = delegate;
		self.loadDataFromLocalDatabase();
		self.startLoadingNowPlayingMoviesFromNetwork();
	}
	
	func loadDataFromLocalDatabase()  {
		self.results.removeAll()
		let context = AppDelegate.getAppDelegate().getContext();
		let request:NSFetchRequest<NowPlayingMovie> = NowPlayingMovie.fetchRequest()
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
		return self.results[index] ?? nil
	}
	
	func startLoadingNowPlayingMoviesFromNetwork() {
		self.results.removeAll()
		self.delegate?.updateLoader(isLoading: true)
		IMDBNetworking.getNowPlayingMovies { (response, result, error) in
			if result != nil {
				self.results.append(contentsOf: result?.results ?? [])
				self.delegate?.refreshDataSource();
				self.writeToDatabase(result?.results);
			}else {
				
			}
			self.delegate?.updateLoader(isLoading:false);
		}
	}
	
	func writeToDatabase(_ result:[Movie]?) {
		
		let context = AppDelegate.getAppDelegate().getContext()
		
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NowPlayingMovie")
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

		do {
			try context.execute(deleteRequest)
		} catch let erro as NSError {
			print(erro)
			// TODO: handle the error
		}
		
		let entity = NSEntityDescription.entity(forEntityName: "NowPlayingMovie", in: context)
		
		result?.forEach({ (movie) in
			let newFavMovie = NSManagedObject(entity: entity!, insertInto: context)
			newFavMovie.setValuesForKeys(["id":movie.id ?? "",
										  "title":movie.title ?? "",
										  "poster_cover":movie.poster_path ?? ""])
		})
		
		do {
			try context.save()
		}catch let error {
			print(error)
		}
	}
	
	func numberOfRows() -> Int {
		return self.results.count 
	}
	
}


protocol NowPlayingViewModelDelegate {
	func refreshDataSource()
	func updateLoader(isLoading:Bool);
}
