//
//  ViewController.swift
//  RestEasy
//
//  Created by BRAUER, BOBBY [AG/1155] on 11/20/2016.
//  Copyright © 2016 BRAUER, BOBBY [AG/1155]. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var quotes = [Quote]()
    var myQuoteModel = QuoteModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func Sync(sender: AnyObject) {
        myQuoteModel.retrieveQuotes()
    }
    
    @IBAction func ViewQuotes(sender: AnyObject) {
        myQuoteModel.storeQuotes()
        quotes = myQuoteModel.returnQuotes()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        //populate cell values here
        cell.textLabel?.text = quotes[indexPath.row].text
        return cell
    }

}

