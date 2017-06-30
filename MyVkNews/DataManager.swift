//
//  DataManager.swift
//  MyVkNews
//
//  Created by Apple on 24.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    static let userDefaults = UserDefaults.standard
    
    static func saveTextToCash(pathName: String, fileName: String, text: String){
        saveDataToCash(pathName: pathName, fileName: fileName, data: text.data(using: String.Encoding.utf8)!)
    }
    
    static func getTextFromCash(pathName: String, fileName: String) ->String?{
        if let dir = FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask).first {
            let directory = dir.appendingPathComponent(pathName)
            let filePath = directory.appendingPathComponent(fileName)
            
            var result : String? = nil
            do {
                try result = String(data: Data(contentsOf: filePath), encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print(error.description)
            }
            
            return result
        }
        
        return nil
    }
    
    static func getDataFromCash(pathName: String, fileName: String) ->Data? {
        if let dir = FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask).first {
            let directory = dir.appendingPathComponent(pathName)
            let filePath = directory.appendingPathComponent(fileName)
            
            var result : Data? = nil
            do {
                try result = Data(contentsOf: filePath)
            } catch let error as NSError {
                print(error.description)
            }
            
            return result
        }
        
        return nil
    }
    
    static func saveImageToCash(pathName: String, fileName: String, data: Data, maxWidth: CGFloat?)
    {
        if maxWidth != nil {
            if var image = UIImage(data: data) {
                print("resizing image before save...")
                image = Utils.scaleImage(image: image, maximumWidth: maxWidth!)
                
                if let dataScaledImage = UIImagePNGRepresentation(image) {
                    saveDataToCash(pathName: pathName, fileName: fileName, data: dataScaledImage)
                }
            }
        } else {
            saveDataToCash(pathName: pathName, fileName: fileName, data: data)
        }
    }
    
    static func saveDataToCash(pathName: String, fileName: String, data: Data){
        if let dir = FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask).first {
            let directory = dir.appendingPathComponent(pathName)
            let filePath = directory.appendingPathComponent(fileName)
            var isDir : ObjCBool = false
            
            if !FileManager.default.fileExists(atPath: directory.path, isDirectory: &isDir){
                do {
                    print("creating directory " + directory.path)
                    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error.description)
                }
            }
            
            do {
                print("write to " + filePath.path)
                try data.write(to: filePath, options: .atomic)
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    static func fileExists(pathName: String, fileName: String) -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask).first {
            let directory = dir.appendingPathComponent(pathName)
            let filePath = directory.appendingPathComponent(fileName)
            
            return FileManager.default.fileExists(atPath: filePath.path)
        }
        return false
    }
    
    static func deleteCashAtPath(pathName: String){
        if let dir = FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask).first {
            let directory = dir.appendingPathComponent(pathName)
            
            if FileManager.default.fileExists(atPath: directory.path){
                do {
                    print("deleting " + directory.path)
                    try FileManager.default.removeItem(at: directory)
                } catch let error as NSError {
                    print(error.description)
                }
            }
        }
    }
    
    static func getImageFromCash(pathName: String, fileName: String) -> UIImage?{
        if let dir = FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask).first {
            let directory = dir.appendingPathComponent(pathName)
            let filePath = directory.appendingPathComponent(fileName)
            
            return UIImage(contentsOfFile: filePath.path)
        }
        
        return nil
    }
    
    static func removeValue(key: String){
        userDefaults.removeObject(forKey: key)
        
        userDefaults.synchronize()
    }
    
    static func getValue(key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }
}
