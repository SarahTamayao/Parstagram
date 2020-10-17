//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Omeke, Jasmine on 10/17/20.
//

import UIKit
import AlamofireImage
import Parse
import AVKit
import MobileCoreServices

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //commentField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.view.snapshotView(afterScreenUpdates: true)
        
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismiss(animated:true, completion:nil)))
        //self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        
        let post = PFObject(className: "Posts")
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!) //exclamation point to unwrap it
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
        
        //how easy it is to set up a schema and parse
//        let pet = PFObject(className: "Pets") //pets table will be created on the fly
//        pet["name"] = "Spencer"
//        pet["weight"] = 50
//        pet["owner"] = PFUser.current()! //whoever is the logged in owner
//        pet.saveInBackground(){ (success, error) in
//            if success {
//                print("saved")
//            } else {
//                print("error!")
//            }
//        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        
        //easy way, BUT not very configurable
        picker.delegate = self //let me know what the user picked as photo
        picker.allowsEditing = true //second screen to user to allow them to edit photo
//        picker.mediaTypes = [kUTTypeImage as String]
        
        
        
        
        print("In tap gesture")
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Camera ready")
            picker.sourceType = .photoLibrary
//            picker.cameraCaptureMode = .photo
//            picker.cameraDevice = .rear
            //addChild(picker)
            
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        
        let scaledImage = image.af_imageScaled(to: size)
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
