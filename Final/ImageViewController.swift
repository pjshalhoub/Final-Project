//
//  ImageViewController.swift
//  Final
//
//  Created by PJ Shalhoub on 11/30/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//
// IF ANYTHING DOESNT WORK, IT IS THE TEXT VIEW, REMOVE IF NECESSARY
import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imagePicker = UIImagePickerController()
    var imageStructArray = [ImageStruct]()
    var defaultsData = UserDefaults.standard
    //var imageText = [String]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        //collectionView.reloadData()
        readData()

    }
    
    
    @IBAction func unwindFromDelete(segue: UIStoryboardSegue) {
        if let indexPath = collectionView.indexPathsForSelectedItems?[0] {
            deleteData(index: indexPath.row)
        }
    }
    
    func deleteData(index: Int) {
        let fileManager = FileManager.default
        let fileName = imageStructArray[index].fileName
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let deletePath = document.appending(fileName)
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
            let fileName = NSUUID().uuidString
            let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let writePath = document.appending(fileName)
            do {
                try imageData.write(to: URL(fileURLWithPath: writePath))
                imageStructArray.append(ImageStruct(image: image, fileName: fileName, imageDescription: "", text: ""))
                let urlArray = imageStructArray.map {$0.fileName}
                defaultsData.set(urlArray, forKey: "photoURLs")
                collectionView.reloadData()
            } catch {
                print("Error trying to write imageData for URL \(writePath)")
            }
            
        } else {
            print("Error trying to convert image into a raw data file")
        }
    }
    
    func readData() {
        if let urlArray = defaultsData.object(forKey: "photoURLs") as? [String] {
            for i in 0..<urlArray.count {
                let fileManager = FileManager.default
                let fileName = urlArray[i]
                let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let readPath = document.appending(fileName)
                if fileManager.fileExists(atPath: readPath) {
                    let newImage = UIImage(contentsOfFile: readPath)!
                    imageStructArray.append(ImageStruct(image: newImage, fileName: fileName, imageDescription: "", text: ""))
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
