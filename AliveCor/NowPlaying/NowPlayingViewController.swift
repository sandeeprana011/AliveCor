//  NowPlayingViewController.swift
//  AliveCor
//  Created by Sandeep Rana on 02/12/20.

import UIKit



import StagLayout

class NowPlayingViewController: UIViewController {
	
	@IBOutlet weak var collectionView:UICollectionView!
	
	var viewModelNowPlaying:ViewModelNowPlaying!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.topItem?.title = "Now Playing"
//		let stagLayout = StagLayout(widthHeightRatios: [(0.5,0.5),(0.5,0.5),(1.0,0.5),(0.5,0.5),(0.5,1.0),(0.5,0.5)], itemSpacing: 5);
		let stagLayout = StagLayout(widthHeightRatios: [(0.5,0.5),(0.5,1.0),(0.5,0.5),(1.0,0.5),(0.5,1.0),(0.5,0.5)], itemSpacing: 5);
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.setCollectionViewLayout(stagLayout, animated: false)
		viewModelNowPlaying = ViewModelNowPlaying(delegate:self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		AppDelegate.getAppDelegate().updateFavList()
		self.viewModelNowPlaying.loadDataFromLocalDatabase()
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
			cell.updateCell(movie:movie);
		}
		return cell
	}
	
}
