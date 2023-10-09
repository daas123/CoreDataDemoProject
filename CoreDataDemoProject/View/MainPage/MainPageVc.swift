//
//  MainPageVc.swift
//  CoreDataDemoProject
//
//  Created by Neosoft on 06/10/23.
//

import UIKit

class MainPageVc: UIViewController{
    
    
    let viewModel = MainViewModel()
    
    @IBOutlet weak var userDataTableView: UITableView!
    //User Input TextFieds
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    
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
    }
    @IBAction func onReset(_ sender: UIButton) {
        initializedTextView()
    }
    @IBAction func onSave(_ sender: UIButton) {
        
        let userdata = UserModel(fName: txtFname.text ?? "" , lName: txtLname.text ?? "", address: txtAddress.text ?? "", contactNo: txtContactNo.text ?? "")
        
        viewModel.sendDataToDataBase(user: userdata){
            res in
            if res.isEmpty{
                self.fetchData()
                self.showAlert(msg: "Data Saved Succesfully")
                self.initializedTextView()
            }else{
                self.showAlert(msg: res)
            }
        }
    }
    
}
extension MainPageVc : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.FetchedData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserDataCell
        cell.index = indexPath.row
        cell.editData = self
        cell.lblFname.text = viewModel.FetchedData?[indexPath.row].fName
        cell.lblLname.text = viewModel.FetchedData?[indexPath.row].lName
        cell.lblAddress.text = viewModel.FetchedData?[indexPath.row].address
        cell.lblContactNo.text = viewModel.FetchedData?[indexPath.row].contactNo
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MainPageVc : EditData{
    func editDataInRow(index: Int) {
        if let viewControllerToPresent = self.storyboard?.instantiateViewController(withIdentifier: "popUpVc") as? popUpVc {
            viewControllerToPresent.index = index
            viewControllerToPresent.deligate = self
            viewControllerToPresent.fname = viewModel.FetchedData?[index].fName
            viewControllerToPresent.lname = viewModel.FetchedData?[index].lName
            viewControllerToPresent.address = viewModel.FetchedData?[index].address
            viewControllerToPresent.contact = viewModel.FetchedData?[index].contactNo
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
}

extension MainPageVc : ReloadTableViewData{
    func reloadTableView() {
        self.userDataTableView.reloadData()
    }
}
