//
//  Extension+UIView.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//

import UIKit

//import Chame
extension UIView {
	func addShadow() {
		let shadowPath = UIBezierPath(rect: self.bounds)
		self.layer.masksToBounds = false
		self.clipsToBounds = false
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
		self.layer.shadowOpacity = 0.8
		self.layer.shadowRadius = 8
		self.layer.shadowPath = shadowPath.cgPath
	}
	
}
