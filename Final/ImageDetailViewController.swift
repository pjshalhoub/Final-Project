//
//  ImageDetailViewController.swift
//  Final
//
//  Created by PJ Shalhoub on 11/30/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    @IBOutlet weak var photoTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    var detailImageStruct: ImageStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = detailImageStruct.image
        photoTextView.text = detailImageStruct.text
        
    }
    

    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
    }
    
    


}
