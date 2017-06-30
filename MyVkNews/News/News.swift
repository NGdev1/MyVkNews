//
//  News.swift
//  MyVkNews
//
//  Created by Apple on 23.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import UIKit
import SwiftyVK

class News: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    static var items = [Any]()
    static var profiles = [Any]()
    static var groups = [Any]()
    static var closedCells = [Bool]()
    static var tableView: UITableView?
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        News.tableView = self.tableView
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.register(UINib(nibName: "Separator", bundle: nil), forCellReuseIdentifier: "Separator")
        
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(News.updateNewsData(_:)), for: UIControlEvents.valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        labelStatus.isHidden = true
        
        if VK.state != .authorized {
            showLoginVC()
        } else {
            self.refreshControl.sendActions(for: UIControlEvents.valueChanged)
        }
    }
    
    func showLoginVC(){
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = loginStoryboard.instantiateInitialViewController()
        
        self.present(loginViewController!, animated: true)
    }
    
    func updateNewsData(_ sender: UIRefreshControl){
        var getNews = VK.API.NewsFeed.get()
        
        getNews.add(parameters: [VK.Arg.filters: "post"])
        
        getNews.send(
            onSuccess: {
                response in
                self.refreshControl.endRefreshing()
                
                News.items = response["items"].arrayObject!
                News.profiles = response["profiles"].arrayObject!
                News.groups = response["groups"].arrayObject!
                
                News.closedCells.removeAll()
                for _ in 0...News.items.count - 1 {
                    News.closedCells.append(true)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    self.labelStatus.isHidden = true
                }
        },
            onError: {
                error in
                self.refreshControl.endRefreshing()
                
                print(error.localizedDescription)
                if News.items.count == 0 {
                    DispatchQueue.main.async {
                        self.labelStatus.text = error.localizedDescription
                        self.labelStatus.isHidden = false
                    }
                } else {
                    Utils.showError(error.localizedDescription, viewController: self)
                }
        })
    }
    
    @IBAction func logout(_ sender: Any) {
        VK.logOut()
        
        showLoginVC()
    }
    
    func getGroupWithId(_ id: Int64) -> Profile? {
        for group in News.groups {
            let content = JSON(group)
            
            if content["id"].int64 == id {
                guard let name = content["name"].string else {
                    return nil
                }
                
                guard let profileImage = content["photo_100"].string else {
                    return nil
                }
                
                return Profile(id: id, name: name, profileImageUrl: profileImage, online: false, isGroup: true)
            }
        }
        
        return nil
    }
    
    func getProfileWithId(_ id: Int64) -> Profile? {
        for profile in News.profiles {
            let content = JSON(profile)
            
            if content["id"].int64 == id {
                guard let firstName = content["first_name"].string else {
                    return nil
                }
                
                guard  let lastName = content["last_name"].string else {
                    return nil
                }
                
                guard let profileImage = content["photo_100"].string else {
                    return nil
                }
                
                guard let online = content["online"].int else {
                    return nil
                }
                
                return Profile(id: id, name: firstName + " " + lastName, profileImageUrl: profileImage, online: online == 1, isGroup: false)
            }
        }
        
        return nil
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 1 {
            return 10
        } else {
            return calculateRowHeight(indexPath)
        }
    }
    
    func calculateRowHeight(_ indexPath: IndexPath) -> CGFloat{
        let content = JSON(News.items[indexPath.row / 2])
        
        var totalHeight: CGFloat = 60
        
        if let text = content["text"].string {
            let constraintRect = CGSize(width: tableView.frame.width - 36, height: .greatestFiniteMagnitude)
            let attributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)
            ]
            
            let textHeight = text.boundingRect(
                with: constraintRect,
                options: .usesLineFragmentOrigin,
                attributes: attributes,
                context: nil
                ).height
            
            if textHeight > 300 && News.closedCells[indexPath.row / 2] {
                totalHeight += 300
            } else {
                totalHeight += textHeight + 15
            }
        }
        
        let photo = JSON(content["attachments", 0, "photo"])
        if let height = photo["height"].float {
            if let width = photo["width"].float {
                let prop = tableView.frame.width / CGFloat(width)
                totalHeight += CGFloat(height) * prop
                
                totalHeight += 20
            }
        }
        
        
        return totalHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if indexPath.row % 2 == 0 {
                guard let newsCell = cell as? NewsCell else {
                    return
                }
                
                newsCell.setIndexPath(indexPath: indexPath)
                
                let content = JSON(News.items[indexPath.row / 2])
                
                newsCell.setDescriptionText(text: content["text"].string)
                
                if let time = content["date"].double {
                    newsCell.setTimeText(timeStampSeconds: time)
                }
                
                newsCell.setOnline(false)
                
                if var sourceId = content["source_id"].int64 {
                    if sourceId > 0 {
                        if let profile = self.getProfileWithId(sourceId) {
                            newsCell.setTitleText(text: profile.name)
                            
                            icache.setImageToCellAndDownloadIfNeed(imageUrl: profile.profileImageUrl,
                                                                   tableView: tableView,
                                                                   indexPath: indexPath,
                                                                   pathToSave: "images",
                                                                   imageIndexInCell: 0
                            )
                            
                            newsCell.setOnline(profile.online)
                        }
                    } else {
                        sourceId = -sourceId
                        
                        if let profile = self.getGroupWithId(sourceId) {
                            newsCell.setTitleText(text: profile.name)
                            
                            icache.setImageToCellAndDownloadIfNeed(imageUrl: profile.profileImageUrl,
                                                                   tableView: tableView,
                                                                   indexPath: indexPath,
                                                                   pathToSave: "images",
                                                                   imageIndexInCell: 0
                            )
                        }
                    }
                }
                
                if let imageUrl = content["attachments", 0, "photo", "photo_807"].string {
                    icache.setImageToCellAndDownloadIfNeed(imageUrl: imageUrl,
                                                           tableView: tableView,
                                                           indexPath: indexPath,
                                                           pathToSave: "images",
                                                           imageIndexInCell: 1
                    )
                } else if let imageUrl = content["attachments", 0, "photo", "photo_604"].string {
                    icache.setImageToCellAndDownloadIfNeed(imageUrl: imageUrl,
                                                           tableView: tableView,
                                                           indexPath: indexPath,
                                                           pathToSave: "images",
                                                           imageIndexInCell: 1
                    )
                }
                
                newsCell.reposition()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return News.items.count * 2 - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Separator")
            
            return cell!
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewsCell")
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newsItemStoryboard = UIStoryboard(name: "NewsItem", bundle: nil)
        guard let newsItemVC = newsItemStoryboard.instantiateInitialViewController() else {
            return
        }
        
        self.navigationController?.pushViewController(newsItemVC, animated: true)
    }
}
