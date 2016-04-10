//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Ali Kayhan on 24/03/16.
//  Copyright © 2016 Ali Kayhan. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    

// MARK: - Outlets

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var y: CGFloat!
    

// MARK: - Lifecycle Functions
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareButton.enabled = (imagePickerView.image != nil)
        
        // Initial y value of frame's origin is saved to be used for keyboardWillShow function
        y = view.frame.origin.y
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
// MARK: - Text Field Attributes and Functions
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    func setupTextField(textField: UITextField, defaultText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .Center
        textField.delegate = self
    }
    
    func initializeTextFields() {
        setupTextField(topTextField, defaultText: "TOP")
        setupTextField(bottomTextField, defaultText: "BOTTOM")
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
// MARK: - Image Picker Functions
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Error while receiving image")
            return
        }
        
        imagePickerView.contentMode = .ScaleAspectFit
        imagePickerView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pickImage(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        presentViewController(pickerController, animated: true, completion: nil)
    }

    
// MARK: - Keyboard Functions
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            // Move view up by using the previously saved y value, otherwise when you click the text 
            // fields in "bottom-top-bottom again" sequence, the view moves up by 2*keyboardHeight
            view.frame.origin.y = y - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
// MARK: - Meme Functions
    
    func saveMeme() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and navigation bar
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navigation bar
        navBar.hidden = false
        toolBar.hidden = false
    
        return memedImage
    }
    
    
// MARK: - Actions
    
    @IBAction func shareMeme(sender: AnyObject) {
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            if ok {
                self.saveMeme()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        pickImage(.PhotoLibrary)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        pickImage(.Camera)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        imagePickerView.image = nil
        initializeTextFields()
    }

}

