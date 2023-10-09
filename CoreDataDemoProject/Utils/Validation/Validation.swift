//
//  Validation.swift
//  CoreDataDemoProject
//
//  Created by Neosoft on 06/10/23.
//

import Foundation
class Validation{
    func userDataFiledValidation(user : UserModel? ,complition:@escaping (String)->Void){
        
        guard let firstname = user?.fName , !firstname.isEmpty else{
            complition("Enter First Name")
            return
        }
        
        guard let lastname = user?.lName , !lastname.isEmpty else{
            complition("Enter Last Name")
            return
        }
        
        guard let add = user?.address , !add.isEmpty else{
            complition("Enter the address")
            return
        }
        
        guard let contact = user?.contactNo , !contact.isEmpty else{
            complition("Enter the Contact No")
            return
        }
        complition("")
    }
}
