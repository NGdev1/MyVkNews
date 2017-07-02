//
//  NewsItem.swift
//  MyVkNews
//
//  Created by Apple on 30.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import UIKit
import SwiftyVK

class NewsItem: UIViewController {
    
    var indexPath: IndexPath?
    
    @IBOutlet weak var distanceToImageFeed: NSLayoutConstraint!
    @IBOutlet weak var imageFeedHeight: NSLayoutConstraint!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelOnline: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var imageFeed: UIImageView!
    @IBOutlet weak var imageLike: UIImageView!
    @IBOutlet weak var labelLikes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageProfile.layer.cornerRadius = imageProfile.frame.width / 2.0
        imageProfile.clipsToBounds = true
        imageFeed.clipsToBounds = true
        
        labelOnline.isHidden = true
        
        let content = JSON(News.items[indexPath!.row / 2])
        
        self.textDescription.text = content["text"].string
        
        if textDescription.text.isEmpty{
            distanceToImageFeed.constant = -15
            textDescription.isHidden = true
        }
        
        if var sourceId = content["source_id"].int64 {
            
            if sourceId > 0 {
                if let profile = News.getProfileWithId(sourceId) {
                    labelTitle.text = profile.name
                    
                    downloadProfileImage(url: profile.profileImageUrl)
                    
                    if profile.online {
                        labelOnline.isHidden = false
                    }
                }
            } else {
                sourceId = -sourceId
                
                if let profile = News.getGroupWithId(sourceId) {
                    labelTitle.text = profile.name
                    
                    downloadProfileImage(url: profile.profileImageUrl)
                }
            }
        }
        
        if let imageUrl = content["attachments", 0, "photo", "photo_807"].string {
            downloadImageFeed(url: imageUrl)
        } else if let imageUrl = content["attachments", 0, "photo", "photo_604"].string {
            downloadImageFeed(url: imageUrl)
        } else {
            imageFeedHeight.constant = 0
        }
        
        if let lilkesCount = content["likes", "count"].int {
            labelLikes.text = String(lilkesCount)
        }
        
        if let userLikes = content["likes", "user_likes"].int {
            if userLikes == 1 {
                imageLike.image = #imageLiteral(resourceName: "heart-button-liked")
                labelLikes.textColor = UIColor(red: 0.37, green: 0.57, blue: 0.79, alpha: 1)
            }
        }
    }
    
    func downloadProfileImage(url: String){
        HttpRequests.doGetRequest(URL(string: url)!, viewController: self, whenComplete: {data in
            if data != nil {
                self.imageProfile.image = UIImage(data: data!)
            }
        })
    }
    
    func downloadImageFeed(url: String){
        HttpRequests.doGetRequest(URL(string: url)!, viewController: self, whenComplete: {data in
            if data != nil {
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data!) else { return }
                    
                    let prop = self.view.frame.width / image.size.width
                    self.imageFeedHeight.constant = image.size.height * prop
                    
                    self.imageFeed.image = image
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
