//
//  AddPostTableViewController.swift
//  3rdplanet
//
//  Created by zeus on 3/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    var image: UIImage?
    
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        
        if let image = image,
            let caption = commentTextField.text, !caption.isEmpty {
            
            PostController.sharedController.createPost(image: image, caption: caption, completion: nil)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "Missing Information", message: "You did not enter all required information!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPhotoSelect" {
            let embedViewController = segue.destination as? PhotoSelectViewController
            embedViewController?.delegate = self
        }
    }
}

extension AddPostTableViewController: PhotoSelectViewControllerDelegate {
    func photoSelectViewControllerSelected(image: UIImage) {
        self.image = image
    }
}


