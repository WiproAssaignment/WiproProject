//
//  ViewCOntrollerViewModel.swift
//  WiproAssignment
//
//  Created by Pavan Kumar N on 10/06/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//

import UIKit
import Alamofire

class ViewCOntrollerViewModel: NSObject {
    
    /// Get the data from API and parse.
    ///
    /// - Parameters:
    ///   - completionHandler: Success Handler
    ///   - failureHandler: Failure Handler
    func allRommsWebServiceCall(completionHandler:@escaping SuccessDataClosure, failureHandler:@escaping FailureClosure) {
        
        guard let url = URL(string: Constants.url) else {
            return
        }
        Alamofire.request(url)
            .responseJSON { response in
                
                let responseStrInISOLatin = String(data: response.data!, encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                do {
                    let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                    print(responseJSONDict)
                    completionHandler(true, responseJSONDict as? NSDictionary)
                } catch {
                    failureHandler(false, error as? String)
                    print(error)
                }
        }
    }
}
