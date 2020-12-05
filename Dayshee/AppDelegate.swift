//
//  AppDelegate.swift
//  keeng_customer
//
//  Created by ThanhPham on 10/24/18.
//  Copyright © 2018 ThanhPham. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import GoogleMaps
import GooglePlaces
import SwiftDate
import FirebaseAuth
import FirebaseMessaging
import FirebaseCore
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    //MARK: - VAR
    
    var window: UIWindow?
    var locality: String?
    var device_token = ""
    var tabbar: BaseTabbarViewController?
    //MARK: - BEGIN APPLICATION
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Notification
        //Keyboard manager
//        IQKeyboardManager.shared.enable = true
//
//        //Detect Internet
//        setupNotificationInternet()
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        GIDSignIn.sharedInstance().clientID = GG_ID
//        //        setupLocation()
//
//
//        GMSServices.provideAPIKey(GG_API_KEY)
//        GMSPlacesClient.provideAPIKey(GG_API_KEY)
//        PushNotificationHandler.shared.setupNotificationFCM(application)
//        Messaging.messaging().delegate = self
//
        setupRootView()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //        setupLocation()
        print(#function)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkAppVersion()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    //MARK: - SETUP FLOW APP
    func setupRootView() {
//        let token = Token()
        window = UIWindow.init(frame: UIScreen.main.bounds)
//        Utils.shared.gotoLogin()
        Utils.shared.gotoHome()
//        if token.tokenExists {
//            Utils.shared.gotoHome()
//            guard let email = token.email, let pass = token.password else {
//                Utils.shared.gotoLogin()
//                return
//            }
//
//            self.login(email, password: pass) { (succes, user, mgs) in
//                if succes {
//                    Utils.shared.gotoHome()
//                }
//            }
//        } else {
//            Utils.shared.gotoHome()
//        }
    }
    
    
    func login(_ email: String, password: String, _ completeHandler:@escaping (_ success: Bool,_ data: UserModel?, _ message : String) ->()) {
        let param :[String: Any] = [
            "email": email,
            "password" : password,
            "device_token" : Messaging.messaging().fcmToken ?? "",
            "mac_address": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        let paramddd = [
            "card_id" : "ccof:gazbdZ0gkyD5N8Vu3GB",
            "appt_id":"19451",
            "org_code":"CDOC"
        ]
        AuthenViewModel().login(parameters: paramddd) { (success, model, mgs) in
            completeHandler(success,model,mgs)
        }
    }
    
    
    //MARK: - SETUP DETECT INTERNET
    func setupNotificationInternet() {
        //        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        detectInternet()
    }
    @objc func statusManager(_ notification: NSNotification) {
        detectInternet()
    }
    func detectInternet() {
        //        guard let status = Network.reachability?.status else { return }
        //        switch status {
        //        case .unreachable:
        //            print("NO INTERNET")
        //            IS_CONNETED_INTERNET = false
        //        case .wifi:
        //            print("HAVE WIFI INTERNET")
        //            IS_CONNETED_INTERNET = true
        //        case .wwan:
        //            print("HAVE 3G INTERNET")
        //            IS_CONNETED_INTERNET = true
        //        }
    }
    
    func setupLocation() {
        //        locationManager.requestWhenInUseAuthorization()
        //        if CLLocationManager.locationServicesEnabled() {
        //            locationManager.delegate = self
        //            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        //            locationManager.startUpdatingLocation()
        //        }
    }
    
    //    func getAppInfo(_ completeHandler : @escaping ()->()) {
    //        let baseViewModel = BaseViewModel()
    //        baseViewModel.locationList(parameters: nil) { (success, data, message) in
    //            guard let data = data else {return}
    //            appVar.locations = data
    //            completeHandler()
    //        }
    //    }
}

//MARK: - NOTIFICAITON
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //setup device
        print(#function)
        #if DEBUG
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        #else
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        #endif
        Messaging.messaging().apnsToken = deviceToken
        print("Messaging.messaging() \(Messaging.messaging().fcmToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
        
    }
    
    //    didreci
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        PushNotificationHandler.shared.didReceiveRemoteNotification(userInfo: userInfo, application: application)
    }
    
}

extension AppDelegate : MessagingDelegate {
    //    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
    //        print(remoteMessage)
    //    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(#function)
         print(fcmToken)
        device_token = fcmToken
    }
}
//
//
//extension AppDelegate: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.currentLocation = locations.last
//        //        NotificationCenter.default.post(name: NSNotification.Name(NotificationKey.kDidUpdateLocation.rawValue), object: nil, userInfo: nil)
//    }
//
//    // Handle authorization for the location manager.
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .restricted:
//            print("Location access was restricted.")
//        case .denied:
//            print("User denied access to location.")
//        // Display the map using the default location.
//        case .notDetermined:
//            print("Location status not determined.")
//        case .authorizedAlways,.authorizedWhenInUse:
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//    // Handle location manager errors.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        print("Error: \(error)")
//    }
//
//}


//MARK: - Check version

extension AppDelegate {
    func checkAppVersion() {
        //        print(#function)
        //        guard let root = window?.rootViewController else {
        //            return
        //        }
        //        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String, let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
        //            return
        //        }
        //        let serverVersion = RemoteConfigManager.shared.getValue(fromKey: .APP_VERSION)
        //        print(serverVersion)
        //        guard let versionNumber = Double(version.westernArabicNumeralsOnly), let serverVersionNumber = Double(serverVersion.westernArabicNumeralsOnly) else {return}
        //        if versionNumber < serverVersionNumber {
        //            let message = String.init(format: localized("Đã có phiên bản mới của %@. Xin vui lòng cập nhật lên phiên bản %@."), appName, serverVersion)
        //            root.showAlert(title: localized("Cập nhật mới"), message: message, buttonTitles: [localized("Cập nhật")], highlightedButtonIndex: nil) { (index) in
        //                self.openUpdateStore()
        //            }
        //        }
    }
    
    func openUpdateStore() {
        //        if let reviewURL = URL(string: RemoteConfigManager.shared.getValue(fromKey: .APP_STORE)), UIApplication.shared.canOpenURL(reviewURL) {
        //            if #available(iOS 10.0, *) {
        //                UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
        //            } else {
        //                UIApplication.shared.openURL(reviewURL)
        //            }
        //        }
    }
}



