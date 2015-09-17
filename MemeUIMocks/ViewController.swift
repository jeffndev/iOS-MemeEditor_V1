//
//  ViewController.swift
//  MemeUIMocks
//
//  Created by Jeff Newell on 9/17/15.
//  Copyright © 2015 Jeff Newell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraToolBtn: UIBarButtonItem!
    @IBOutlet weak var actionToolBtn: UIBarButtonItem!
    @IBOutlet weak var mainImage: UIImageView!
    
    //lifecycle overrides...
    override func viewWillAppear(animated: Bool) {
        cameraToolBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //ACTION methods
    @IBAction func shareAction() {
        print("share the meme...")
    }
    @IBAction func cancelAction(){
        
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
    //helper methods
    func resetTextFieldsToDefaults(){
        //TODO: replace the text with the default text (TOP, BOTTOM)
    }
    
    //Image Picker Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainImage.image = img
            resetTextFieldsToDefaults()
        }
        actionToolBtn.enabled = ( mainImage.image != nil )
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

