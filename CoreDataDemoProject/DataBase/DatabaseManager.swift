//
//  DatabaseManager.swift
//  CoreDataDemoProject
//
//  Created by Neosoft on 06/10/23.
//

import UIKit
import CoreData
class DataBaseManager{
    
    private var context : NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveData(user:UserModel , complition : @escaping (String)->Void){
        let employee = Employee(context: context)
        employee.fName = user.fName
        employee.lName = user.lName
        employee.address = user.address
        employee.contactNo = user.contactNo
        employee.imageName = user.image
        do{
            try context.save()
        }catch{
            print("some thing went wrong")
            complition("some thing went wrong")
        }
        complition("")
    }
    
    func fetchData(complition : @escaping (Bool,[Employee]?)->Void){
        var users : [Employee] = []
        do {
            users = try context.fetch(Employee.fetchRequest())
        }catch{
            print("Some thing wen wrong")
            complition(false,nil)
        }
        complition(true,users)
    }
    
    func editData(index:Int ,user : UserModel ,completion : @escaping (String)->Void){
        guard index >= 0 else {
            completion("Invalid index")
            return
        }
        
        do {
            let employeesdata = try context.fetch(Employee.fetchRequest()) as! [Employee]
            guard index < employeesdata.count else {
                completion("Index out of bounds")
                return
            }
            let employeeToEdit = employeesdata[index]
            employeeToEdit.fName = user.fName
            employeeToEdit.lName = user.lName
            employeeToEdit.address = user.address
            employeeToEdit.contactNo = user.contactNo
            employeeToEdit.imageName = user.image
            try context.save()
            completion("")
        }catch{
            print("Something went wrong while editing the data: \(error.localizedDescription)")
            completion("Something went wrong while deleting data")
        }

        
    }

    func deleteData(index:Int , completion: @escaping (String) -> Void) {
        guard index >= 0 else {
            completion("Invalid index")
            return
        }
        
        do {
            let employeesdata = try context.fetch(Employee.fetchRequest()) as! [Employee]
            guard index < employeesdata.count else {
                completion("Index out of bounds")
                return
            }
            let employeeToDelete = employeesdata[index]
            context.delete(employeeToDelete)
            try context.save()
            completion("")
        }catch{
            print("Something went wrong while deleting data: \(error.localizedDescription)")
            completion("Something went wrong while deleting data")
        }
    }
    
}
