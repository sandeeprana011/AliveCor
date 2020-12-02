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



class FavoritesViewController: UIViewController {
	
	@IBOutlet weak var collectionView:UICollectionView!
	
	var viewModelFavorites:ViewModelFavorites!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.topItem?.title = "Favourite"
		let stagLayout = StagLayout(widthHeightRatios: [(0.5,0.5),(0.5,0.5)], itemSpacing: 5);
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.setCollectionViewLayout(stagLayout, animated: false)
		self.viewModelFavorites = ViewModelFavorites(delegate:self)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		self.viewModelFavorites.loadDataFromLocalDatabase();
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
	
	@objc func reloadFromDB(_ sender:UIButton)  {
		self.viewModelFavorites.loadDataFromLocalDatabase()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellMovie.name(), for: indexPath) as! CellMovie
		if let movie = self.viewModelFavorites.getMovieFor(index:indexPath.row) {
			cell.updateCell(movie:movie)
			cell.bFavorite.addTarget(self, action: #selector(self.reloadFromDB(_:)), for: .touchUpInside);
		}
		return cell
	}
}

