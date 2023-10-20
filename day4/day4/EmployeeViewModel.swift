//
//  EmployeeViewModel.swift
//  day4
//
//  Created by P090MMCTSE009 on 19/10/23.
//

import Foundation
import UIKit
import CoreData

class EmployeeViewModel:NSObject{
    var onErrorScheme:(Error) -> Void = {err in
            print ("Error in get \(err)")
    }
    private(set) var employeeData: [EmployeeModel] = [] {
        didSet {
            self.bindDataToVC()
        }
    }
    
    var bindDataToVC: () -> () = {}
    
    func getEmployee(
        onError: @escaping (Error) -> Void)
    {
        var EmployeeResult: [EmployeeModel] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            EmployeeResult = result.map { employee in
                return EmployeeModel(id: employee.value(forKey: "id") as! Int,
                                     name: employee.value(forKey: "name") as! String,
                                     salary: employee.value(forKey: "salary") as! Int
                )
            }
        } catch let err{
            onError(err)
        }
        
        self.employeeData=EmployeeResult
    }
    
    func create(_ id: Int, _ name:String,_ salary:Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext)

        let insert = NSManagedObject(entity: userEntity!, insertInto: managedContext)
        insert.setValue(id, forKey: "id")
        insert.setValue(name, forKey: "name")
        insert.setValue(salary, forKey: "salary")
        
        appDelegate.saveContext()
        
        getEmployee(onError: onErrorScheme)
        
        
    }
    func update(_ id: Int, _ name:String, _ salary:Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Employee")
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do{
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            dataToUpdate.setValue(name, forKey: "name")
            dataToUpdate.setValue(salary, forKey: "salary")
            
            try managedContext.save()
            getEmployee(onError: onErrorScheme)
        }catch let err {
            print(err)
        }
        
    }
    func delete(_ id:Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest.init(entityName: "Employee")
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        do
        {
            let dataToDelete = try managedContext.fetch(fetchRequest)[0] as!
            NSManagedObject
            managedContext.delete(dataToDelete)
            
            try managedContext.save()
            getEmployee(onError: onErrorScheme)
            
        }catch let err{
            print(err)
        }
    }
}
