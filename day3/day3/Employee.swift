//
//  Employee.swift
//  day3
//
//  Created by P090MMCTSE009 on 19/10/23.
//

import Foundation

struct EmployeeResponse:Decodable {
    var status,message: String
    var data: [Employee]?
}

struct Employee: Decodable {
    let id: Int
    let employeeName: String
    let employeeSalary, employeeAge: Int
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
        case profileImage = "profile_image"
    }
}
