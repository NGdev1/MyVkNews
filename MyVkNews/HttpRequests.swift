//
//  HttpRequests.swift
//  MyVkNews
//
//  Created by Apple on 22.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import Foundation
import UIKit

class HttpRequests : Requests {
    
    static func doGetRequest(_ urlWithParameters : URL, viewController: UIViewController?, whenComplete : DataTaskDelegate) {
        
        var request = URLRequest(url:urlWithParameters);
        
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = false
        
        sendRequest(request, viewController: viewController, whenComplete: whenComplete)
    }
    
    static func doGetRequest(_ urlWithParameters : URL, viewController: UIViewController?, whenComplete: @escaping(Data?) -> Void) {
        
        var request = URLRequest(url:urlWithParameters);
        
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = false
        
        sendRequest(request, viewController: viewController, whenComplete: whenComplete)
    }
    
    static func doPostRequest(_ url : URL, parameters : String, viewController: UIViewController?, whenComplete : DataTaskDelegate) {
        
        var request = URLRequest(url:url);
        
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = false
        
        request.httpBody = parameters.data(using: String.Encoding.utf8);
        
        sendRequest(request, viewController: viewController, whenComplete: whenComplete)
    }
    
    fileprivate static func sendRequest(_ request : URLRequest, viewController : UIViewController?, whenComplete : DataTaskDelegate) {
        
        let task = URLSession.shared.dataTask(with: request) {
            data, responce, error in
            if error != nil && viewController != nil {
                Utils.showError("Вероятно, соединение с интернетом потеряно", viewController: viewController!)
                
                whenComplete.getResponce(nil)
                return
            }
            
            whenComplete.getResponce(data)
        }
        
        task.resume()
    }
    
    fileprivate static func sendRequest(_ request : URLRequest, viewController : UIViewController?, whenComplete: @escaping(Data?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) {
            data, responce, error in
            if error != nil && viewController != nil {
                Utils.showError("Вероятно, соединение с интернетом потеряно", viewController: viewController!)
                
                whenComplete(nil)
                return
            }
            
            whenComplete(data)
        }
        
        task.resume()
    }
}
