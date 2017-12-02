//
//  ImageViewController.swift
//  Final
//
//  Created by PJ Shalhoub on 11/30/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imagePicker = UIImagePickerController()
    var imageStructArray = [ImageStruct]()
    var defaultsData = UserDefaults.standard
    var returningFromSave = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        readData()

    }
    
    
    @IBAction func unwindFromDelete(segue: UIStoryboardSegue) {
        if let indexPath = collectionView.indexPathsForSelectedItems?[0] {
            deleteData(index: indexPath.row)
        }
    }
    
    @IBAction func unwindFromSave(segue: UIStoryboardSegue) {
        returningFromSave = true
        if let source = segue.source as? ImageDetailViewController, let updatedStruct = source.detailImageStruct {
            if let indexPath = collectionView.indexPathsForSelectedItems?[0] {
                imageStructArray[indexPath.row] = updatedStruct
                writeData(image: updatedStruct.image)
                
            } else {
                returningFromSave = false
            }
        } else {
            returningFromSave = false
        }
        
    }
    
    func deleteData(index: Int) {
        let fileManager = FileManager.default
        let fileName = imageStructArray[index].fileName
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let deletePath = document + "/" + fileName
        do {
            try fileManager.removeItem(atPath: deletePath)
            imageStructArray.remove(at: index)
            let urlArray = imageStructArray.map {$0.fileName}
            defaultsData.set(urlArray, forKey: "photoURLs")
            collectionView.reloadData()
            
        } catch {
            print("Error in trying to delete data at fileName = \(fileName)")
        }

    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImageDetail" {
            let destination = segue.destination as! ImageDetailViewController
            let indexPath = collectionView.indexPathsForSelectedItems![0]
            destination.detailImageStruct = imageStructArray[indexPath.row]
        }
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func writeData(image: UIImage) {
        if let imageData = UIImagePNGRepresentation(image) {
            var fileName = ""
            var indexPath: IndexPath!
            if (collectionView.indexPathsForSelectedItems?.count)! > 0, let selectedIndexPath = collectionView.indexPathsForSelectedItems?[0] {
                indexPath = selectedIndexPath
            }
            
            if returningFromSave {
                fileName = imageStructArray[indexPath.row].fileName
            } else {
                fileName = NSUUID().uuidString
            }
            
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let writePath = documents + "/" + fileName
            do {
                try imageData.write(to: URL(fileURLWithPath: writePath))
                if returningFromSave {
                    imageStructArray[indexPath.row] = ImageStruct(image: image, fileName: fileName)
                } else {
                    imageStructArray.append(ImageStruct(image: image, fileName: fileName))
                }
                let urlArray = imageStructArray.map {$0.fileName}
                defaultsData.set(urlArray, forKey: "photoURLs")
                collectionView.reloadData()
            } catch {
                print("Error in trying to write imageData for url \(writePath)")
            }
        } else {
            print("Error trying to convert image into a raw data file.")
        }
        returningFromSave = false
    }
    
    func readData() {
        
        if let urlArray = defaultsData.object(forKey: "photoURLs") as? [String] {
            for i in 0..<urlArray.count {
                let fileManager = FileManager.default
                let fileName = urlArray[i]
                let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let readPath = document + "/" + fileName
                if fileManager.fileExists(atPath: readPath) {
                    let newImage = UIImage(contentsOfFile: readPath)!
                    print("$$$$$$$")

                    imageStructArray.append(ImageStruct(image: newImage, fileName: fileName))
                } else {
                    print("No file file exists at path: \(readPath)")
                }
            }
            collectionView.reloadData()
        } else {
            print("Error reading in Defaults Data")
        }
        
    }
    
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStructArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.image = imageStructArray[indexPath.row].image
        return cell
    }
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        if let selectedImage = selectedImage {
            dismiss(animated: true, completion: {self.writeData(image: selectedImage)})
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
