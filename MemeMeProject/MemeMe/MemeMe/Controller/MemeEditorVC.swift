//
//  MemeEditorVC.swift
//  MemeMe
//
//  Created by Amal Tawfeik on 19.04.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!

    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
  
    var isFirstTopEditing = true
    var isFirstBottomEditing = true

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.strokeWidth:  -3
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }


    // MARK: UITextFieldDelegate Functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(isFirstBottomEditing || isFirstTopEditing) {
            textField.text = ""
            if(textField == topText) {
                isFirstTopEditing = false
            } else {
                isFirstBottomEditing = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: UIImagePickerControllerDelegate Functions

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] {
            imageView.image = image as? UIImage
            shareBtn.isEnabled = true
        }
    }
    
    
    // MARK: IBAction Functions
    
    @IBAction func pickAnAlbumImage(_ sender: Any) {
        pickPhotoFromSource(.photoLibrary)
    }
    
    @IBAction func takeAphoto(_ sender: Any) {
        pickPhotoFromSource(.camera)
    }
    
    @IBAction func shareMemedImage(_ sender: Any) {
        saveMemedImage()
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: My Own Functions
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(_ notification: Notification) {
        if(bottomText.isFirstResponder) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func hideKeyboard(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func pickPhotoFromSource(_ source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self;
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }

    func saveMemedImage() {
        let activityItem: [AnyObject] = [generateMemedImage() as AnyObject]
        let avctivityController = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        self.present(avctivityController, animated: true, completion: nil)

        avctivityController.completionWithItemsHandler = { (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                // Create the Meme Object
                let meme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, originalImage: self.imageView.image!, memedImage: self.generateMemedImage())
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.memesList.append(meme)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func generateMemedImage() -> UIImage {
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    func setupTextFields () {
        configureTextField(topText, MemeStrings.MemeTopText)
        configureTextField(bottomText, MemeStrings.MemeBottomText)
    }
    
    func configureTextField(_ textField: UITextField, _ defaultText: String) {
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
}

