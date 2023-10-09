//
//  UserDataCell.swift
//  CoreDataDemoProject
//
//  Created by Neosoft on 06/10/23.
//

import UIKit

class UserDataCell: UITableViewCell {
    var editData : EditData?
    var index : Int?
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblFname: UILabel!
    @IBOutlet weak var lblLname: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            if selected {
                self.contentView.backgroundColor = .clear
                btnEdit.tintColor = .clear
                btnDelete.tintColor = .clear

            } else {
                self.contentView.backgroundColor = .clear
                btnEdit.tintColor = .clear
                btnDelete.tintColor = .clear
            }
        }

    
    @IBAction func onEdit(_ sender: UIButton) {
        editData?.editDataInRow(index: index ?? 0)
    }
    @IBAction func onCancel(_ sender: UIButton) {
        editData?.DeleteDataInRow(index: index ?? 0)
    }
    
}
