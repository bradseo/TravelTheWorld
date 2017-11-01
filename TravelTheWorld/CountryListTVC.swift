//
//  CountryListTVC.swift
//  TravelTheWorld
//
//  Created by seodonghyun on 2017. 8. 10..
//  Copyright © 2017년 seodonghyun. All rights reserved.
//

import UIKit
import CoreData

class CountryListTVC: UITableViewController {

    @IBOutlet var countryCntLbl: UILabel!
    
    private var countryStore: CountryStore = CountryStore()
    private var countryCount: Int {
        
        var count = 0
        
        let fetchRequest : NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"myCountryYN = %@", "Y")
        
        let context = AppDelegate.context
        do {
            count = try context.count(for: fetchRequest)
        } catch let error {
            print("Core data getCountry failed: \(error)")
        }

        return count
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Country> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"myCountryYN = %@", "Y")
        
        let continentSort = NSSortDescriptor(key: #keyPath(Country.continentName), ascending: true)
        let countrySort = NSSortDescriptor(key: #keyPath(Country.countryName), ascending: true)
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [continentSort, countrySort]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: AppDelegate.context,
            sectionNameKeyPath: #keyPath(Country.continentName), cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        self.countryCntLbl.text = "Total Country Count = \(self.countryCount)"
        //tableView.estimatedRowHeight = 35.0
        //tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let sectionCount = fetchedResultsController.sections?.count ?? 1
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListCell", for: indexPath) as! CountryTableViewCell
        
        let country = fetchedResultsController.object(at: indexPath)
        
        let countryCode = country.countryCode ?? "NA"
        cell.countryNameLbl.text = "[" + countryCode + "]" + country.countryName!
        let imageName = countryCode + ".png"
        cell.countryFlagImg.image = UIImage(named: imageName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewCountryDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! CountryDetailTVC
                destinationVC.country = fetchedResultsController.object(at: indexPath)
            }
        }
    }

}

extension CountryListTVC: NSFetchedResultsControllerDelegate {}
