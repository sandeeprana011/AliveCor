//  API.swift
//  AliveCor
//  Created by Sandeep Rana on 02/12/20.

import Foundation
import Alamofire



var EnvBaseURL = "https://api.themoviedb.org/3"

enum ServerConfig: String {
	case now_playing = "/movie/now_playing";
}


open class API {
	public enum Endpoints {
		case now_playing
		public var method: HTTPMethod {
			switch self {
			case .now_playing:
				return HTTPMethod.get
			}
		}

		public var path: String {

			var urlBuild = "";
			switch self {
			case .now_playing:
				urlBuild = EnvBaseURL + ServerConfig.now_playing.rawValue;
			}
			return urlBuild
		}

		public var parameters: Parameters {
			var parameters = [String: Any]()
			parameters["api_key"] = "34c902e6393dc8d970be5340928602a7"
			switch self {
			case .now_playing:
				break;
			}
			return parameters
		}
		public var encodingType: ParameterEncoding {
			switch self.method {
			case .post:
				switch self {
				default:
					return JSONEncoding.default
				}
			case .put:
				return JSONEncoding.default;
			default:
				return URLEncoding.default
			}
		}

		public var headers: HTTPHeaders {
			var headers = HTTPHeaders()

			headers["platform"] = "iOS";
			switch self{
			case .now_playing:
				break;
			}
			return headers
		}

	}

	public static func request(_ endpoint: API.Endpoints, endPointPostFix: String = "", completionHandler: @escaping (AFDataResponse<Any>) -> Void, cacheHandler: @escaping (Data) -> Void = { _ in
	}) {
		let request = AF.request(endpoint.path, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encodingType, headers: endpoint.headers);
		
		request.responseJSON { (response) in
//			var requestString: String?;
//			if let httpBody = response.request?.httpBody {
//				requestString = String(data: httpBody, encoding: String.Encoding.utf8);
//			}
//			let requestHeaderString = response.request?.allHTTPHeaderFields?.debugDescription;
//			let responseHeaderString = response.response?.allHeaderFields.debugDescription;
			completionHandler(response)
		}
		return
	}
}
