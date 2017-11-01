//
//  CountryDetailTVC.swift
//  TravelTheWorld
//
//  Created by seodonghyun on 2017. 8. 29..
//  Copyright © 2017년 seodonghyun. All rights reserved.
//

import UIKit
import MapKit

class CountryDetailTVC: UITableViewController {

    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var visitYNlbl: UILabel!
    @IBOutlet var visitDatelbl: UILabel!
    
    var country: Country! {
        didSet {
            navigationItem.title = country.countryName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.setCountryLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setVisitInfo()
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func setVisitInfo() {
        
        if let visitInfo = country.visitInfo {
            visitYNlbl.text = "Vistited when"
            visitDatelbl.text = visitInfo.visitDateByFormat
            
        } else {
            visitYNlbl.text = "Not Yet"
            visitDatelbl.text = ""
        }
    }
    
    private func setCountryLocation() {
        let latitude = country.latitude
        let longitude = country.longitude
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location
        dropPin.title = country.countryName
        mapView.addAnnotation(dropPin)
        
        mapView.setCenter(location, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openWiki" {
            let destinationVC = segue.destination as! WebViewController
            destinationVC.country = self.country
            destinationVC.url = URL(string: country.wikiUrl ??  "");
        } else if segue.identifier == "openBasetrip" {
            let destinationVC = segue.destination as! WebViewController
            destinationVC.country = self.country
            
            
            let localCountryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
            
            var localCountryString: String = ""
            if let localCountry = CountryStore().getCountry(localCountryCode) {
                localCountryString = "?from=" + (localCountry.urlName ?? "")
            }
            
            let urlString = "https://www.thebasetrip.com/en/\(self.country.urlName ?? "")-travel-information" + localCountryString
            destinationVC.url = URL(string: urlString);
            
        } else if segue.identifier == "setVistiDate" {
            let destinationVC = segue.destination as! SetVisitTVC
            destinationVC.country = self.country
        }
    }

}
