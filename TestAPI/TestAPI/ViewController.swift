//
//  ViewController.swift
//  TestAPI
//
//  Created by Kanaan on 12/27/16.
//  Copyright © 2016 Viftech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RestendDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBtnClick(sender:UIButton) {
        
        let restClient = WebRequest.getSignUpRequest()
        restClient.delegate = self
        restClient.getModel()
        
    }
    
    func restDidReceiveResponse(baseModel: BaseModel, requestId: Int, fromCache: Bool) {
        
        if baseModel is SignUpModel {
            
            self.view.hideToastActivity()
            let model: SignUpModel = baseModel as! SignUpModel
            
            let alertController = UIAlertController(title:"", message:"\(model.message)", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func restDidReceiveError(error: ErrorModel, fromId: Int) {
        
        self.view.hideToastActivity()
        self.view.makeToast(message: error.exception, duration: 2.0, position: HRToastPositionCenter)
    }
}

