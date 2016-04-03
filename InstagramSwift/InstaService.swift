//
//  InstaService.swift
//  InstagramSwift
//
//  Created by Daramony on 4/2/16.
//  Copyright © 2016 Daramony. All rights reserved.
//

import UIKit

class InstaService: NSObject {
    
    let instaSelfURL = "https://api.instagram.com/v1/users/self/feed?access_token"
    var nextMaxId : String?
    
    let NEXT_MAX_ID = "pagination.next_max_id"
    let INSTA_USERNAME = "user.username"
    let INSTA_FULLNAME = "user.full_name"
    let INSTA_PROFILE_IMAGE_URL = "user.profile_picture"
    let INSTA_IMAGE_URL = "images.standard_resolution.url"
    let INSTA_IMAGE_WIDTH = "images.standard_resolution.width"
    let INSTA_IMAGE_HEIGHT = "images.standard_resolution.height"
    let INSTA_TYPE = "type"
    let INSTA_VIDEO_URL = "videos.standard_resolution.url"
    let INSTA_CAPTION_TEXT = "caption.text"
    
    private func makeURL(urlString: String)->String {
        var finalUrlString = urlString.stringByAppendingString("=\(DataManager.sharedInstance.accessToken!)")
        if nextMaxId != nil {
            finalUrlString = finalUrlString.stringByAppendingString("&max_id=\(nextMaxId!)")
        }
        return finalUrlString
    }
    
    
    
    func getMyFeed(completionHandler: (success : Bool, list : [InstaEntity]?)->Void) {
        
        let urlString = makeURL(instaSelfURL)
        let url = NSURL.init(string: urlString)
        let request = NSURLRequest.init(URL: url!)
        let session = NSURLSession.sharedSession()
        let sessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if data != nil {
                
                do {
                    let dataDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    if let maxId : String = dataDict.valueForKeyPath(self.NEXT_MAX_ID) as? String {
                        self.nextMaxId = maxId
                    }
                    
                    let dataList = dataDict.valueForKey("data") as! [NSDictionary]
                    var resultList = [InstaEntity]()
                    
                    for elementDict in dataList {
                        
                        let entity = InstaEntity()
                        entity.userId = elementDict.valueForKeyPath(self.INSTA_USERNAME) as? String
                        entity.fullname = elementDict.valueForKeyPath(self.INSTA_FULLNAME) as? String
                        entity.avatarURL = elementDict.valueForKeyPath(self.INSTA_PROFILE_IMAGE_URL) as? String
                        entity.photoURL = elementDict.valueForKeyPath(self.INSTA_IMAGE_URL) as? String
                        entity.photoWidth = elementDict.valueForKeyPath(self.INSTA_IMAGE_WIDTH) as? String
                        entity.photoHeight = elementDict.valueForKeyPath(self.INSTA_IMAGE_HEIGHT) as? String
                        entity.status = elementDict.valueForKeyPath(self.INSTA_CAPTION_TEXT) as? String ?? ""
                        resultList.append(entity)
                    }
                    completionHandler(success: true, list : resultList)
                }catch{
                    completionHandler(success: false, list : nil)
                }
            }else {
                completionHandler(success: false, list : nil)
            }
        }
        sessionDataTask.resume()
    }

}
