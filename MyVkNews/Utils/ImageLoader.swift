//
//  ImageLoader.swift
//  MyVkNews
//
//  Created by Apple on 24.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import Foundation

class ImageLoader {
    var imageUrl: String?
    var pathToSave: String = "images"
    
    func downloadImage(imageUrl : String, whenComplete: @escaping(Data)->Void){
        self.imageUrl = imageUrl
        
        let url = URL(string: imageUrl)
        HttpRequests.doGetRequest(url!, viewController: nil, whenComplete: { data in
            if data != nil {
                whenComplete(data!)
            }
        })
    }
    
    func downloadImage(imageUrl : String, pathToSave: String){
        self.imageUrl = imageUrl
        self.pathToSave = pathToSave
        
        let url = URL(string: imageUrl)
        HttpRequests.doGetRequest(url!, viewController: nil, whenComplete: { data in
            if data != nil {
                self.saveImage(data!)
            }
        })
    }
    
    func saveImage(_ data: Data){
        DataManager.saveImageToCash(pathName: pathToSave,
                                    fileName: String(imageUrl!.hash),
                                    data: data,
                                    maxWidth: nil)
    }
}
