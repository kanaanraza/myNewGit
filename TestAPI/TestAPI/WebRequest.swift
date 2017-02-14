//
//  WebRequest.swift
//  Bajao - iOS
//
//  Created by Rockville Developer on 04/01/2016.
//  Copyright © 2015 Rockville Developer. All rights reserved.
//

import UIKit

enum RequestID: Int {
    
    case UserSignUP = 1002

}

class WebRequest {
    
    
    class func getSignUpRequest()->RestendFacade {
        
        let restClient = RestendFacade(responseClass: SignUpModel.self)
        restClient.requestMethod = RequestMethod.POST
        restClient.requestUrl = "http://webservice.viftechuat.com//api/Authentication/SigUpTest.html"
        let params: Dictionary<String,String> = ["FullName":"kanaan" ,"Email":"kanaanraza@abctet.com", "Phone":"030074874575", "UserType":"1", "WebSite":"www.abc.com", "LocationName":"abc", "Longitude":"22.33434", "DeviceToken":"abcdkerjrtrte45dfdf", "latitude":"22.3435", "radius":"45.0", "City":"karachi", "NetworkProtocol":"GCM"]
        print("URL::", restClient.requestUrl)
        print("BodyParams::", params)
        restClient.postParams = params
        restClient.requestId = RequestID.UserSignUP.rawValue
        return restClient
    }
}

