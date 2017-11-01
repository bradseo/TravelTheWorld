//
//  SetVisitTVC.swift
//  TravelTheWorld
//
//  Created by seodonghyun on 2017. 9. 5..
//  Copyright © 2017년 seodonghyun. All rights reserved.
//

import UIKit
import CoreLocation

class SetVisitTVC: UITableViewController, CLLocationManagerDelegate {

    var country: Country!

    let locationManager = CLLocationManager()
    
    @IBOutlet var visitDateLbl: UILabel!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var autoDetectCountryLbl: UILabel!
    @IBOutlet var autoDetectYNLbl: UILabel!
    
    private var datePickerVisible = false
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        visitDateLbl.text = getDateText(sender.date)
        
        if country.visitInfo == nil {
            country.visitInfo = CountryVisitInfo(context: AppDelegate.context)
        }
        country.visitInfo?.visitDate = sender.date as NSDate
    }
    
    private func getDateText(_ date: Date?) -> String {
        
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        return  dateFormatter.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let visitInfo = country.visitInfo {
            // 화면 나오게
            visitDateLbl.text = visitInfo.visitDateByFormat
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    //if we have no permission to access user location, then ask user for permission.
    private func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let userLocation = locations.last! as CLLocation
        
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
            // always good to check if no error
            // also we have to unwrap the placemark because it's optional
            // I have done all in a single if but you check them separately
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                // main thread
                DispatchQueue.main.async {
                    self.autoDetectCountryLbl.text = placemark.last?.isoCountryCode ?? ""
                    self.autoDetectYNLbl.text = "detected"
                }
            }
        })

    }

    fileprivate func toggleDatepicker() {
        
        tableView.beginUpdates()
        
        datePickerVisible = !datePickerVisible
        
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath.section == 0 && indexPath.row == 0) {
            toggleDatepicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !datePickerVisible && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
}
