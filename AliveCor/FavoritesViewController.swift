//
//  FavoritesViewController.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//

import UIKit
import CoreData
import StagLayout

protocol FavoriteViewModelDelegate {
	func refreshDataSource()
	func updateLoader(isLoading:Bool);
}

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
			(fet as? [Favorite])?.forEach({ (favorite) in
				let movie = Movie(isFavorite: true, backdrop_path: nil, genre_ids: nil, original_language: nil, original_title: nil, poster_path: favorite.poster_cover, vote_count: nil, video: nil, vote_average: nil, title: favorite.title, overview: nil, release_date: nil, id: favorite.id, popularity: nil, adult: nil)
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

class FavoritesViewController: UIViewController {
	
	@IBOutlet weak var collectionView:UICollectionView!
	
	var viewModelFavorites:ViewModelFavorites!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let stagLayout = StagLayout(widthHeightRatios: [(0.5,0.5),(0.5,0.5)], itemSpacing: 5);
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.setCollectionViewLayout(stagLayout, animated: false)
		self.viewModelFavorites = ViewModelFavorites(delegate:self)
	}
	
}

extension FavoritesViewController:FavoriteViewModelDelegate {
	func refreshDataSource() {
		self.collectionView.reloadData();
	}
	
	func updateLoader(isLoading: Bool) {
		
	}
	
	
}

extension FavoritesViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModelFavorites.numberOfRows()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellMovie.name(), for: indexPath) as! CellMovie
		if let movie = self.viewModelFavorites.getMovieFor(index:indexPath.row) {
			cell.updateCell(movie:movie)
		}
		return cell
	}
}

