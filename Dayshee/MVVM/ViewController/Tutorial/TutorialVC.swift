//
//  TutorialVC.swift
//  Dayshee
//
//  Created by haiphan on 12/28/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TutorialVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btTutorial: UIButton!
    @IBOutlet weak var btSkip: UIButton!
    private var viewDidApear: PublishSubject<Void> = PublishSubject.init()
    private var heightImageObs: PublishSubject<CGFloat> = PublishSubject.init()
    private var heightImage: CGFloat = 0
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidApear.onNext(())
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension TutorialVC {
    private func visualize() {
        collectionView.delegate = self
        collectionView.register(TutorialCell.nib, forCellWithReuseIdentifier: TutorialCell.identifier)
        pageControl.numberOfPages = 3
    }
    private func setupRX() {
        Observable.just([1,2,3])
            .bind(to: self.collectionView.rx.items(cellIdentifier: TutorialCell.identifier, cellType: TutorialCell.self)) { row, data, cell in
                self.heightImageObs.onNext(cell.vImg.bounds.height)
                cell.vMarketing.isHidden = (row == 0) ? false : true
                cell.vManahe.isHidden = (row == 1) ? false : true
                cell.vGift.isHidden = (row == 2) ? false : true
                cell.addImageIcon(row: row, height: self.heightImage)
        }.disposed(by: disposeBag)
        
        self.btSkip.rx.tap.bind { _ in
            let vc = BaseTabbarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        self.btTutorial.rx.tap.bind { _ in
            let vc = TutorialDetail(nibName: "TutorialDetail", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        self.viewDidApear.asObservable().bind(onNext: weakify({ (wSelf) in
            wSelf.collectionView.reloadData()
        })).disposed(by: disposeBag)
        
        self.heightImageObs.asObservable().bind(onNext: weakify({ (height, wSelf) in
            guard height > 0 else {
                return
            }
            wSelf.heightImage = height
        })).disposed(by: disposeBag)
        
    }
}
extension TutorialVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Hiển thị page curent
        let page_number = targetContentOffset.pointee.x / (self.view.frame.width - 40)
        pageControl.currentPage = Int(page_number)
    }
    

}
