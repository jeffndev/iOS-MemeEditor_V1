//
//  ViewController.swift
//  MemeUIMocks
//
//  Created by Jeff Newell on 9/17/15.
//  Copyright © 2015 Jeff Newell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //member VARIABLES
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraToolBtn: UIBarButtonItem!
    @IBOutlet weak var actionToolBtn: UIBarButtonItem!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    //state variables...
    var framePushedUp = false
    
    //member CONSTANTS
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    let DEFAULT_TOP_TEXT = "TOP"
    let TOP_TEXT_TAG = 0
    let DEFAULT_BOTTOM_TEXT = "BOTTOM"
    let BOTTOM_TEXT_TAG = 1
    
    //LIFECYCLE OVERRIDES...
    override func viewWillAppear(animated: Bool) {
        cameraToolBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        subscribeToKeyboardEventNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.tag = TOP_TEXT_TAG
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.tag = BOTTOM_TEXT_TAG
        bottomTextField.delegate = self
        
        resetTextFieldsToDefaults()
        
    }
    override func viewWillDisappear(animated: Bool) {
        UnSubscribeFromKeyboardEventNotifications()
    }
    
    //NOTIFICATION CENTER setup
    func subscribeToKeyboardEventNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func UnSubscribeFromKeyboardEventNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    //  notification SELECTORS
    func keyboardWillShow(notification: NSNotification){
        //Push view frame up above the keyboard
        if bottomTextField.editing {
            self.view.frame.origin.y -= self.getKeyboardHeight(notification)
            framePushedUp = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        //Pull view frame back down after it was pushed up
        if framePushedUp {
            self.view.frame.origin.y += self.getKeyboardHeight(notification)
            framePushedUp=false
        }
    }
    
    //ACTION methods
    @IBAction func shareAction() {
        let memedImage = extractMemedImage()
        let shareViewController = UIActivityViewController(activityItems: [memedImage],applicationActivities: nil)
        if #available(iOS 8.0, *) {
            shareViewController.completionWithItemsHandler = {
                (activity, success, items, error) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } 
        self.presentViewController(shareViewController, animated: true, completion: nil)
    }
    @IBAction func cancelAction(){
        mainImage.image = nil
        resetTextFieldsToDefaults()
        actionToolBtn.enabled=false
    }
    @IBAction func cameraAction(){
        //take a picture and use that picture for the meme
        let imagePick = UIImagePickerController()
        imagePick.delegate = self
        imagePick.sourceType = .Camera
        self.presentViewController(imagePick, animated: true, completion: nil)
    }
    @IBAction func albumAction(){
        //pick an image from the photo album
        let imagePick = UIImagePickerController()
        imagePick.delegate = self
        imagePick.sourceType = .PhotoLibrary
        self.presentViewController(imagePick, animated: true, completion: nil)
    }
    
    //HELPER methods
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    func resetTextFieldsToDefaults(){
        topTextField.text = DEFAULT_TOP_TEXT
        bottomTextField.text = DEFAULT_BOTTOM_TEXT
    }
    func extractMemedImage() -> UIImage {
        //UIGraphicsBeginImageContext(self.mainImage.frame.size)
        //self.mainImage.drawViewHierarchyInRect(self.mainImage.frame, afterScreenUpdates: true)
        
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let mi: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        return mi
    }
    
    //Image Picker DELEGATES
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainImage.image = img
            resetTextFieldsToDefaults()
        }
        actionToolBtn.enabled = ( mainImage.image != nil )
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Text Field DELEGATES
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("tf did begin editing")
        if textField.tag == TOP_TEXT_TAG && textField.text == DEFAULT_TOP_TEXT{
            textField.text = ""
        }else if textField.tag == BOTTOM_TEXT_TAG && textField.text == DEFAULT_BOTTOM_TEXT{
            textField.text = ""
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

