//
//  QuoteModel.swift
//  RestEasy
//
//  Created by BRAUER, BOBBY [AG/1155] on 11/20/2016.
//  Copyright © 2016 BRAUER, BOBBY [AG/1155]. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class QuoteModel {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var quotesJSON: JSON = ""
    
    func retrieveQuotes() {
        let quoteJarUrl = "http://localhost:3000/api/quotes/query"
        let url: NSURL = NSURL(string: quoteJarUrl)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var tags = [NSNumber]()
        tags.append(1)
        tags.append(2)
        tags.append(3)
        
        let json : [String: AnyObject] = ["said_by": "CS496 Student", "isFavorite": "true", "tags": tags]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            request.HTTPBody = jsonData
        } catch let error as NSError {
            print("failed json serialization \(error.localizedDescription)")
        }
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            let myJSON = JSON(data: data!)
            print(myJSON)
            self.quotesJSON = myJSON
        }
        task.resume()
    }
    
    func storeQuotes() {
        self.removeQuotes()
        for (_, q) in self.quotesJSON {
            let quote = NSEntityDescription.insertNewObjectForEntityForName("Quote", inManagedObjectContext: managedObjectContext) as! Quote
            
            quote.id = q["_id"].string!
            quote.user_id = q["user_id"].string!
            quote.is_favorite = q["isFavorite"].string!
            quote.text = q["text"].string!
            quote.said_by = q["said_by"].string!
            quote.rating = q["rating"].number!.shortValue
            
            var tagArray = [NSNumber]()
            for (_, t) in q["tags"] {
                let tagId = t.number!
                tagArray.append(tagId)
            }
            quote.tags = tagArray
        }
    }
    
    func removeQuotes() {
        let fetchRequest = NSFetchRequest(entityName: "Quote")
        do {
            let quoteContents = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Quote]
            for q in quoteContents {
                self.managedObjectContext.deleteObject(q)
            }
        } catch {
            fatalError("Failed to fetch quotes: \(error)")
        }
    }
    
    func returnQuotes() -> [Quote] {
        var quotes = [Quote]()
        let quoteRequest = NSFetchRequest(entityName: "Quote")
        do {
            let quoteResults = try managedObjectContext.executeFetchRequest(quoteRequest) as? [Quote]
            quotes = quoteResults!
        } catch let error as NSError {
            print("failed fetch \(error.localizedDescription)")
        }
        return quotes
    }

}
