//
//  AddRecordViewController.swift
//  Homework19
//
//  Created by Kato on 5/11/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit

protocol CreateUpdateNoteDelegate {
    func shouldReloadTableviewData()
    func noteUpdated()
}

class AddRecordViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var updateCreateButton: UIButton!

    var createUpdateNoteDelegate: CreateUpdateNoteDelegate?
    
    var isEditingNote = false
    var note: Note?
    var curUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditingNote {
            updateCreateButton.setTitle("Update", for: .normal)
            
            if let note = note {
                textView.text = note.text
            }
        } else {
            updateCreateButton.setTitle("Save", for: .normal)
        }
    }
    
    @IBAction func CreateUpdateButton(_ sender: UIButton) {
        
        let text = textView.text ?? ""
        
        if isEditingNote {
            // update
            guard let n = note else {return}
            try! text.write(to: n.url, atomically: true, encoding: .utf8)
            
            createUpdateNoteDelegate?.noteUpdated()
        } else {
            // save
            let fm = FileManager.default
            let docsUrl = try! fm.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: self.curUrl, create: false)
            
            let fileName = "note_\(Int.random(in: 0...1000)).txt"
            
            let noteFileUrl = docsUrl.appendingPathComponent(fileName)
            
            try! text.write(to: noteFileUrl, atomically: true, encoding: .utf8)
            
            // clear field
            textView.text = ""
        }
        
        createUpdateNoteDelegate?.shouldReloadTableviewData()
    }
}
