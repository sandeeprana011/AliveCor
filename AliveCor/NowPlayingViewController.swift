//  NowPlayingViewController.swift
//  AliveCor
//  Created by Sandeep Rana on 02/12/20.

import UIKit


protocol NowPlayingViewModelDelegate {
	func refreshDataSource()
	func updateLoader(isLoading:Bool);
}

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

class NowPlayingViewController: UIViewController {
	
	@IBOutlet weak var collectionView:UICollectionView!
	
	var viewModelNowPlaying:ViewModelNowPlaying!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		viewModelNowPlaying = ViewModelNowPlaying(delegate:self)
    }

}

extension NowPlayingViewController:NowPlayingViewModelDelegate {
	func refreshDataSource() {
		self.collectionView.reloadData();
	}
	
	func updateLoader(isLoading: Bool) {
		
	}
	
	
}

extension NowPlayingViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModelNowPlaying.numberOfRows()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellMovie.name(), for: indexPath) as! CellMovie
		if let movie = self.viewModelNowPlaying.getMovieFor(index:indexPath.row) {
			cell.updateCell(movie:movie)
		}
		return cell
	}
}

class CellMovie: UICollectionViewCell {
	@IBOutlet var lMovieName:UILabel!
	@IBOutlet var bFavorite:UIButton!
	@IBOutlet var iMovieCover:UIImageView!
	
	func updateCell(movie:Movie)  {
		self.lMovieName.text = movie.originalTitle ?? ""
		self.bFavorite.isSelected = movie.getIsFavorite()
	}
}
