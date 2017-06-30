//
//  ImageCache.swift
//  MyVkNews
//
//  Created by Apple on 24.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import Foundation
import UIKit

let icache = ImageCache()

protocol DownloadedImagesInCell{
    func setDownloadedImage(imageIndex: Int, image: UIImage)
    func setDownloadedImageAnimated(imageIndex: Int, image: UIImage)
}

struct ImageDataToCell{
    var indexPath: IndexPath
    var tableView: UITableView
    var pathToSave: String
    var imageIndex: Int
}

class ImageCache{
    
    var images = [String: UIImage]()
    var imagesDownloading = [String: ImageDataToCell]()
    
    private func ImageCache(){
        
    }
    
    func addImageToCache(url: String, image: UIImage){
        images[url] = image
    }
    
    func isImageDownloading(by url: String) -> Bool {
        return imagesDownloading.keys.contains(url)
    }
    
    func downloadImage(imageUrl: String,
                       tableView: UITableView,
                       indexPath: IndexPath,
                       pathToSave: String,
                       imageIndexInCell: Int){
        if !isImageDownloading(by: imageUrl){
            let downloadingImageData = ImageDataToCell(indexPath: indexPath,
                                                       tableView: tableView,
                                                       pathToSave: pathToSave,
                                                       imageIndex: imageIndexInCell
            )
            
            imagesDownloading[imageUrl] = downloadingImageData
            
            ImageLoader().downloadImage(imageUrl: imageUrl,
                                        whenComplete: {
                                            data in
                                            
                                            print("image " + imageUrl + " downloaded")
                                            self.onImageDownloaded(data: data, url: imageUrl)
            })
        }
    }
    
    
    func onImageDownloaded(data: Data, url: String){
        
        if let imageData = imagesDownloading[url] {
            
            if let downloadedImage = UIImage(data: data){
                self.images[url] = downloadedImage
                
                putImageToCellAnimated(image: downloadedImage,
                                       imageIndex: imageData.imageIndex,
                                       tableView: imageData.tableView,
                                       indexPath: imageData.indexPath
                )
                
                //                DataManager.saveImageToCash(pathName: imageData.pathToSave,
                //                                            fileName: String(url.hash),
                //                                            data: data,
                //                                            maxWidth: nil)
                
                imagesDownloading.removeValue(forKey: url)
            }
        }
    }
    
    func putImageToCellAnimated(image: UIImage, imageIndex: Int, tableView: UITableView, indexPath: IndexPath){
        if (tableView.indexPathsForVisibleRows == nil) {
            return
        }
        
        if (!tableView.indexPathsForVisibleRows!.contains(indexPath)) {
            return
        }
        
        DispatchQueue.main.async {
            if let cell = tableView.cellForRow(at: indexPath) as? DownloadedImagesInCell{
                cell.setDownloadedImageAnimated(imageIndex: imageIndex, image: image)
            }
        }
    }
    
    func putImageToCell(image: UIImage, imageIndex: Int, tableView: UITableView, indexPath: IndexPath){
        if (tableView.indexPathsForVisibleRows == nil) {
            return
        }
        
        if (!tableView.indexPathsForVisibleRows!.contains(indexPath)) {
            return
        }
        
        DispatchQueue.main.async {
            if let cell = tableView.cellForRow(at: indexPath) as? DownloadedImagesInCell{
                cell.setDownloadedImage(imageIndex: imageIndex, image: image)
            }
        }
    }
    
    //Set image to cell from cache and start downloading if need
    func setImageToCellAndDownloadIfNeed(imageUrl: String,
                                         tableView: UITableView,
                                         indexPath: IndexPath,
                                         pathToSave: String,
                                         imageIndexInCell: Int)
    {
        if let image = images[imageUrl] {
            if let cell = tableView.cellForRow(at: indexPath) as? DownloadedImagesInCell{
                cell.setDownloadedImage(imageIndex: imageIndexInCell, image: image)
            }
        } else {
            //картинки в кеше нет - надо скачать
            downloadImage(imageUrl: imageUrl,
                          tableView: tableView,
                          indexPath: indexPath,
                          pathToSave: pathToSave,
                          imageIndexInCell: imageIndexInCell
            )
        }
    }
}
