//
//  ViewModelNowPlaying.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//

import UIKit

class ViewModelNowPlaying {
	var results:[Movie]?
	
	var delegate:NowPlayingViewModelDelegate?
	
	init(delegate:NowPlayingViewModelDelegate) {
		self.delegate = delegate;
		self.loadDataFromLocalDatabase();
		self.startLoadingNowPlayingMoviesFromNetwork();
	}
	
	func loadDataFromLocalDatabase()  {
		
	}
	
	func getMovieFor(index:Int) -> Movie? {
		return self.results?[index] ?? nil
	}
	
	func startLoadingNowPlayingMoviesFromNetwork() {
		self.delegate?.updateLoader(isLoading: true)
		IMDBNetworking.getNowPlayingMovies { (response, result, error) in
			if result != nil {
				self.results = result?.results
				self.delegate?.refreshDataSource();
			}else {
				
			}
			self.delegate?.updateLoader(isLoading:false);
		}
	}
	
	func numberOfRows() -> Int {
		return self.results?.count ?? 0
	}
	
}


protocol NowPlayingViewModelDelegate {
	func refreshDataSource()
	func updateLoader(isLoading:Bool);
}
