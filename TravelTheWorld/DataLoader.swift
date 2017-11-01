//
//  DataLoader.swift
//  AroundTheWorld
//
//  Created by donghyun seo on 2017. 4. 4..
//  Copyright © 2017년 seodonghyun. All rights reserved.
//

import Foundation
import CoreData


class DataLoader {
    
    private let context = AppDelegate.context
    
    func startDataLoading() {
        let defaults = UserDefaults.standard
        dataLoadForCountires()

        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            //dataLoadForCountires()
            defaults.set(true, forKey: "isPreloaded")
        }
    }
    
    private func dataLoadForCountires() {
        /*
         국가에 대한 기준은 IOS3166에서 IOC 즉 올림픽회원국(207) + 남극 해서 
         총 208개 국가로 내 마음대로 정했음
         */
        
        if CountryStore().getCountries().count > 0 { return }
        
        print("data pre load start!!")
        
        if let contentsOfURL = Bundle.main.url(forResource: "iso3166country", withExtension: "json") {
            
            do {
                if let jsondata = try? Data(contentsOf: contentsOfURL) {
                    
                    let jsonObject = try JSONSerialization.jsonObject(with: jsondata, options: [])
                    guard let
                        //jsonDictionary = jsonObject as? [NSObject:AnyObject],
                        //countries = jsonDictionary["countries"] as? [String:AnyObject],
                        countryArray = jsonObject as? [[String:AnyObject]]
                        else {
                            print("fail to jsondata parsing")
                            return
                    }
                    print("data from json count =", countryArray.count)
                    
                    // Remove all items before preloading
                    removeData(entityName: "Country")
                    
                    for jsonDic in countryArray {
                        let country = Country(context: self.context)
                        
                        country.countryName = jsonDic["countryName"] as? String
                        country.urlName = (jsonDic["urlName"] as? String) ?? ""
                        country.countryCode = jsonDic["countryCode"] as? String
                        country.isoAlpha3 = (jsonDic["isoAlpha3"] as? String) ?? ""
                        country.isoNumeric = (jsonDic["isoNumeric"] as? String) ?? ""
                        country.iocCode = (jsonDic["iocCode"] as? String) ?? ""
                        country.continent = (jsonDic["continent"] as? String) ?? ""
                        country.continentName = (jsonDic["continentName"] as? String) ?? ""
                        country.currencyCode = (jsonDic["currencyCode"] as? String) ?? ""
                        country.latitude =  (jsonDic["latitude"] as? Double) ?? 0.0
                        country.longitude =  (jsonDic["longitude"] as? Double) ?? 0.0
                        country.livingCostIndex = (jsonDic["livingCostIndex"] as? Double) ?? 0
                        country.officialType = (jsonDic["officialType"] as? String) ?? ""
                        country.myCountryYN = (jsonDic["myCountryYN"] as? String) ?? "N"
                        country.wikiUrl = (jsonDic["wikiUrl"] as? String) ?? ""
                    }
                    
                    do {
                        try self.context.save()
                        print("data saved count =", countryArray.count)
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func removeData (entityName: String) {
        // Remove the existing items
        //let fetchRequest = NSFetchRequest<Country>(entityName: "Country")
        let fetchRequest = NSFetchRequest<Country>(entityName: entityName)
        
        do {
            let countries = try self.context.fetch(fetchRequest)
            for country in countries {
                self.context.delete(country)
            }
            
            try self.context.save()
        } catch {
            print(error)
        }
        
    }
}
