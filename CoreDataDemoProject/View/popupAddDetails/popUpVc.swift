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
    
    private let viewmodel = MainViewModel()
    
    var deligate : ReloadTableViewData?
    
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
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        deligate?.reloadTableView()
        self.dismiss(animated: true)
        
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        let userdata = UserModel(fName: txtFname.text ?? "" , lName: txtLname.text ?? "", address: txtAddress.text ?? "" , contactNo: txtContact.text ?? "")
        
        self.viewmodel.editData(index: index ?? 0, user: userdata){
            res in
            if res.isEmpty{
                self.showAlert(msg: "Data Saved Succesfully" , isDismiss: true)
            }else{
                self.showAlert(msg: res)
            }
        }
    }
}

