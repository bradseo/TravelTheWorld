import Foundation
import CoreData

class CountryStore {
    
    private let context = AppDelegate.context
    
    var countries: [Country] {
        
        if _countries == nil {
            _countries = getCountries()
        }
        
        return _countries ?? [Country]()
    }
    
    private var _countries:[Country]?
    
    func getCountry(_ countryCode: String) -> Country? {
        
        let fetchRequest : NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"countryCode = %@", countryCode)
        
        var countries = [Country]()
        
        do {
            countries = try context.fetch(fetchRequest)
        } catch let error {
            print("Core data getCountry failed: \(error)")
        }

        return countries.first
    }
    
    func getCountries() -> [Country] {
        
        let fetchRequest : NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "countryName", ascending: true)]
        
        var countries = [Country]()
        
        do {
            countries = try context.fetch(fetchRequest)
        } catch let error {
            print("Core data getCountries failed: \(error)")
        }
        return countries
    }
    
}
