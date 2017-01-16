//
//  StartViewController.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logRegSwitch: UISegmentedControl!
    
    @IBOutlet weak var selectPictureButton: UIButton!
    let picker = UIImagePickerController()
    var userStorage = FIRStorage.storage()
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logRegSwitch.selectedSegmentIndex = 0
        
        loginButton.isHidden = true
        
        picker.delegate = self
        
        var storage = userStorage.reference(forURL: "gs://help-me-study-d97f5.appspot.com")
        storage = userStorage.child("users")
        ref = FIRDatabase.database().reference()
    }

    @IBAction func logRegSwitch(_ sender: Any) {
        // Register
        UIView.animate(withDuration: 0.4) {
            
            if (self.logRegSwitch.selectedSegmentIndex == 0){
                // register
                
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
                
                self.loginButton.alpha = 0
                self.loginButton.isUserInteractionEnabled = false
                
                self.profilePicture.alpha = 1
                self.profilePicture.isUserInteractionEnabled = true
                
                self.selectPictureButton.alpha = 1
                self.selectPictureButton.isUserInteractionEnabled = true
                
            } else {
                // login
                
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
                
                self.registerButton.alpha = 0
                self.registerButton.isUserInteractionEnabled = false
                
                self.loginButton.alpha = 1
                self.loginButton.isUserInteractionEnabled = true
                
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
    
    @IBAction func login(_ sender: Any) {
        guard emailTextField.text != "", passwordTextField.text != "" else{
            showAlertView(title: "Error!", withDescription: "Please make sure to fill in all the fields.", buttonText: "Ok, I will :)")
            return
        }
    }
    
    @IBAction func register(_ sender: Any) {
        guard firstNameTextField.text != "", lastNameTextField.text != "", emailTextField.text != "", passwordTextField.text != "", passwordConfirmationTextField.text != "" else{
            showAlertView(title: "Error!", withDescription: "Please make sure to fill in all the fields.", buttonText: "Ok, I will :)")
            return
        }
        if (passwordTextField.text != passwordConfirmationTextField.text){
            showAlertView(title: "Error!", withDescription: "Please make sure to fill in the same passwords.", buttonText: "Ok, I will :)")
        }
        else{
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordConfirmationTextField.text!, completion: {(user, Error) in
                
                if let error = Error{
                    print(error.localizedDescription)
                }
                
                if let user = user{
                    
                    let changeRequest = FIRAuth.auth()?.currentUser!.profileChangeRequest()
                    changeRequest?.displayName = self.firstNameTextField.text
                    changeRequest?.commitChanges(completion: nil)
                    
                    let imageRef = userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5)
                    
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: {(metadata, error ) in
                        if err != nil{
                            print(err!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil{
                                print(er!.localizedDescription)
                            }
                            if let url = url {
                                let userInfo: [String: Any] = ["uid" : user.uid,
                                                               "First name" : firstNameTextField.text!,
                                                               "Last name" : lastNameTextField.text!,
                                                               "email" : emailTextField.text!,
                                                               "urlToImage": url.absoluteString]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                        })
                    
                    
                    })
                    
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
    

