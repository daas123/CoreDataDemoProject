//
//  MainPageVc.swift
//  CoreDataDemoProject
//
//  Created by Neosoft on 06/10/23.
//

import UIKit

class MainPageVc: UIViewController{
    
    
    let viewModel = MainViewModel()
    var isimageSelected = false
    
    @IBOutlet weak var userDataTableView: UITableView!
    //User Input TextFieds
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    // TableView label For Display
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataTableView.delegate = self
        userDataTableView.dataSource = self
        fetchData()
    }
    
    func fetchData(){
        viewModel.fetchData {
            res in
            if res.isEmpty{
                self.userDataTableView.reloadData()
            }else{
                
            }
        }
    }
    
    func initializedTextView(){
        txtFname.text = ""
        txtLname.text = ""
        txtAddress.text = ""
        txtContactNo.text = ""
        userImage.image = UIImage(named: "user")
        isimageSelected = false
    }
    @IBAction func onReset(_ sender: UIButton) {
        initializedTextView()
    }
    @IBAction func onSave(_ sender: UIButton) {
        let imagename = UUID().uuidString
        let userdata = UserModel(fName: txtFname.text ?? "" , lName: txtLname.text ?? "", address: txtAddress.text ?? "", contactNo: txtContactNo.text ?? "", image: imagename)
        guard isimageSelected == true else{
            self.showAlert(msg: "Select image")
            return
        }
        viewModel.sendDataToDataBase(user: userdata){
            res in
            if res.isEmpty{
                self.saveImageToDirectory(imageName: imagename)
                self.fetchData()
                self.showAlert(msg: "Data Saved Succesfully")
                self.initializedTextView()
            }else{
                self.showAlert(msg: res)
            }
        }
    }
    @IBAction func onUploadImage(_ sender: UIButton) {
        openActionSheetForUploadImage()
    }
    
}
extension MainPageVc : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MainViewModel.FetchedData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserDataCell
        cell.index = indexPath.row
        cell.editData = self
        cell.lblFname.text = MainViewModel.FetchedData?[indexPath.row].fName
        cell.lblLname.text = MainViewModel.FetchedData?[indexPath.row].lName
        cell.lblAddress.text = MainViewModel.FetchedData?[indexPath.row].address
        cell.lblContactNo.text = MainViewModel.FetchedData?[indexPath.row].contactNo
        let imageurl = URL.documentsDirectory.appending(components: MainViewModel.FetchedData?[indexPath.row].imageName ?? "").appendingPathExtension("png")
        cell.userImage.image = UIImage(contentsOfFile: imageurl.path)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension MainPageVc : EditData{
    func editDataInRow(index: Int) {
        if let viewControllerToPresent = self.storyboard?.instantiateViewController(withIdentifier: "popUpVc") as? popUpVc {
            viewControllerToPresent.index = index
            viewControllerToPresent.deligate = self
            viewControllerToPresent.fname = MainViewModel.FetchedData?[index].fName
            viewControllerToPresent.lname = MainViewModel.FetchedData?[index].lName
            viewControllerToPresent.address = MainViewModel.FetchedData?[index].address
            viewControllerToPresent.contact = MainViewModel.FetchedData?[index].contactNo
            let imageurl = URL.documentsDirectory.appending(components: MainViewModel.FetchedData?[index].imageName ?? "").appendingPathExtension("png")
            viewControllerToPresent.image = UIImage(contentsOfFile: imageurl.path)
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func showNewAlert(msg : String , index : Int){
        let alert = UIAlertController(title: nil, message: msg , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default){_ in
            self.viewModel.DeletData(index: index){
                res in
                if res.isEmpty {
                    self.fetchData()
                    self.showAlert(msg: "Data Got Deleted")
                }else{
                    self.showAlert(msg: "Some thing went Wrong")
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func DeleteDataInRow(index: Int) {
        showNewAlert(msg: "Sure you Want to Delete" ,index: index)
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
}

extension MainPageVc : ReloadTableViewData{
    func reloadTableView() {
        self.userDataTableView.reloadData()
    }
}
extension MainPageVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
