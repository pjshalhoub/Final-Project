//
//  DetailViewController.swift
//  Final
//
//  Created by PJ Shalhoub on 11/22/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//

import UIKit
//import CoreLocation
import GooglePlaces

class DetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var stadiumNameTextField: UITextField!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var stadiumNameLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var oneStarImage: UIImageView!
    @IBOutlet weak var twoStarImage: UIImageView!
    @IBOutlet weak var threeStarImage: UIImageView!
    @IBOutlet weak var fourStarImage: UIImageView!
    @IBOutlet weak var fiveStarImage: UIImageView!
    var selectedImage: UIImage?
    var stars = 0
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var index = 0
    var images = [Int]()
    var sportsDetail: SportsDetail?
    var navItemTitle: String?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        navigationItem.title = "Save a Stadium"
        textView.delegate = self
        //self.navigationItem.title = navItemTitle
        if let sportsDetail = sportsDetail {
            stadiumNameTextField.text = sportsDetail.stadiumName
            teamNameTextField.text = sportsDetail.teamName
            textView.text = sportsDetail.stadiumInfo
            if sportsDetail.stars == 5 {
                oneStarImage.image = UIImage(named: "image1")
                twoStarImage.image = UIImage(named: "image1")
                threeStarImage.image = UIImage(named: "image1")
                fourStarImage.image = UIImage(named: "image1")
                fiveStarImage.image = UIImage(named: "image1")
                
            } else if sportsDetail.stars == 4 {
                oneStarImage.image = UIImage(named: "image1")
                twoStarImage.image = UIImage(named: "image1")
                threeStarImage.image = UIImage(named: "image1")
                fourStarImage.image = UIImage(named: "image1")
                fiveStarImage.image = UIImage(named: "image0")
            } else if sportsDetail.stars == 3 {
                oneStarImage.image = UIImage(named: "image1")
                twoStarImage.image = UIImage(named: "image1")
                threeStarImage.image = UIImage(named: "image1")
                fourStarImage.image = UIImage(named: "image0")
                fiveStarImage.image = UIImage(named: "image0")
            } else if sportsDetail.stars == 2 {
                oneStarImage.image = UIImage(named: "image1")
                twoStarImage.image = UIImage(named: "image1")
                threeStarImage.image = UIImage(named: "image0")
                fourStarImage.image = UIImage(named: "image0")
                fiveStarImage.image = UIImage(named: "image0")
            } else if sportsDetail.stars == 1 {
                oneStarImage.image = UIImage(named: "image1")
                twoStarImage.image = UIImage(named: "image0")
                threeStarImage.image = UIImage(named: "image0")
                fourStarImage.image = UIImage(named: "image0")
                fiveStarImage.image = UIImage(named: "image0")
            } else {
                oneStarImage.image = UIImage(named: "image0")
                twoStarImage.image = UIImage(named: "image0")
                threeStarImage.image = UIImage(named: "image0")
                fourStarImage.image = UIImage(named: "image0")
                fiveStarImage.image = UIImage(named: "image0")
            }
        } else {
            sportsDetail = SportsDetail(stadiumName: "", teamName: "", stadiumInfo: "", stars: Int(), placeDocumentID: "")
        }
        if stadiumNameTextField.text! == "" || teamNameTextField.text! == "" || textView.text! == "" {
            saveButton.isEnabled = false
        }
        //stadiumNameTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    

    
    @IBAction func lookupStadiumButtonPressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    
    }
    
    @IBAction func fieldNameChanged(_ sender: UITextField) {
        if stadiumNameTextField.text! == "" || teamNameTextField.text! == "" || textView.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" || stadiumNameTextField.text == "" || teamNameTextField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func checkStars() {
        if oneStarImage.image == UIImage(named: "image0")! && twoStarImage.image == UIImage(named: "image0")! && threeStarImage.image == UIImage(named: "image0")! && fourStarImage.image == UIImage(named: "image0")! && fiveStarImage.image == UIImage(named: "image0")! {
            stars = 0
        } else if oneStarImage.image == UIImage(named: "image1")! && twoStarImage.image == UIImage(named: "image0")! && threeStarImage.image == UIImage(named: "image0")! && fourStarImage.image == UIImage(named: "image0")! && fiveStarImage.image == UIImage(named: "image0")! {
            stars = 1
        } else if oneStarImage.image == UIImage(named: "image1")! && twoStarImage.image == UIImage(named: "image1")! && threeStarImage.image == UIImage(named: "image0")! && fourStarImage.image == UIImage(named: "image0")! && fiveStarImage.image == UIImage(named: "image0")! {
            stars = 2
        } else if oneStarImage.image == UIImage(named: "image1")! && twoStarImage.image == UIImage(named: "image1")! && threeStarImage.image == UIImage(named: "image1")! && fourStarImage.image == UIImage(named: "image0")! && fiveStarImage.image == UIImage(named: "image0")! {
            stars = 3
        } else if oneStarImage.image == UIImage(named: "image1")! && twoStarImage.image == UIImage(named: "image1")! && threeStarImage.image == UIImage(named: "image1")! && fourStarImage.image == UIImage(named: "image1")! && fiveStarImage.image == UIImage(named: "image0")! {
            stars = 4
        } else if oneStarImage.image == UIImage(named: "image1")! && twoStarImage.image == UIImage(named: "image1")! && threeStarImage.image == UIImage(named: "image1")! && fourStarImage.image == UIImage(named: "image1")! && fiveStarImage.image == UIImage(named: "image1")! {
            stars = 5
        }
        
    }

    @IBAction func oneStarImageTapped(_ sender: UITapGestureRecognizer) {
        oneStarImage.image = UIImage(named: "image1")
        twoStarImage.image = UIImage(named: "image0")
        threeStarImage.image = UIImage(named: "image0")
        fourStarImage.image = UIImage(named: "image0")
        fiveStarImage.image = UIImage(named: "image0")
        stars = 1
    }
    
    @IBAction func twoStarImageTapped(_ sender: UITapGestureRecognizer) {
        oneStarImage.image = UIImage(named: "image1")
        twoStarImage.image = UIImage(named: "image1")
        threeStarImage.image = UIImage(named: "image0")
        fourStarImage.image = UIImage(named: "image0")
        fiveStarImage.image = UIImage(named: "image0")
        stars = 2
    }

    @IBAction func threeStarImageTapped(_ sender: UITapGestureRecognizer) {
        oneStarImage.image = UIImage(named: "image1")
        twoStarImage.image = UIImage(named: "image1")
        threeStarImage.image = UIImage(named: "image1")
        fourStarImage.image = UIImage(named: "image0")
        fiveStarImage.image = UIImage(named: "image0")
        stars = 3
    }
    @IBAction func fourStarImageTapped(_ sender: UITapGestureRecognizer) {
        oneStarImage.image = UIImage(named: "image1")
        twoStarImage.image = UIImage(named: "image1")
        threeStarImage.image = UIImage(named: "image1")
        fourStarImage.image = UIImage(named: "image1")
        fiveStarImage.image = UIImage(named: "image0")
        stars = 4
    }
    
    @IBAction func fiveStarImageTapped(_ sender: UITapGestureRecognizer) {
        oneStarImage.image = UIImage(named: "image1")
        twoStarImage.image = UIImage(named: "image1")
        threeStarImage.image = UIImage(named: "image1")
        fourStarImage.image = UIImage(named: "image1")
        fiveStarImage.image = UIImage(named: "image1")
        stars = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            sportsDetail?.stadiumName = stadiumNameTextField.text!
            sportsDetail?.teamName = teamNameTextField.text!
            sportsDetail?.stadiumInfo = textView.text
            checkStars()
            sportsDetail?.stars = stars
        }
    }
    

}

extension DetailViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        stadiumNameTextField.text = place.name
        //print("Place name: \(place.name)")
       // print("Place address: \(place.formattedAddress)")
        //print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
