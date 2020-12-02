//
//  CellMovie.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//

import UIKit

import CoreData
import Kingfisher


class CellMovie: UICollectionViewCell {
	@IBOutlet var lMovieName:UILabel!
	@IBOutlet var bFavorite:UIButton!
	@IBOutlet var iMovieCover:UIImageView!
	
	@IBAction func onClickFavorite(_ sender:UIButton) {
		let context = AppDelegate.getAppDelegate().getContext()
		let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)
		let newFavMovie = NSManagedObject(entity: entity!, insertInto: context)
		newFavMovie.setValuesForKeys(["id":self.movie?.id ?? "",
									  "title":self.movie?.title ?? "",
									  "poster_cover":self.movie?.poster_path ?? ""])
		do {
			try context.save()
		}catch let error {
			print(error)
		}
		
		
	}
	
	var movie:Movie?
	
	func updateCell(movie:Movie)  {
		self.lMovieName.text = movie.title ?? ""
		self.bFavorite.isSelected = movie.getIsFavorite()
		
		if self.iMovieCover.image == nil {
			self.bFavorite.imageView?.addShadow()
			self.lMovieName.addShadow()
		}
		
		self.iMovieCover.kf.setImage(with: URL(string: movie.getCoverUrl()))
		self.movie = movie;
		
//		print(movie.getCoverUrl())
	}
	
}
