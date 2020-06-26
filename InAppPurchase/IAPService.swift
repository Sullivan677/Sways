import UIKit
import StoreKit

protocol IAPServiceDelegate {
    func iapProductsLoaded()
}

class IAPService: UIViewController {
    static let instance = IAPService()
       
       var iapDelegate: IAPServiceDelegate?
       
       var products = [SKProduct]()
       var productIds = Set<String>()
       var productRequest = SKProductsRequest()
       
       var expirationDate: Date?
       var nonConsumablePurchaseWasMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
}

extension IAPService: SKProductsRequestDelegate {
   
    
    public func loadProducts() {
        productIdToStringSet()
        requestProducts(forIds: productIds)
    }
    
    private func productIdToStringSet() {
        let ids = [IAP_MONTHLY_SUBSCRIPTION_ID, IAP_CONSUMABLE_ID]
        for id in ids {
            productIds.insert(id)
        }
    }
    
    private func requestProducts(forIds ids: Set<String>) {
        productRequest.cancel()
        productRequest = SKProductsRequest(productIdentifiers: ids)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        if products.count == 0 {
            requestProducts(forIds: productIds)
        } else {
            iapDelegate?.iapProductsLoaded()
        }
    }
    
    public func attemptPurchaseForItemWith(productIndex: Product) {
        let product = products[productIndex.rawValue]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: – SKReceiptRefreshRequest Delegate Method
    
    func requestDidFinish(_ request: SKRequest) {
        uploadReceipt { (valid) in
            if valid {
                debugPrint("Subscription Receipt Valid")
                self.isSubscriptionActive(completion: { (active) in
                    if active {
                        debugPrint("Subscription Active")
                        self.sendNotificationFor(status: .subscribed, withIdentifier: nil, orBoolean: true)
                        self.setNonConsumablePurchase(true, forTransaction: nil)
                    } else {
                        debugPrint("Subscription Expired")
                        self.sendNotificationFor(status: .subscribed, withIdentifier: nil, orBoolean: false)
                        self.setNonConsumablePurchase(false, forTransaction: nil)
                    }
                })
                return
            } else {
                self.sendNotificationFor(status: .subscribed, withIdentifier: nil, orBoolean: false)
                self.setNonConsumablePurchase(false, forTransaction: nil)
                return
            }
        }
    }
    
    public func isSubscriptionActive(completion: @escaping (_ status: Bool) -> Void) {
        reloadExpiryDate()
        let now = Date()
        guard let expirationDate = expirationDate else { completion(false);  return }
        debugPrint("TIME REMAINING: \(expirationDate.timeIntervalSinceNow / 60) minutes.")
        debugPrint("EXPIRATION DATE: \(expirationDate)")
        if now.isLessThan(expirationDate) {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    private func uploadReceipt(completionHandler: @escaping (Bool) -> Void) {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL,
            let receipt = try? Data(contentsOf: receiptUrl).base64EncodedString() else {
                debugPrint("No receipt url")
                completionHandler(false)
                return
        }
        
        let body = [
            "receipt-data": receipt,
            "password": appSecret
        ]
        
        let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
        
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            if let error = error {
                debugPrint(error)
                completionHandler(false)
            } else if let responseData = responseData {
                let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as! Dictionary<String, Any>
                let newExpirationDate = self.expirationDateFromResponse(jsonResponse: json)!
                self.setExpiration(forDate: newExpirationDate)
                debugPrint("NEW EXPIRATION DATE: ", newExpirationDate)
                completionHandler(true)
            }
        }
        task.resume()
    }
    
 private func expirationDateFromResponse(jsonResponse: Dictionary<String, Any>) -> Date? {
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            let lastReceipt = receiptInfo.lastObject as! Dictionary<String, Any>
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            let expirationDate: Date = (formatter.date(from: lastReceipt["expires_date_pst"] as! String) as Date?)!
            return expirationDate
        } else {
            return nil
        }
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                sendNotificationFor(status: .failed, withIdentifier: nil, orBoolean: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .purchasing:
                debugPrint("Purchasing...")
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        sendNotificationFor(status: .restored, withIdentifier: nil, orBoolean: nil)
        setNonConsumablePurchase(true, forTransaction: nil)
    }
    
    func complete(transaction: SKPaymentTransaction) {
        debugPrint("Purchase was successful!")
        switch transaction.payment.productIdentifier {
        case IAP_MONTHLY_SUBSCRIPTION_ID:
            sendNotificationFor(status: .subscribed, withIdentifier: nil, orBoolean: true)
            setNonConsumablePurchase(true, forTransaction: transaction)
            break
        case IAP_CONSUMABLE_ID:
            setNonConsumablePurchase(true, forTransaction: transaction)
            break
        default:
            break
        }
    }
    
    func setNonConsumablePurchase(_ status: Bool, forTransaction transaction: SKPaymentTransaction?) {
        if transaction?.payment.productIdentifier != IAP_CONSUMABLE_ID {
            UserDefaults.standard.set(status, forKey: "nonConsumablePurchaseWasMade")
        }
    }
    
    func setExpiration(forDate date: Date) {
        UserDefaults.standard.set(date, forKey: "expirationDate")
    }
    
    func reloadExpiryDate() {
        expirationDate = UserDefaults.standard.value(forKey: "expirationDate") as? Date
    }
    
    func sendNotificationFor(status: PurchaseStatus, withIdentifier identifier: String?, orBoolean bool: Bool?) {
        DispatchQueue.main.async {
            switch status {
            case .purchased:
                NotificationCenter.default.post(name: NSNotification.Name(IAPServicePurchaseNotification), object: identifier)
                break
            case .subscribed:
                NotificationCenter.default.post(name: NSNotification.Name(IAPSubscriptionInformationWasChangedNotification), object: bool)
                break
            case .restored:
                NotificationCenter.default.post(name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
                break
            case .failed:
                NotificationCenter.default.post(name: NSNotification.Name(IAPServiceFailureNotification), object: nil)
                break
            }
        }
    }
}
