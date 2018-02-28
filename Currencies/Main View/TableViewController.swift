//
//  TableViewController.swift
//  Currencies
//
//  Created by George Prokopenko on 28.02.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    let cellID = "Cell"
    var currenciesArray: NSArray?
    
    let dataProvider = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.delegate = self
        registerCells()
        setupNavigationBar()
        updateData()
        setLoadingTimer(time: 15)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: - Private Methods
    
    private func registerCells() {
        let nibName = String(describing: CurrencyCell.self)
        tableView.register(UINib(nibName:nibName, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red:0.51, green:0.63, blue:0.71, alpha:1.0)
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        let leftBarButtonItem = UIBarButtonItem.init(customView: activityIndicator)
        leftBarButtonItem.target = #selector(updateData) as AnyObject
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setLoadingTimer(time: Int) {
        Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @IBAction private func updateData() {
        activityIndicator.startAnimating()
        dataProvider.loadData()
    }
    
    
    // MARK: - Keyboard
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom = keyboardSize.height + 50
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset.bottom = 0
    }
}


extension TableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currenciesArray == nil { return 0 }
        return (currenciesArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CurrencyCell
        guard let currency: NSDictionary = (currenciesArray?.object(at: indexPath.row) as? NSDictionary) else {return cell}
        cell.customize(data: currency)
        return cell
    }
    
}


extension TableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


extension TableViewController : DataProviderDelegate {
    
    func dataLoaded(data: NSArray) {
        currenciesArray = data
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
}
