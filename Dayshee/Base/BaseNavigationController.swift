//
//  BaseNavigationController.swift
//  Ayofa
//
//  Created by Admin on 3/5/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import GooglePlaces
import SideMenu
import DKImagePickerController

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavUI()
    }
    
    func setupNavUI() {
        self.delegate = self
        // Changing the Font of Navigation Bar Title
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: FONT_MEDIUM, size: 15)!, NSAttributedString.Key.foregroundColor : UIColor.white] as [NSAttributedString.Key : Any]
        
        // Changing the Color and Font of Back button
        UINavigationBar .appearance().tintColor = UIColor.white
        self.navigationBar.barTintColor =  NAVI_COLOR
        
        //         Hidden title Back in UIBarButtonItem
        if #available(iOS 11, *) {
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -UIScreen.main.bounds.width, vertical: 0), for:UIBarMetrics.default)
        } else {
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -200), for:UIBarMetrics.default)
        }
        
        let backButtonImage: UIImage = #imageLiteral(resourceName: "back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage

        navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        
    }
}

class BaseViewController: UIViewController {
    
    var cart: BadgedButtonItem =  BadgedButtonItem(with: #imageLiteral(resourceName: "cart"))
    var pickedGMSPlaceHandler : ((_ place: GMSPlace)->())?
    var menu: UIBarButtonItem = UIBarButtonItem()
    var isFromChangeCart = true
    
    var callBackWithAction: ((_ action: Int?, _ value: Any?) -> ())?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = cart
        setup()
        cart.tapAction = {
            self.selectCart()
        }
        didChangeCart()
    }
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeCart), name: NSNotification.Name(PushNotificationKeys.didUpdateCart.rawValue), object: nil)
    }
    
    func setBagdeCart(_ number: Int) {
        self.cart.setBadge(with: number)
    }
    
    func showGMSAutocomplete(completeHanler : @escaping ((_ place: GMSPlace)->())) {
        pickedGMSPlaceHandler = completeHanler
        let autocompleteController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .address  //suitable filter type
        filter.country = "VN"
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self
//        autocompleteController.primaryTextColor = .red
        UINavigationBar .appearance().tintColor = UIColor.black
        present(autocompleteController, animated: true, completion: {
            UINavigationBar .appearance().tintColor = TINT_COLOR
        })
    }
    
    open func push(_ vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    open func pop() {
        self.navigationController?.popViewController()
    }
    
    
    //MARK: - cart
    
    @objc private func selectCart() {
        SHARE_APPLICATION_DELEGATE.tabbar?.selectedIndex = 2
    }
    
    @objc func didChangeCart() {
        self.updateCart()
        
    }
    @objc func updateCart()  {
//        cart.setBadge(with: 5)
        cart.setBadge(with: RealmManager.shared.get().count)

        if let tabItems = SHARE_APPLICATION_DELEGATE.tabbar?.tabBar.items {
            animateView(view: self.cart.customView!)
        }
    }
}


//ANIMATION TABBAR

func animateView(view:UIView){
    let shakeAnimation = CABasicAnimation(keyPath: "position")
    shakeAnimation.duration = 0.05
    shakeAnimation.repeatCount = 2
    shakeAnimation.autoreverses = true
    shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x:view.center.x - 4, y:view.center.y))
    shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x:view.center.x + 4, y:view.center.y))
    view.layer.add(shakeAnimation, forKey: "position")
}

//MARK: - GMSAutocompleteViewControllerDelegate

extension BaseViewController : GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        viewController.dismiss(animated: true) { [weak self] in
            if self?.pickedGMSPlaceHandler != nil {
                self?.pickedGMSPlaceHandler!(place)
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//MARK: - DKImagePickerController
extension BaseViewController {
    func showImagePicker(maxSelectableCount : Int, completeHanler : @escaping ((_ images : [UIImage])->())) {
        let pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        pickerController.maxSelectableCount = maxSelectableCount
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.fetchPickedImage(assets: assets, completeHanler: { (images) in
                completeHanler(images)
            })
        }
        self.present(pickerController, animated: true, completion: nil)
    }
    
    private func fetchPickedImage(assets: [DKAsset], completeHanler : @escaping ((_ images : [UIImage])->())) {
        var images = [UIImage]()
        let group = DispatchGroup()
        for asset in assets {
            group.enter()
            asset.fetchImageData(completeBlock: { (data, dict) in
                guard let _data = data, let image = UIImage.init(data: _data) else {
                    group.leave()
                    return
                }
                images.append(image)
                group.leave()
            })
        }
        group.notify(queue: .main) {
            completeHanler(images)
        }
    }
}


class BaseHiddenNavigationController: BaseViewController {
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.navigationController?.isNavigationBarHidden = false
    }
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //         self.navigationController?.isNavigationBarHidden = false
    //    }
    //
}

class BaseUnHiddenNavigationController: BaseViewController {
    
    var completeResultHandler : ((_ success : Bool)->())?
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
      self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//                self.navigationController?.isNavigationBarHidden = true
    }
 
}

class BadgedButtonItem: UIBarButtonItem {
    
    public func setBadge(with value: Int) {
        self.badgeValue = value
    }
    
    private var badgeValue: Int? {
        didSet {
            if let value = badgeValue,
                value > 0 {
                lblBadge.isHidden = false
                lblBadge.text = "\(value)"
            } else {
                lblBadge.isHidden = true
            }
        }
    }
    
    var tapAction: (() -> Void)?
    
    private let filterBtn = UIButton()
    private let lblBadge = UILabel()
    
    override init() {
        super.init()
        setup()
    }
    
    init(with image: UIImage?) {
        super.init()
        setup(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(image: UIImage? = nil) {
        
        self.filterBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.filterBtn.adjustsImageWhenHighlighted = false
        self.filterBtn.setImage(image, for: .normal)
        self.filterBtn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.lblBadge.frame = CGRect(x: 25, y: -2, width: 15, height: 15)
        self.lblBadge.backgroundColor = UIColor.init(hex: "ffc600")
        self.lblBadge.clipsToBounds = true
        self.lblBadge.layer.cornerRadius = 7
        self.lblBadge.textColor = UIColor.black
        self.lblBadge.font = UIFont.systemFont(ofSize: 10)
        self.lblBadge.textAlignment = .center
        self.lblBadge.isHidden = true
        self.lblBadge.minimumScaleFactor = 0.1
        self.lblBadge.adjustsFontSizeToFitWidth = true
        self.filterBtn.addSubview(lblBadge)
        self.customView = filterBtn
    }
    
    @objc func buttonPressed() {
        if let action = tapAction {
            action()
        }
    }
    
}
class BaseNoCartVC: BaseViewController {
    
    var completeResultHandler : ((_ success : Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.navigationController?.isNavigationBarHidden = true
    }
    
    
}
