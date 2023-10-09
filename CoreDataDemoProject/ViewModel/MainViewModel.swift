//
//  MainViewModel.swift
//  CoreDataDemoProject
//
//  Created by Neosoft on 06/10/23.
//

import Foundation
import UIKit

protocol EditData{
    func editDataInRow(index: Int)
    func DeleteDataInRow(index: Int)
}

class MainViewModel{
    static var FetchedData : [Employee]?
    
    func sendDataToDataBase(user : UserModel ,complition:@escaping (String)->Void){
        Validation().userDataFiledValidation(user : user){
            str in
            if str.isEmpty{
                DataBaseManager().saveData(user: user){
                    res in
                    complition(res)
                    
                }
            }else{
                complition(str)
            }
        }
    }
    
    
    func fetchData(complition:@escaping(String)->Void){
        DataBaseManager().fetchData(){
            (bool,data) in
            if bool{
                MainViewModel.FetchedData = data
                complition("")
            }else{
                print("some thing went wrong")
            }
            complition("Some Thing went Wrong")
        }
    }
    
    func editData(index:Int, user:UserModel , complition:@escaping(String)->Void ){
        
        guard self.deleteImageByIndex(index: index) else{
            complition("Some Thing wentWrong")
            return
        }
        Validation().userDataFiledValidation(user : user){
            str in
            if str.isEmpty{
                DataBaseManager().editData(index: index, user: user){
                    res in
                    if res.isEmpty{
                        complition("")
                    }else{
                        complition("Some thing went wrong")
                    }
                }
            }else{
                complition(str)
            }
        }
    }
    func DeletData(index: Int ,complition:@escaping(String)->Void){
        
        guard self.deleteImageByIndex(index: index) else{
            complition("Some Thing wentWrong")
            return
        }

        DataBaseManager().deleteData(index: index){
            res in
            if res.isEmpty{
                complition("")
            }else{
                complition("Some Thing went Wrong")
            }
        }
    }
    
    func deleteImageByIndex(index:Int) -> Bool{
        let fileManager = FileManager.default
        let fileName = MainViewModel.FetchedData?[index].imageName ?? ""
        let imageurl = URL.documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("png")
        do {
            try fileManager.removeItem(at: imageurl)
            return true
        } catch {
            return false
        }
        
    }
    
}


