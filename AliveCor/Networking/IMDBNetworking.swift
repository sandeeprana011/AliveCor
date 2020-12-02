//
//  IMDBNetworking.swift
//  AliveCor
//
//  Created by Sandeep Rana on 02/12/20.
//

import UIKit
import Alamofire

class IMDBNetworking {
	static func getNowPlayingMovies(completionHandler: @escaping (_ response: AFDataResponse<Any>,_ result:NowPlayingResultsModel?,_ error:Error?) -> Void) {
		API.request(.now_playing) { (response) in
			if response.response?.statusCode == 200, let dataResp = response.data {
				let model = try? JSONDecoder().decode(NowPlayingResultsModel.self, from: dataResp);
				completionHandler(response,model,response.error);
			}else {
				completionHandler(response,nil,response.error);
			}
		}
	}
}
