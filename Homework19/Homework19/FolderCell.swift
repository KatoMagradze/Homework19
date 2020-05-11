//
//  FolderCell.swift
//  Homework19
//
//  Created by Kato on 5/11/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class FolderCell: UICollectionViewCell {
    

  //  @IBOutlet weak var folderImageView: UIImageView!
    
 //   @IBOutlet weak var folderNameLabel: UILabel!
    
    @IBOutlet weak var folderLabel: UILabel!
    
    var folder: Folder! {
        didSet {
            folderLabel.text = folder.folderName
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
