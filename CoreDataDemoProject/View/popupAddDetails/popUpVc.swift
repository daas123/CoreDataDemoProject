//
//  popUpVc.swift
//  CoreDataDemoProject
//
//  Created by Neosoft on 09/10/23.
//

import UIKit

protocol ReloadTableViewData{
    func reloadTableView()
}

class popUpVc: UIViewController {
    var index : Int?
    var fname:String?
    var lname:String?
    var address:String?
    var contact:String?
    var image : UIImage?
    
    var imagePicker = UIImagePickerController()
    var isimageSelected = false
    
    private let viewmodel = MainViewModel()
    
    var deligate : ReloadTableViewData?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 20
        addDefaultValue()
    }
    
    func addDefaultValue(){
        txtFname.text = fname
        txtLname.text = lname
        txtAddress.text = address
        txtContact.text = contact
        userImage.image = image
    }
    
    func saveImageToDirectory(imageName:String){
        let fileUrl = URL.documentsDirectory.appending(component: imageName).appendingPathExtension("png")
        if let data = userImage.image?.pngData(){
            do {
                try data.write(to: fileUrl)
            }catch{
                print("Saving image to Document Directory Error")
            }
        }
    }
    
    @IBAction func onUploadImage(_ sender: UIButton) {
        openActionSheetForUploadImage()
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        deligate?.reloadTableView()
        self.dismiss(animated: true)
        
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        let imageName = UUID().uuidString
        let userdata = UserModel(fName: txtFname.text ?? "" , lName: txtLname.text ?? "", address: txtAddress.text ?? "" , contactNo: txtContact.text ?? "", image: imageName )
        self.viewmodel.editData(index: index ?? 0, user: userdata){
            res in
            if res.isEmpty{
                self.saveImageToDirectory(imageName: imageName)
                self.deligate?.reloadTableView()
                self.showAlert(msg: "Data Saved Succesfully" , isDismiss: true)
            }else{
                self.showAlert(msg: res)
            }
        }
    }
}

extension popUpVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openActionSheetForUploadImage(){
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openGallary()
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
       // alert.addAction(removeImageAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
           
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            isimageSelected = true
            image = img
            userImage.image = image
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            isimageSelected = true
            image = img
            userImage.image = image
        }
        
      //  _updateUserImage(image: image)
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Tapped")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
