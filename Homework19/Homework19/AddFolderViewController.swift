//
//  AddFolderViewController.swift
//  Homework19
//
//  Created by Kato on 5/11/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

protocol CreateUpdatePageDelegate {
    func shouldReloadTableviewData()
    func folderUpdated()
}

class AddFolderViewController: UIViewController {
    
    
   // var newFolder = [Folder]()
    var createUpdatePageDelegate: CreateUpdatePageDelegate?
    
    var isEditingFolder = false
    var folder: Folder?

    @IBOutlet weak var newFolderTextField: UITextField!
    
    @IBOutlet weak var updateCreateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func onAddFolderTapped(_ sender: UIButton) {
        
        let text = newFolderTextField.text ?? ""
            
            if isEditingFolder{
                // update
                guard let f = folder else {return}
                try! text.write(to: f.url, atomically: true, encoding: .utf8)
                
                createUpdatePageDelegate?.folderUpdated()
            } else {
                // save
                let fm = FileManager.default
                let docsUrl = try! fm.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                
                let folderName = text
                
                let noteFileUrl = docsUrl.appendingPathComponent(folderName)
                
                try! fm.createDirectory(at: noteFileUrl, withIntermediateDirectories: true, attributes: nil)
 //               try! text.write(to: noteFileUrl, atomically: true, encoding: .utf8)
                
                // clear field
                newFolderTextField.text = ""
            }
            
            createUpdatePageDelegate?.shouldReloadTableviewData()
        }
        
        /*let addfolder = Folder()
        addfolder.folderName = newFolderTextField.text!
        
        if addfolder.folderName == "" {
            let alert1 = UIAlertController(title: "Try Again", message: "Enter the name of the folder.", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert1, animated: true, completion: nil)
        }
            
        else {
            
            newFolder.append(addfolder)
            
            if let firstViewController = self.navigationController?.viewControllers.first {
                
                let vc = firstViewController as! FolderViewController
                vc.folders = self.newFolder
                vc.collectionView.reloadData()
                self.navigationController?.popToViewController(firstViewController, animated: true)
            }
        }
    }*/
    
}
