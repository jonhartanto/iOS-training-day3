//
//  ViewController.swift
//  day3
//
//  Created by P090MMCTSE009 on 19/10/23.
//

import UIKit
import Alamofire
private let url: String="https://dummy.restapiexample.com/api/v1/employees"
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
            TableViewCell
        
        cell.labelName.text = self.employee[indexPath.row].employeeName
        cell.labelAge.text = String(self.employee[indexPath.row].employeeAge)
        cell.labelSalary.text = String(self.employee[indexPath.row].employeeSalary)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    

    @IBOutlet weak var tableView: UITableView!
    var employee: [Employee] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(
            nibName: "TableViewCell",
            bundle: nil
            ), forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetch()
        // Do any additional setup after loading the view.
    }
    func fetch(){
        guard let url = URL(string: url) else {return}
        
        let urlConvertible: URLConvertible = url
        
        AF.request(
            urlConvertible,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.queryString,
            headers: [:]
        ).response{ responsedata in
            guard let data = responsedata.data else {return}
            
            do{
                let employeeresp = try JSONDecoder().decode(EmployeeResponse.self, from: data)
                DispatchQueue.main.async{ [weak self] in
                    self?.employee = employeeresp.data ?? []
                    self?.tableView.reloadData()
                }
                
            }
            catch let err {
                print("Error in decode \(err)")
            }
        }
            
        
    }


}

