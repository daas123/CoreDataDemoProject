//
//  Employee+CoreDataProperties.swift
//  CoreDataDemoProject
//
//  Created by Neosoft on 06/10/23.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var address: String?
    @NSManaged public var fName: String?
    @NSManaged public var lName: String?
    @NSManaged public var contactNo: String?

}

extension Employee : Identifiable {

}
