//
//  RecordsViewController.swift
//  Homework19
//
//  Created by Kato on 5/11/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit



class RecordsViewController: UIViewController {
    
    var isEditingRecord = false
    var notes = [Note]()
    var note: Note?
    var dirUrl: URL?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        fetchNotes()
    }
    
    private func fetchNotes() {
            
            notes.removeAll()
            
            let fm = FileManager.default
            
        let docsUrl = try! fm.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: self.dirUrl, create: false)
            
            let arr = try! fm.contentsOfDirectory(at: docsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for notePath in arr where notePath.pathExtension == "txt" {
                print(notePath)
    //            print(try! String(contentsOf: p))
                
                let note = Note(url: notePath)
                
                self.notes.append(note)
            }
            
            self.tableView.reloadData()
        }
    
    func deleteNote(url: URL) {
        let fm = FileManager.default
        do {
            try fm.removeItem(at: url)
        } catch let err {print(err.localizedDescription)}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "add_record_segue" {
            
            if let createUpdatePageVC = segue.destination as? AddRecordViewController {
                createUpdatePageVC.createUpdateNoteDelegate = self
                createUpdatePageVC.isEditingNote = self.isEditingRecord
                createUpdatePageVC.note = self.note
                createUpdatePageVC.curUrl = self.dirUrl
            }
            
        }
    }

}

extension RecordsViewController: CreateUpdateNoteDelegate {
    
    func shouldReloadTableviewData() {
            fetchNotes()
        }
        
        func noteUpdated() {
            note = nil
            isEditingRecord = false
        }
    
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "records_cell", for: indexPath) as! RecordsCell
        
        cell.textLabel?.text = notes[indexPath.row].text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (a, v, handler) in
            self.isEditingRecord = true
            //self.record = self.records[indexPath.row]
            self.performSegue(withIdentifier: "add_record_segue", sender: nil)
        }
        
        let config = UISwipeActionsConfiguration(actions: [edit])
        
        return config
        
    }
    
    
}

struct Note {
    var url: URL
    var text: String {
        return try! String(contentsOf: url)
    }
}

