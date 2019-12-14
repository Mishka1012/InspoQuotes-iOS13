//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
// 

import UIKit

class QuoteTableViewController: UITableViewController {
    
    let productID = K.iap
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quotesToShow.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.quoteCellIdentifier, for: indexPath)
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            //allowing to have text multiline
            cell.textLabel?.numberOfLines = 0
            //setting text color to fit the theme.
            cell.textLabel?.textColor = indexPath.row % 2 == 1 ? UIColor(named: K.darkColorName) : UIColor(named: K.lightColorName)
            //accessory type
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes"
            //setting text color to fit the theme.
            cell.textLabel?.textColor = UIColor(named: K.lightColorName)
            //making arrow appear
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == quotesToShow.count {
            //trying to purchase shit
            buyPremiumQuotes()
        }
    }
    //user paid
    func showPremiumQuotes() {
        //changing data source
        quotesToShow.append(contentsOf: premiumQuotes)
        //reloading data
        tableView.reloadData()
    }
}
//MARK: - In-App Purchase Methods

import StoreKit

extension QuoteTableViewController: SKPaymentTransactionObserver {
    //detecting successful payments
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //transaction updated
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Transaction successful!")
                SKPaymentQueue.default().finishTransaction(transaction)
                showPremiumQuotes()
            case .failed:
                print("Transaction failed!")
                print(transaction.error!.localizedDescription)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                //purchasing
                print("Transaction processing!")
            case .deferred:
                //deferred payment
                print("Transaction deferred!")
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                showPremiumQuotes()
            default:
                print("Tansaction Irrelevant")
            }
        }
    }
    
    func buyPremiumQuotes() {
        //whether user can make a purchase
        guard SKPaymentQueue.canMakePayments() else {
            fatalError("User can't make payments")
        }
        //new request
        let paymentRequest = SKMutablePayment()
        paymentRequest.productIdentifier = productID
        //request payment
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.separatorStyle = .none
        //adding obeserver
        SKPaymentQueue.default().add(self)
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        //testing
        showPremiumQuotes()
    }
    
    
}
