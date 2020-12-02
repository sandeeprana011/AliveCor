//
//  AppStoryboard.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//
//

import Foundation
import UIKit

enum AppStoryboard: String {

	case Main, Search, Registration, Payments,Payment

	var instance: UIStoryboard {
		return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
	}

	func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
		let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
		return instance.instantiateViewController(withIdentifier: storyboardID) as! T
	}


	func initialViewController() -> UIViewController? {
		return instance.instantiateInitialViewController();
	}
}

extension UIViewController {
	class var storyboardID: String {
		return "\(self)"
	}

	class func instantiate(fromAppStoryboard: AppStoryboard) -> Self {
		return fromAppStoryboard.viewController(viewControllerClass: self);
	}

}

extension UIView {
	static func name() -> String {
		return "\(self)"
	}
}
