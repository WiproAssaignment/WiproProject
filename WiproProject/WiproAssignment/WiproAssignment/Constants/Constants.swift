//
//  Constants.swift
//  WiproAssignment
//
//  Created by Pavan Kumar N on 10/06/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//

import UIKit

typealias FailureClosure = (_ status: Bool, _ message: String?) -> Void
typealias SuccessDataClosure = (_ status: Bool, _ data: NSDictionary?) -> Void

class Constants: NSObject {
    public static var  url = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    public static let reuseId = "ContentCollectionViewCell"
    public static let viewController = "ViewController"
    public static let main = "Main"


}
