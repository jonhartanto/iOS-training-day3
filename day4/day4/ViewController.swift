//
//  ViewController.swift
//  day4
//
//  Created by P090MMCTSE009 on 19/10/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var employee: [EmployeeModel] = []
    var viewModel:EmployeeViewModel!
    var onErrorScheme:(Error) -> Void = {err in
            print ("Error in get \(err)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.employeeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
            TableViewCell
        
        
        cell.idLabel.text = String(self.viewModel.employeeData[indexPath.row].id)
        cell.nameLabel.text = self.viewModel.employeeData[indexPath.row].name
        cell.salaryLabel.text = String(self.viewModel.employeeData[indexPath.row].salary)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editEmployee(viewModel.employeeData[indexPath.row].id, viewModel.employeeData[indexPath.row].name,viewModel.employeeData[indexPath.row].salary)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.delete(viewModel.employeeData[indexPath.row].id)
            
            
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func editEmployee(_ id:Int, _ name:String, _ salary:Int){
        let alert = UIAlertController(title: "Edit Employee", message: "Fill the form below to edit employee", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {tf in
            tf.isEnabled = false
            tf.placeholder = "Id"
            tf.text = "\(id)"
        })
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "Name"
            tf.text = name
        })
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "Salary"
            tf.text = String(salary)
        })
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default,handler:  {
            action in
            
            self.viewModel.update(id, alert.textFields![1].text!,Int(alert.textFields![2].text!)!)
            
            let success = UIAlertController(title: "Success", message: "Data employee updated", preferredStyle: .alert)
            success.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
            self.present(success, animated: true)
            
            
            
        }))
        
        self.present(alert,animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(
            nibName: "TableViewCell",
            bundle: nil
            ), forCellReuseIdentifier: "cell")
        
        viewModel=EmployeeViewModel()
        viewModel.bindDataToVC = {
            self.tableView.reloadData()
        }
        viewModel.getEmployee(onError: onErrorScheme)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    @IBAction func addEmployee(_ sender: Any) {
        let alert = UIAlertController(title: "New Employee", message: "Fill the form below to add new employee", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {
            tf in tf.placeholder = "Id"
        })
        
        alert.addTextField(configurationHandler: {
            tf in tf.placeholder = "Name"
        })
        
        alert.addTextField(configurationHandler: {
            tf in tf.placeholder = "Salary"
        })
        
        
        alert.addAction(UIAlertAction(title: "Tambah", style: .default, handler: { action in
            if alert.textFields![0].text!.isEmpty || alert .textFields![1].text!.isEmpty {
                let warning = UIAlertController(title: "Warning", message: "Fill all the textfields", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
                self.present(warning,animated: true)
            }
            else
            {
                self.viewModel.create(Int(alert.textFields![0].text!) ?? 0, alert.textFields![1].text!,Int(alert.textFields![2].text!)!)
                
                let success = UIAlertController(title: "Success", message: "Data employee added", preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
                self.present(success,animated: true)
                
                
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default,handler: nil))
        
        self.present(alert,animated: true)
    }
    

}
