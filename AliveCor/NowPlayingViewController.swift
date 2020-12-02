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

import StagLayout

class NowPlayingViewController: UIViewController {
	
	@IBOutlet weak var collectionView:UICollectionView!
	
	var viewModelNowPlaying:ViewModelNowPlaying!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		let stagLayout = StagLayout(widthHeightRatios: [(0.5,0.5),(0.5,0.5),(1.0,0.5),(0.5,0.5),(0.5,1.0),(0.5,0.5)], itemSpacing: 5);
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.setCollectionViewLayout(stagLayout, animated: false)
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

import Kingfisher


class CellMovie: UICollectionViewCell {
	@IBOutlet var lMovieName:UILabel!
	@IBOutlet var bFavorite:UIButton!
	@IBOutlet var iMovieCover:UIImageView!
	
	func updateCell(movie:Movie)  {
		self.lMovieName.text = movie.title ?? ""
		self.bFavorite.isSelected = movie.getIsFavorite()
		
		if self.iMovieCover.image == nil {
			self.bFavorite.imageView?.addShadow()
		}
		
		self.iMovieCover.kf.setImage(with: URL(string: movie.getCoverUrl()))
		
//		print(movie.getCoverUrl())
	}
	
}

extension UIView {
	func addShadow() {
		let shadowPath = UIBezierPath(rect: self.bounds)
		self.layer.masksToBounds = false
		self.clipsToBounds = false
		self.layer.shadowColor = UIColor.white.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
		self.layer.shadowOpacity = 0.8
		self.layer.shadowPath = shadowPath.cgPath
	}
}
