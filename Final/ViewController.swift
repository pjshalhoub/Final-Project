//
//  ViewController.swift
//  Final
//
//  Created by PJ Shalhoub on 11/22/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var sportsDetailArray = [SportsDetail]()
    var defaultsData = UserDefaults.standard
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Select or Add a Stadium"
        loadLocations()

       
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(">>> View Controller has appeared")
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("**** SignedIn indicated in ViewController")
            let userEmail = (Auth.auth().currentUser?.email)!
            let displayName = (Auth.auth().currentUser?.displayName)!
            print("UUUU userEmail = \(userEmail), displayName = \(displayName)")
        } else {
            performSegue(withIdentifier: "ToLogin", sender: nil)
        }
    }
    
    
    func saveDefaultsData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sportsDetailArray) {
            UserDefaults.standard.set(encoded, forKey: "sportsDetailArray")
        } else {
            print("ERROR: Saving did not work")
        }
        
    }
    
    func loadLocations() {
        guard let sportsEncoded = UserDefaults.standard.value(forKey: "sportsDetailArray") as? Data else {
            print("Could not load sportsDetailArray data from UserDefaults.")
            return
        }
        let decoder = JSONDecoder()
        if let sportsDetailArray = try? decoder.decode(Array.self, from: sportsEncoded) as [SportsDetail] {
            self.sportsDetailArray = sportsDetailArray
        } else {
            print("ERROR: Couldn't decode data read from UserDefaults.")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "EditLocationDetail":
            let destination = segue.destination as! DetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destination.sportsDetail = sportsDetailArray[index]

        case "AddLocation":
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: true)
        }
        case "ToLogin":
            print("Performing segue ToLogin")
        case "ToImageVC":
            print("Performing segue ToImageVC")
        default:
            print("*** Unexpected Segue in ViewController")
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "ToLogin", sender: nil)
    }
    
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            sportsDetailArray[indexPath.row] = (sourceViewController.sportsDetail)!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: sportsDetailArray.count, section: 0)
            sportsDetailArray.append((sourceViewController.sportsDetail)!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveDefaultsData()
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            addButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
            addButton.isEnabled = false
        }
        
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ToImageVC", sender: nil)
    }
    @IBAction func aboutButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ToAboutPage", sender: nil)
    }
    
    
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LocationDetailTableViewCell
        cell.locationNameLabel.text = sportsDetailArray[indexPath.row].stadiumName
        cell.postedByLabel.text = "Team Name: \(sportsDetailArray[indexPath.row].teamName)"
        if sportsDetailArray[indexPath.row].stars == 5 {
            cell.oneStarCellImage.image = UIImage(named: "image1")
            cell.twoStarCellImage.image = UIImage(named: "image1")
            cell.threeStarCellImage.image = UIImage(named: "image1")
            cell.fourStarCellImage.image = UIImage(named: "image1")
            cell.fiveStarCellImage.image = UIImage(named: "image1")
        } else if sportsDetailArray[indexPath.row].stars == 4 {
            cell.oneStarCellImage.image = UIImage(named: "image1")
            cell.twoStarCellImage.image = UIImage(named: "image1")
            cell.threeStarCellImage.image = UIImage(named: "image1")
            cell.fourStarCellImage.image = UIImage(named: "image1")
            cell.fiveStarCellImage.image = UIImage(named: "image0")
        } else if sportsDetailArray[indexPath.row].stars == 3 {
            cell.oneStarCellImage.image = UIImage(named: "image1")
            cell.twoStarCellImage.image = UIImage(named: "image1")
            cell.threeStarCellImage.image = UIImage(named: "image1")
            cell.fourStarCellImage.image = UIImage(named: "image0")
            cell.fiveStarCellImage.image = UIImage(named: "image0")
        } else if sportsDetailArray[indexPath.row].stars == 2 {
            cell.oneStarCellImage.image = UIImage(named: "image1")
            cell.twoStarCellImage.image = UIImage(named: "image1")
            cell.threeStarCellImage.image = UIImage(named: "image0")
            cell.fourStarCellImage.image = UIImage(named: "image0")
            cell.fiveStarCellImage.image = UIImage(named: "image0")
        } else if sportsDetailArray[indexPath.row].stars == 1 {
            cell.oneStarCellImage.image = UIImage(named: "image1")
            cell.twoStarCellImage.image = UIImage(named: "image0")
            cell.threeStarCellImage.image = UIImage(named: "image0")
            cell.fourStarCellImage.image = UIImage(named: "image0")
            cell.fiveStarCellImage.image = UIImage(named: "image0")
        } else {
            cell.oneStarCellImage.image = UIImage(named: "image0")
            cell.twoStarCellImage.image = UIImage(named: "image0")
            cell.threeStarCellImage.image = UIImage(named: "image0")
            cell.fourStarCellImage.image = UIImage(named: "image0")
            cell.fiveStarCellImage.image = UIImage(named: "image0")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sportsDetailArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        saveDefaultsData()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let locationToMove = sportsDetailArray[sourceIndexPath.row]
       
        sportsDetailArray.remove(at: sourceIndexPath.row)
        sportsDetailArray.insert(locationToMove, at: destinationIndexPath.row)
     
        saveDefaultsData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

