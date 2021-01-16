//
//  RateVC.swift
//  Dayshee
//
//  Created by paxcreation on 11/10/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Cosmos

class RateVC: UIViewController, ActivityTrackingProgressProtocol {
    
    @IBOutlet weak var imgLine: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btImagePicker: UIButton!
    @IBOutlet weak var vRating: CosmosView!
    @IBOutlet weak var btRate: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @VariableReplay private var dataSource: [UIImage] = []
    
    var productID: Int?
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension RateVC {
    private func visualize() {
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .highlighted)
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        title = "Viết đánh giá của bạn"
        
        self.textView.text = "Nhập nội dung đánh giá của bạn vào đây"
        self.textView.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ColorApp")
        collectionView.delegate = self
        collectionView.register(RateCell.nib, forCellWithReuseIdentifier: RateCell.identifier)
    }
    private func setupRX() {
        let token = Token()
        
        if !token.tokenExists {
            let vc = self
            vc.hidesBottomBarWhenPushed = false
            let login = STORYBOARD_AUTH.instantiateViewController(withIdentifier: LoginVC.className) as! LoginVC
            login.hidesBottomBarWhenPushed = false
            login.typeLogin = .rate
            login.delegateRate = self
            self.navigationController?.pushViewController(login, animated: true)
        }
        
        
        textView.rx.didBeginEditing.bind(onNext: weakify { (wSelf) in
            self.textView.text = nil
            self.textView.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
        }).disposed(by: disposeBag)
        
        self.btImagePicker.rx.tap.bind { _ in
            let img: UIImagePickerController = UIImagePickerController()
            img.delegate = self
            img.sourceType = .photoLibrary
            self.present(img, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        self.btRate.rx.tap.bind(onNext: weakify({ (wSelf) in
            guard self.textView.text != "" else {
                wSelf.showAlert(title: nil, message: "Vui lòng nhập nôi dung đánh giá")
                return
            }
            guard let id = wSelf.productID, let text = wSelf.textView.text else {
                return
            }
            let p: [String : Any] = [
                "product_id":  id,
                "rating": wSelf.vRating.rating,
                "comment": text
            ]
            wSelf.rate(p: p, imgs: self.dataSource)
        })).disposed(by: disposeBag)
        
        Observable.just([UIImage(), UIImage(), UIImage()])
            .bind(to: collectionView.rx.items(cellIdentifier: RateCell.identifier, cellType: RateCell.self)) { row, data, cell in
                cell.img.backgroundColor = .gray
                cell.img.image = data
                cell.btRemove.isHidden = true
                self.dataSource.enumerated().forEach { (i) in
                    if row == i.offset {
                        cell.img.image = i.element
                        cell.btRemove.isHidden = false
                    }
                }
                cell.remove = {
                    self.dataSource.remove(at: row)
                    self.collectionView.reloadData()
                }
            }.disposed(by: disposeBag)
    }
    private func rate(p: [String : Any], imgs: [UIImage]) {
        RequestService.shared.APIUpload(ofType: OptionalMessageDTO<RateModel>.self,
                                         url: SERVER + APILink.rate.rawValue,
                                         parameters: p,
                                         method: .post,
                                         header: nil,
                                         urlIMG: "images[]",
                                         img: imgs)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success( _):
                    self.showAlert(title: nil, message: "Cám ơn ban đã đánh giá")
                case .failure(let err):
                    self.showAlert(title: nil, message: err.message)
                }}.disposed(by: disposeBag)
    }
    
}
extension RateVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let count = tempImage.jpegData(compressionQuality: 1)?.count
        else {
            return
        }
        guard let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            print("Không có image url")
            return
        }
        switch count {
        case 0...5000:
            tempImage.jpegData(compressionQuality: 1)
        case 5000...10000:
            tempImage.jpegData(compressionQuality: 0.5)
        case 10000...15000:
            tempImage.jpegData(compressionQuality: 0.3)
        default:
            tempImage.jpegData(compressionQuality: 0.01)
        }
        self.dismiss(animated: true) {
            if self.dataSource.count >= 3 {
                self.dataSource.remove(at: 2)
                self.dataSource.insert(tempImage, at: 0)
            } else {
                self.dataSource.insert(tempImage, at: 0)
            }
            self.collectionView.reloadData()
        }
    }
}
extension RateVC: RateLoginDelegate {
    func callBack() {
        let vc = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.popToViewController(self, animated: true)
    }
}
extension RateVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: self.collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
