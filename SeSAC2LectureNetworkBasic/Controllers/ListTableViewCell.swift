//
//  ListTableViewCell.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by 강민혜 on 7/27/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {
//    
//    static let identifier: String = "ListTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureUI() {
        backgroundColor = .clear
        titleLabel.font = .boldSystemFont(ofSize: 18)
    }
    
    
}







