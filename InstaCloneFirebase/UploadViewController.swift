//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Hakan Baran on 27.09.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var commitText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImage.isUserInteractionEnabled = true
        
        let uploadImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedImage))
        uploadImage.addGestureRecognizer(uploadImageRecognizer)
        
        

        
    }
    
    @objc func selectedImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(tittleImput: String, messageImput: String) {
        
        let alert = UIAlertController(title: tittleImput , message: messageImput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    

    @IBAction func saveClicked(_ sender: Any) {
        
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        
        let mediaFolder = storageReferance.child("Media")
        
        if let data = uploadImage.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(tittleImput: "!!Error!!", messageImput: error?.localizedDescription ?? "!Error!" )
                } else {
                    
                    imageReferance.downloadURL { url1, error1 in
                        if error1 == nil {
                            
                            let imageUrl = url1?.absoluteString
                            
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReferance : DocumentReference? = nil
                            
                            
                            let firestorePost = ["imageUrl" : imageUrl! , "postedBy" : Auth.auth().currentUser!.email, "postComment" : self.commitText.text!, "date" : FieldValue.serverTimestamp() , "likes" : 0] as [String : Any]
                            
                            
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(tittleImput: "Error3!", messageImput: error?.localizedDescription ?? "Error4")
                                    
                                } else {
                                    
                                    self.uploadImage.image = UIImage(named: "camera")
                                    self.commitText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
}
