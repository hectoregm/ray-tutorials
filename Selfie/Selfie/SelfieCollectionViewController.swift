//
//  SelfieCollectionViewController.swift
//  Selfie
//
//  Created by Behera, Subhransu on 29/8/14.
//  Copyright (c) 2014 subhb.org. All rights reserved.
//

import UIKit

let reuseIdentifier = "SelfieCollectionViewCell"

class SelfieCollectionViewController: UICollectionViewController {
  var shouldFetchNewData = true
  var dataArray = [SelfieImage]()
  let httpHelper = HTTPHelper()
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if defaults.objectForKey("userLoggedIn") == nil {
      let loginController: ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as ViewController
      self.navigationController?.presentViewController(loginController, animated: true, completion: nil)
    } else {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let userTokenExpiryDate : NSString? = KeychainAccess.passwordForAccount("Auth_Token_Expiry", service: "KeyChainService")
        let dateFromString: NSDate? = dateFormatter.dateFromString(userTokenExpiryDate!)
        let now = NSDate()
        
        let comparision = now.compare(dateFromString!)
        
        if shouldFetchNewData {
            shouldFetchNewData = false
            self.setNavigationItems()
            loadSelfieData()
        }
        
        if comparision != NSComparisonResult.OrderedAscending {
            self.logoutBtnTapped()
        }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setNavigationItems() {
    var logOutBtn = UIBarButtonItem(title: "logout", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logoutBtnTapped"))
    self.navigationItem.leftBarButtonItem = logOutBtn
    
    var navCameraBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: Selector("cameraBtnTapped"))
    self.navigationItem.rightBarButtonItem = navCameraBtn
  }
  
  // 1. Clears the NSUserDefaults flag
  func clearLoggedinFlagInUserDefaults() {
  }
  
  // 2. Removes the data array
  func clearDataArrayAndReloadCollectionView() {
  }
  
  // 3. Clears API Auth token from Keychain
  func clearAPITokensFromKeyChain () {    
  }
  
  func logoutBtnTapped() {
  }
  
  func cameraBtnTapped() {
    displayCameraControl()
  }
  
  func loadSelfieData () {
    let httpRequest = httpHelper.buildRequest("get_photos", method: "GET", authType: HTTPRequestAuthType.HTTPTokenAuth)
    
    httpHelper.sendRequest(httpRequest) {
        data, error in
        if error != nil {
            let errorMessage = self.httpHelper.getErrorMessage(error)
            let errorAlert = UIAlertView(title: "Error", message: errorMessage, delegate: nil, cancelButtonTitle: "OK")
            errorAlert.show()
            
            return
        }
        
        var eror: NSError?
        let jsonDataArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &eror) as NSArray!
        
        if jsonDataArray != nil {
            for imageDataDict in jsonDataArray {
                var selfieImgObj = SelfieImage()
                
                selfieImgObj.imageTitle = imageDataDict.valueForKey("title") as NSString
                selfieImgObj.imageId = imageDataDict.valueForKey("random_id") as NSString
                selfieImgObj.imageThumbnailURL = imageDataDict.valueForKey("image_url") as NSString
                
                self.dataArray.append(selfieImgObj)
            }
            
            self.collectionView?.reloadData()
        }
    }
  }
  
  func removeObject<T:Equatable>(inout arr:Array<T>, object:T) -> T? {
    return nil
  }
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
    
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.dataArray.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as SelfieCollectionViewCell
    
    var rowIndex = self.dataArray.count - (indexPath.row + 1)
    var selfieRowObj = self.dataArray[rowIndex] as SelfieImage
    
    cell.backgroundColor = UIColor.blackColor()
    cell.selfieTitle.text = selfieRowObj.imageTitle
    
    var imgURL: NSURL = NSURL(string: selfieRowObj.imageThumbnailURL)!
    
    let request: NSURLRequest = NSURLRequest(URL: imgURL)
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
        response, data, error in
        if error == nil {
            var image = UIImage(data: data)
            
            dispatch_async(dispatch_get_main_queue(), {
                cell.selfieImgView.image = image
            })
        } else {
            println("Error: \(error.localizedDescription)")
        }
    }
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
  }
}

// Camera Extension

extension SelfieCollectionViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func displayCameraControl() {
    var imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
      
      if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front) {
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDevice.Front
      } else {
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
      }
    } else {
      imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    
    self.presentViewController(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
    self.dismissViewControllerAnimated(true, completion: nil)
    
    var image: UIImage!
    
    if picker.allowsEditing {
        image = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
    } else {
        image = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
    }
    
    presentComposeViewControllerWithImage(image)
  }
}

// Compose Selfie Extension

extension SelfieCollectionViewController : SelfieComposeDelegate {
  func presentComposeViewControllerWithImage(image:UIImage!) {
    // instantiate compose view controller to capture a caption
    let composeVC: ComposeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ComposeViewController") as ComposeViewController
    composeVC.composeDelegate = self
    composeVC.thumbImg = image
    
    // set the navigation controller of compose view controlle
    let composeNavVC = UINavigationController(rootViewController: composeVC)
    
    // present compose view controller
    self.navigationController?.presentViewController(composeNavVC, animated: true, completion: nil)
  }
  
  func reloadCollectionViewWithSelfie(selfieImgObject: SelfieImage) {
    self.dataArray.append(selfieImgObject)
    self.collectionView?.reloadData()
  }
}

// Selfie Details Extension

extension SelfieCollectionViewController : SelfieEditDelegate {
  func pushDetailsViewControllerWithSelfieObject(selfieRowObj:SelfieImage!) {
  }
  
  func deleteSelfieObjectFromList(selfieImgObject: SelfieImage) {    
  }
}
