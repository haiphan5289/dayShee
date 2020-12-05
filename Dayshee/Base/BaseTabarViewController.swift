//
//  BaseTabarViewController.swift
//  Ayofa
//
//  Created by Admin on 3/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BaseTabbarViewController: UITabBarController {
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupVar()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupVar() {
        setupTabbar()
    }
    
    func setupUI() {
        self.tabBar.isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = TABBAR_COLOR
    }
    
    func setupTabbar() {
        //Khai báo vc
        let vc1 = STORYBOARD_HOME.instantiateViewController(withIdentifier:HomeVC.className) as! HomeVC
        vc1.tabBarItem = UITabBarItem(title: "Trang chủ", image: #imageLiteral(resourceName: "home"), selectedImage:nil)
        let vc2 = STORYBOARD_ORDERS.instantiateViewController(withIdentifier:OrdersVC.className) as! OrdersVC
        vc2.tabBarItem = UITabBarItem(title: "Đơn hàng", image: #imageLiteral(resourceName: "order"), selectedImage: nil)

        let vc3 = STORYBOARD_CART.instantiateViewController(withIdentifier:CartVC.className) as! CartVC
        vc3.tabBarItem = UITabBarItem(title: "Giỏ hàng", image: #imageLiteral(resourceName: "cart"), selectedImage: nil)
        let vc4 = STORYBOARD_NOTIFICATION.instantiateViewController(withIdentifier:NotificationVC.className) as! NotificationVC
        vc4.tabBarItem = UITabBarItem(title: "Thông báo", image: #imageLiteral(resourceName: "notification"), selectedImage: nil)
        
        let vc5 = STORYBOARD_SETTING.instantiateViewController(withIdentifier:SettingVC.className) as! SettingVC
        vc5.tabBarItem = UITabBarItem(title: "Cá nhân", image: #imageLiteral(resourceName: "Mask"), selectedImage: nil)

        //1 mảng vc
        let nav1 = BaseNavigationController(rootViewController: vc1)
        let nav2 = BaseNavigationController(rootViewController: vc2)
        let nav3 = BaseNavigationController(rootViewController: vc3)
        let nav4 = BaseNavigationController(rootViewController: vc4)
        let nav5 = BaseNavigationController(rootViewController: vc5)
        self.viewControllers = [nav1, nav2,nav3, nav4, nav5]
        
        var list = RealmManager.shared.getCartProduct()
        vc3.tabBarItem.badgeValue = (list.count > 0) ? "\(list.count)" : nil
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: PushNotificationKeys.didUpdateCartProduct.rawValue))
            .asObservable()
            .bind { _ in
                list = RealmManager.shared.getCartProduct()
                vc3.tabBarItem.badgeValue = (list.count > 0) ? "\(list.count)" : nil
            }.disposed(by: disposeBag)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Handle didSelect viewController method here
    }
}
