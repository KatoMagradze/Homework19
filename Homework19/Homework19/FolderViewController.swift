//
//  ViewController.swift
//  Homework19
//
//  Created by Kato on 5/11/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController {
    
    var folders = [Folder]()
    var folder : Folder?
    var selectedCell = 0

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchFolders()
        // Do any additional setup after loading the view.
    }
    
   /* override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
 */

    @IBAction func onAddTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "add_folder_segue", sender: self)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "add_folder_segue" {
            let vc = segue.destination as! AddFolderViewController
            vc.createUpdatePageDelegate = self
        }
        else if let id = segue.identifier, id == "folder_contents_segue" {
            let vc = segue.destination as! RecordsViewController
            vc.dirUrl = folders[selectedCell].url
        }
    }

    private func fetchFolders() {
        
        folders.removeAll()
        
        let fm = FileManager.default
        
        let docsUrl = try! fm.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
        
        let arr = try! fm.contentsOfDirectory(at: docsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        for folderPath in arr where folderPath.hasDirectoryPath {
            print(folderPath)
//          print(try! String(contentsOf: p))
            
            let folder = Folder(folderName: folderPath.lastPathComponent, url: folderPath)
            
            self.folders.append(folder)
        }
        
        self.collectionView.reloadData()
    }
    
}

extension FolderViewController: CreateUpdatePageDelegate {
    func shouldReloadTableviewData() {
        fetchFolders()
    }
    
    func folderUpdated() {
        folder = nil
    }
}

extension FolderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folder_cell", for: indexPath) as! FolderCell
        
        cell.folderLabel.text = folders[indexPath.row].folderName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedCell = indexPath.row
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let displayVC = storyboard.instantiateViewController(withIdentifier: "records_vc")

        if let vc = displayVC as? RecordsViewController {
           
            //code
        
        }
        self.navigationController?.pushViewController(displayVC, animated: true)
    }
    
}
extension FolderViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let itemWidth = collectionView.frame.width / 2
    
        return CGSize(width: itemWidth - 20 - 20, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 30, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


struct Folder {
    var folderName: String
    var url: URL
}


