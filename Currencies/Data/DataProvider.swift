//
//  DataProvider.swift
//  Currencies
//
//  Created by George Prokopenko on 28.02.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

import UIKit

protocol DataProviderDelegate: class {
    func dataLoaded(data: NSArray)
}

class DataProvider: NSObject {

    weak var delegate: DataProviderDelegate?
    
    let URLString = "http://phisix-api3.appspot.com/stocks.json";
    var data: NSData!
    var stocks: NSArray!
    
    func loadData() {
        DispatchQueue.global(qos: .background).async {
            self.data =  NSData(contentsOf: URL(string: self.URLString)!)
            self.parseJSON(inputData: self.data!)
        }
    }

    private func parseJSON(inputData: NSData) {
        do {
            let boardsDictionary: NSDictionary = try JSONSerialization.jsonObject(with: inputData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            stocks = boardsDictionary["stock"] as! NSArray
            print("load")
            DispatchQueue.main.async { self.delegate?.dataLoaded(data: self.stocks) }
        } catch {
            print(error)
        }
    }
}
