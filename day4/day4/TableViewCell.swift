//
//  TableViewCell.swift
//  day4
//
//  Created by P090MMCTSE009 on 19/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var salaryLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
