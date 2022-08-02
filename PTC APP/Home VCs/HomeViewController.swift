//
//  HomeViewController.swift
//  PTC APP
//
//  Created by Jaldeep Patel on 2021-08-04.
//  Copyright © 2021 Gurlagan Bhullar. All rights reserved.
//

import UIKit
import RealmSwift
class HomeViewController: UIViewController {
    // Variable
    let realm = try! Realm()
    //MARK: - MainView Outlets
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var profileView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileEditButtonOutlet: UIButton!
    @IBOutlet var separatorView: UIView!
    
    //MARK: - MainView  Data
    var activityNameArray : Results<SituationData>?
    
    //MARK: - Menubar Outlets
    @IBOutlet var menubarTableView: UITableView!
    @IBOutlet var menubarView: UIView!
    
    
    //MARK: - Menubar Items and Icons
    let menuItems = ["Home", "Guidelines", "About Author", "Privacy Policy", "Contact Us", "Sign Out"]
    let menuIcons = ["home", "guidelines", "about-author", "privacy-policy", "contact-us", "sign-out"]
    var isSideViewOpened: Bool = false
    override func viewWillAppear(_ animated: Bool) {
        activityNameArray = realm.objects(SituationData.self)
        mainTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hide Menubar on ViewDidLoad
        menubarView.isHidden = true
        menubarTableView.backgroundColor = UIColor.systemBackground
        isSideViewOpened = false
        
        //Add shadow to Menubar
        Utilities.addShadowAndBorderToView(menubarView)
        menubarView.layer.borderWidth = 0
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = Utilities.secondaryTextColor.cgColor
        
        
    }

    
    @IBAction func sideMenuButtonTapped(_ sender: UIBarButtonItem) {
        
        
        menubarView.isHidden = false
        menubarTableView.isHidden = false
        self.view.bringSubviewToFront(menubarView)
        navigationItem.largeTitleDisplayMode = .never
        
        if !isSideViewOpened {
            isSideViewOpened = true
            menubarView.frame = CGRect(x: 0, y: 88, width: 0, height: 838)
            menubarTableView.frame = CGRect(x: 0, y: 0, width: 0, height: 838)
            profileView.frame = CGRect(x: 0, y: 0, width: 0, height: 150)
            profileImageView.frame = CGRect(x: 20, y: 10, width: 0, height: 80)
            nameLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
            emailLabel.frame = CGRect(x: 0, y: 30, width: 0, height: 30)
            profileEditButtonOutlet.frame = CGRect(x: 82, y: 70, width: 0, height: 20)
            separatorView.frame = CGRect(x: 20, y: 98.67, width: 0, height: 0.33)
            
            UIView.animate(withDuration: 0.5) {
                self.menubarView.frame = CGRect(x: 0, y: 88, width: 320, height: 838)
                self.menubarTableView.frame = CGRect(x: 0, y: 0, width: 320, height: 838)
                self.profileView.frame = CGRect(x: 0, y: 0, width: 320, height: 150)
                self.profileImageView.frame = CGRect(x: 20, y: 10, width: 80, height: 80)
                self.nameLabel.frame = CGRect(x: 0, y: 0, width: 210, height: 30)
                self.emailLabel.frame = CGRect(x: 0, y: 30, width: 210, height: 30)
                self.profileEditButtonOutlet.frame = CGRect(x: 82, y: 70, width: 20, height: 20)
                self.separatorView.frame = CGRect(x: 20, y: 98.67, width: 280, height: 0.33)
                
            }
        } else {
            menubarView.isHidden = true
            menubarTableView.isHidden = true
            isSideViewOpened = false
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    @IBAction func addActivityButtonTapped(_ sender: UIBarButtonItem) {
    
    }
    
    @IBAction func profileEditButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: Constants.Segues.homeToProfileSegue, sender: self)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRow = 0
        
        switch tableView {
        case mainTableView:
            numberOfRow = activityNameArray?.count ?? 0
        case menubarTableView:
            numberOfRow = menuItems.count
        default:
            print("Something's wrong!")
        }
        
        return numberOfRow
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch tableView {
        case mainTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.homeScreenMainTableViewCell, for: indexPath) as! HomeVCMainTableViewCell
            cell.acitivityNameLabel.text = activityNameArray?[indexPath.row].situationTitle
            cell.dateLabel.text = activityNameArray?[indexPath.row].date
            return cell
        case menubarTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.homeScreenMenuBarCell, for: indexPath) as! SideMenuTableViewCell
            cell.menuLabel.text = menuItems[indexPath.row]
            cell.menuIconImageView.image = UIImage(named: menuIcons[indexPath.row])
            return cell
        default:
            print("Something's wrong!")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch tableView {
        
        case mainTableView:
            print("MainTableView's cells are Tapped")
        
        case menubarTableView:
            switch menuItems[indexPath.row] {
        
            case "Home":
                menubarView.isHidden = true
                menubarTableView.isHidden = true
                isSideViewOpened = false
                self.navigationItem.largeTitleDisplayMode = .always
                
                break
                
            case "Guidelines":
                performSegue(withIdentifier: Constants.Segues.homeToUseInstructionsSegue, sender: self)
                break
                
            case "About Author":
                performSegue(withIdentifier: Constants.Segues.homeToAboutAuthor, sender: self)
                break
                
            case "Privacy Policy":
                performSegue(withIdentifier: Constants.Segues.homeToPrivacyPolicySegue, sender: self)
                break
                
            case "Contact Us":
                performSegue(withIdentifier: Constants.Segues.homeToContactUsSegue, sender: self)
                break
                
            case "Sign Out":
                print("Sign Out")
                break
                
            default:
                print("Screen is not available.")
                break
            }
        default:
            print("Something's wrong!")
        }
    }
}
