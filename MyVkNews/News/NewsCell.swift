//
//  NewsCell.swift
//  MyVkNews
//
//  Created by Apple on 24.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell, DownloadedImagesInCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageFeed: UIImageView!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var textTime: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelOnline: UILabel!
    
    @IBOutlet weak var showMoreButton: UIButton!
    
    var indexPath: IndexPath?
    
    @IBAction func showMore(_ sender: Any) {
        News.closedCells.insert(false, at: self.indexPath!.row / 2)
        DispatchQueue.main.async {
            News.tableView!.reloadRows(at: [self.indexPath!], with: .fade)
        }
    }
    
    func setIndexPath(indexPath: IndexPath){
        self.indexPath = indexPath
    }
    
    func setDownloadedImage(imageIndex: Int, image: UIImage) {
        if imageIndex == 0 {
            setImageProfile(image: image)
        } else if imageIndex == 1{
            setImageFeed(image: image)
        }
    }
    
    func setDownloadedImageAnimated(imageIndex: Int, image: UIImage) {
        if imageIndex == 0 {
            setImageProfile(image: image)
        } else if imageIndex == 1{
            setImageFeedWithAnimation(image: image)
        }
    }
    
    override func prepareForReuse() {
        imageFeed.image = nil
        imageProfile.image = #imageLiteral(resourceName: "camera_100")
        showMoreButton.isHidden = true
    }
    
    func setTitleText(text: String?){
        labelTitle.text = text
    }
    
    func setDescriptionText(text: String?){
        textDescription.isHidden = false
        textDescription.text = text
    }
    
    func setImageProfile(image: UIImage){
        self.imageProfile.image = image
    }
    
    func setImageFeed(image: UIImage?){
        self.imageFeed.image = image
    }
    
    func setImageFeedWithAnimation(image: UIImage){
        self.imageFeed.alpha = 0.3
        self.imageFeed.image = image
        
        UIView.animate(withDuration: 0.4, animations: {
            self.imageFeed.alpha = 1
        })
    }
    
    func setTimeText(timeStampSeconds : Double){
        let timeDifference = Date().timeIntervalSince1970 - timeStampSeconds
        
        if timeDifference < 48 * 3600 {
            textTime.text = Utils.stringFromTimeInterval(interval: timeDifference)
        } else {
            let date = Date(timeIntervalSince1970: timeStampSeconds)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "Ru")
            dateFormatter.dateFormat = "d MMMM"
            
            textTime.text = dateFormatter.string(from: date)
        }
    }
    
    func setOnline(_ online: Bool){
        self.labelOnline.isHidden = !online
    }
    
    func reposition(){
        textDescription.frame.size.width = frame.width - 26
        let labelTitleWidth = frame.width - 100
        labelTitle.sizeToFit()
        if labelTitle.frame.size.width > labelTitleWidth {
            labelTitle.frame.size.width = labelTitleWidth
        }
        
        if !labelOnline.isHidden {
            labelOnline.frame.origin.x = labelTitle.frame.origin.x + labelTitle.frame.size.width + 5
        }
        
        //labelTitle.backgroundColor = UIColor.red
        
        if textDescription.text.isEmpty {
            textDescription.isHidden = true
            textDescription.frame.size.height = 10
        } else {
            textDescription.sizeToFit()
            
            if textDescription.frame.size.height > 300 && News.closedCells[indexPath!.row / 2]  {
                textDescription.frame.size.height = 300
                
                
                showMoreButton.frame.origin.y = textDescription.frame.origin.y + textDescription.frame.size.height - 30
                
                showMoreButton.isHidden = false
            }
        }
        
        imageFeed.frame.origin.y = 60 + textDescription.frame.height
        imageFeed.frame.origin.x = 0
        imageFeed.frame.size.width = frame.width
        
        if imageFeed.image != nil {
            let prop = frame.width / imageFeed.image!.size.width
            imageFeed.frame.size.height = imageFeed.image!.size.height * prop
        } else {
            //image may be loading
            var imageFeedHeight = frame.size.height - imageFeed.frame.origin.y - 20
            
            if imageFeedHeight < 0 {
                //noFeedImage
                imageFeedHeight = 0
            }
            
            imageFeed.frame.size.height = imageFeedHeight
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageProfile.layer.cornerRadius = imageProfile.frame.width / 2.0
        imageProfile.clipsToBounds = true
        imageFeed.clipsToBounds = true
        
        showMoreButton.isHidden = true
        
        labelTitle.text = ""
        imageFeed.image = nil
        textDescription.text = ""
        self.textDescription.textContainer.lineBreakMode = .byTruncatingTail
    }
}
