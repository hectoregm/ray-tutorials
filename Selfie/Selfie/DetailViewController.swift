//
//  DetailViewController.swift
//  Selfie
//
//  Created by Subhransu Behera on 12/10/14.
//  Copyright (c) 2014 subhb.org. All rights reserved.
//

import UIKit

protocol SelfieEditDelegate {
  func deleteSelfieObjectFromList(selfieImgObject: SelfieImage)
}

class DetailViewController: UIViewController {
  @IBOutlet weak var detailTitleLbl: UILabel!
  @IBOutlet weak var detailThumbImgView: UIImageView!
  @IBOutlet weak var activityIndicatorView: UIView!
  
  var editDelegate:SelfieEditDelegate! = nil
  var selfieCustomObj : SelfieImage! = nil
  let httpHelper = HTTPHelper()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.activityIndicatorView.layer.cornerRadius = 10
    self.detailTitleLbl.text = self.selfieCustomObj.imageTitle
    var imgURL = NSURL(string: self.selfieCustomObj.imageThumbnailURL)
    
    let request = NSURLRequest(URL: imgURL!)
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
        response, data, error in
        if error == nil {
            var image = UIImage(data: data)

            dispatch_async(dispatch_get_main_queue(), {
                self.detailThumbImgView.image = image
            })
        } else {
            println("Error: \(error.localizedDescription)")
        }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func displayAlertMessage(alertTitle:NSString, alertDescription:NSString) -> Void {
    // hide activityIndicator view and display alert message
    self.activityIndicatorView.hidden = true
    let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
    errorAlert.show()
  }
  
  @IBAction func deleteBtnTapped(sender: AnyObject) {
    self.activityIndicatorView.hidden = false
    
    let httpRequest = httpHelper.buildRequest("delete_photo", method: "DELETE", authType: HTTPRequestAuthType.HTTPTokenAuth)
    httpRequest.HTTPBody = "{\"photo_id\":\"\(self.selfieCustomObj.imageId)\"}".dataUsingEncoding(NSUTF8StringEncoding);
    
    httpHelper.sendRequest(httpRequest) {
        data, error in
        if error != nil {
            let errorMessage = self.httpHelper.getErrorMessage(error)
            self.displayAlertMessage("Error", alertDescription: errorMessage)
            
            return
        }
        
        self.editDelegate.deleteSelfieObjectFromList(self.selfieCustomObj)
        self.activityIndicatorView.hidden = true
        self.navigationController?.popViewControllerAnimated(true)
    }
  }
}
