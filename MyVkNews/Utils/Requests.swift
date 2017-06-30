//
//  Requests.swift
//  MyVkNews
//
//  Created by Apple on 22.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import Foundation
import UIKit

protocol Requests {
    static func doGetRequest(_ urlWithParameters : URL, viewController: UIViewController?, whenComplete : DataTaskDelegate)
    
    static func doPostRequest(_ url : URL, parameters : String, viewController: UIViewController?, whenComplete : DataTaskDelegate)
}

protocol DataTaskDelegate {
    func getResponce(_ result : Data?)
}
