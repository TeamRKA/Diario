//
//  FourSquareAPI.swift
//  MHacks9
//
//  Created by Ryuji Mano on 4/20/17.
//  Copyright © 2017 DeeptanhuRyujiKenanAvi. All rights reserved.
//

import UIKit

class FourSquareAPI: NSObject {
    
    let key = "DBEZDXIKA41HZ1ZXESOHRYDNZ14G2ELQF1CKGHUQJYTMTBHR"
    let secret = "5Z2225WUI3OZRD4GB3LHJJU1DS1X1FCLR4FODUL5JPGDREZQ"
    
    static let shared = FourSquareAPI()
    
    func getVenues(near: String, searchText: String, success: @escaping ([NSDictionary]) -> (), failure: @escaping (Error) -> ()) {
        let nearString = near.components(separatedBy: .whitespaces).joined()
        let searchString = searchText.components(separatedBy: .whitespaces).joined()
        let urlString = "https://api.foursquare.com/v2/venues/suggestCompletion?near=\(nearString)&query=\(searchString)&client_id=\(key)&client_secret=\(secret)&v=20170420&limit=8"
        
        let url = URL(string: urlString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                failure(error)
                return
            }
            if let data = data {
                if let dict = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    let response = dict["response"] as? NSDictionary
                    
                    if let response = response {
                        if let venues = response["minivenues"] as? [NSDictionary] {
                            success(venues)
                            return
                        }
                        else {
                            success([])
                            return
                        }
                    }
                    else {
                        success([])
                        return
                    }
                }
                else {
                    success([])
                    return
                }
            }
        }
        task.resume()
    }
}
