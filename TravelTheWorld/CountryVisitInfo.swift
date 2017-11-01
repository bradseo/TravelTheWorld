//
//  VisitInfo.swift
//  TravelTheWorld
//
//  Created by seodonghyun on 2017. 9. 5..
//  Copyright © 2017년 seodonghyun. All rights reserved.
//

import Foundation
import CoreData

public class CountryVisitInfo: NSManagedObject {
    
    var visitDateByFormat : String {
        
        guard let visitDate = self.visitDate else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let visitDateStr = dateFormatter.string(from: visitDate as Date)
        return visitDateStr
        
    }

}
