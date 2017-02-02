//
//  StartViewController.swift
//  Help me study
//
//  This is the first viewcontroller of the application. Here the user can register him or
//  herself or login. If the user is already logged in, he or she will skip this screen and
//  will go straight to the menu.
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logRegSwitch: UISegmentedControl!
    @IBOutlet weak var selectPictureButton: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage : FIRStorageReference!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // source: http://stackoverflow.com/questions/30635160/how-to-check-if-the-ios-app-is-running-for-the-first-time-using-swift
        if(UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
        }
        else
        {
            // This is the first launch ever
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            showAlertView(title: "Welcome to Help Me Study!", withDescription: "This application is made so you can study more efficiently! The timer you can set yourself and breaks are 5 minutes long. Search for friends in users and follow and unfollow them. In rankings you can see your friends ranked by the minutes they studied. But be careful! When you exit the Help me study screen the timer will stop! Enjoy and study hard!", buttonText: "Understood!")
        }
        logRegSwitch.selectedSegmentIndex = 0
        
        self.navigationController?.isNavigationBarHidden = true
        
        picker.delegate = self
        
        let storage = FIRStorage.storage().reference(forURL: "gs://help-me-study-d97f5.appspot.com")
        userStorage = storage.child("users")
        ref = FIRDatabase.database().reference()
        
        // Source: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    // Source: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func logRegSwitch(_ sender: Any) {
        UIView.animate(withDuration: 0.4) {
            
            if (self.logRegSwitch.selectedSegmentIndex == 0){
                // Register
                
                self.registerButton.setTitle("Register", for: .normal)
                
                self.emailTextField.alpha = 1
                self.emailTextField.isUserInteractionEnabled = true
                
                self.passwordTextField.alpha = 1
                self.passwordTextField.isUserInteractionEnabled = true
                
                self.firstNameTextField.alpha = 1
                self.firstNameTextField.isUserInteractionEnabled = true
                
                self.lastNameTextField.alpha = 1
                self.lastNameTextField.isUserInteractionEnabled = true
                
                self.passwordConfirmationTextField.alpha = 1
                self.passwordConfirmationTextField.isUserInteractionEnabled = true
                
                self.registerButton.alpha = 1
                self.registerButton.isUserInteractionEnabled = true
                
                self.profilePicture.alpha = 1
                self.profilePicture.isUserInteractionEnabled = true
                
                self.selectPictureButton.alpha = 1
                self.selectPictureButton.isUserInteractionEnabled = true
                
            } else {
                // Login
                
                self.registerButton.setTitle("Login", for: .normal)
                
                self.emailTextField.alpha = 1
                self.emailTextField.isUserInteractionEnabled = true
                
                self.passwordTextField.alpha = 1
                self.passwordTextField.isUserInteractionEnabled = true
                
                self.firstNameTextField.alpha = 0
                self.firstNameTextField.isUserInteractionEnabled = false
                
                self.lastNameTextField.alpha = 0
                self.lastNameTextField.isUserInteractionEnabled = false
                
                self.passwordConfirmationTextField.alpha = 0
                self.passwordConfirmationTextField.isUserInteractionEnabled = false
                
                self.registerButton.alpha = 1
                self.registerButton.isUserInteractionEnabled = true
                
                self.profilePicture.alpha = 0
                self.profilePicture.isUserInteractionEnabled = false
                
                self.selectPictureButton.alpha = 0
                self.selectPictureButton.isUserInteractionEnabled = false

            }
        }
    }
    
    @IBAction func selectPicture(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilePicture.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Source: https://www.youtube.com/watch?v=AsSZulMc7sk
    @IBAction func register(_ sender: Any) {
        if registerButton.currentTitle == "Register"{
        guard firstNameTextField.text != "", lastNameTextField.text != "", emailTextField.text != "", passwordTextField.text != "", passwordConfirmationTextField.text != "" else{
            showAlertView(title: "Error!", withDescription: "Please make sure to fill in all the fields.", buttonText: "Ok, I will.")
            return
            }
        if (passwordTextField.text != passwordConfirmationTextField.text){
            showAlertView(title: "Error!", withDescription: "Please make sure to fill in the same passwords.", buttonText: "Ok, I will.")
        }
        if self.profilePicture.image == nil {
            self.showAlertView(title: "Error!", withDescription: "No picture was selected. Please select one to proceed.", buttonText: "Ok, I will.")
        }
            if !(emailTextField.text?.contains("@"))!{
                self.showAlertView(title: "Error!", withDescription: "An incorrect emailaddress was given. Please change it.", buttonText: "Ok, I will.")
            }
        else{
            
            let fullName = firstNameTextField.text! + " " + lastNameTextField.text!
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordConfirmationTextField.text!, completion: {(user, Error) in
                
                if let error = Error{
                    print(error.localizedDescription)
                    self.showAlertView(title: "Error!", withDescription: error.localizedDescription, buttonText: "Ok, thanks!")
                }
                
                if let user = user{
                    
                    let changeRequest = FIRAuth.auth()?.currentUser!.profileChangeRequest()
                    changeRequest?.displayName = self.firstNameTextField.text
                    changeRequest?.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5)
                    
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: {(metadata, err ) in
                        if err != nil{
                            print(err!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil{
                                print(er!.localizedDescription)
                            }
                            if let url = url {
                                let userInfo: [String: Any] = ["uid" : user.uid,
                                                               "Full name" : fullName,
                                                               "email" : self.emailTextField.text!,
                                                               "urlToImage": url.absoluteString,
                                                               "points": 0]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "navVC")
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                        })
                    })
                    uploadTask.resume()
                }
            })
        }}
        else{
            
            guard emailTextField.text != "", passwordTextField.text != "" else{
                showAlertView(title: "Error!", withDescription: "Please make sure to fill in all the fields.", buttonText: "Ok, I will.")
                return
            }
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if let error = error{
                    print(error.localizedDescription)
                    self.showAlertView(title: "Error!", withDescription: "Please fill in the right email and password!", buttonText: "Ok, I will.")
                }
                if user != nil {
                    let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "navVC")
                    self.present(vc, animated: true, completion: nil)
                }
            })
    }
    }
    
    // Show an alert
    func showAlertView(title: String, withDescription description: String, buttonText text: String) {        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: text, style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
