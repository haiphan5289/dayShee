//
//  LBXScanViewController.swift
//  swiftScan
//
//  Created by lbxia on 15/12/8.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

public protocol LBXScanViewControllerDelegate: class {
    func scanFinished(scanResult: LBXScanResult, error: String?)
}

public protocol QRRectDelegate {
    func drawwed()
}

open class LBXScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //返回扫码结果，也可以通过继承本控制器，改写该handleCodeResult方法即可
    open weak var scanResultDelegate: LBXScanViewControllerDelegate?
    
    open var delegate: QRRectDelegate?
    
    open var scanObj: LBXScanWrapper?
    
    open var scanStyle: LBXScanViewStyle? = LBXScanViewStyle()
    
    open var qRScanView: LBXScanView?
    
    
    //启动区域识别功能
    open var isOpenInterestRect = false
    
    //识别码的类型
    public var arrayCodeType:[AVMetadataObject.ObjectType]?
    
    //是否需要识别后的当前图像
    public  var isNeedCodeImage = false
    
    //相机启动提示文字
    public var readyString:String! = "loading"
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // [self.view addSubview:_qRScanView];
        self.view.backgroundColor = UIColor.black
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
    }
    
    open func setNeedCodeImage(needCodeImg:Bool)
    {
        isNeedCodeImage = needCodeImg;
    }
    //设置框内识别
    open func setOpenInterestRect(isOpen:Bool){
        isOpenInterestRect = isOpen
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawScanView()
        
        perform(#selector(LBXScanViewController.startScan), with: nil, afterDelay: 0.3)
    }
    
    @objc open func startScan()
    {
        
        if (scanObj == nil)
        {
            var cropRect = CGRect.zero
            if isOpenInterestRect
            {
                cropRect = LBXScanView.getScanRectWithPreView(preView: self.view, style:scanStyle! )
            }
            
            //指定识别几种码
            if arrayCodeType == nil
            {
                arrayCodeType = [AVMetadataObject.ObjectType.qr as NSString ,AVMetadataObject.ObjectType.ean13 as NSString ,AVMetadataObject.ObjectType.code128 as NSString] as [AVMetadataObject.ObjectType]
            }
            
            scanObj = LBXScanWrapper(videoPreView: self.view,objType:arrayCodeType!, isCaptureImg: isNeedCodeImage,cropRect:cropRect, success: { [weak self] (arrayResult) -> Void in
                
                if let strongSelf = self
                {
                    //停止扫描动画
                    strongSelf.qRScanView?.stopScanAnimation()
                    
                    strongSelf.handleCodeResult(arrayResult: arrayResult)
                }
            })
        }
        
        //结束相机等待提示
        qRScanView?.deviceStopReadying()
        
        //开始扫描动画
        qRScanView?.startScanAnimation()
        
        //相机运行
        scanObj?.start()
    }
    
    open func drawScanView()
    {
        if qRScanView == nil
        {
            qRScanView = LBXScanView(frame: self.view.frame,vstyle:scanStyle! )
            self.view.addSubview(qRScanView!)
            delegate?.drawwed()
        }
        qRScanView?.deviceStartReadying(readyStr: readyString)
        setupButton()
        
    }
    
    func setupButton() {
//        let button = UIButton.init()
//        button.addTarget(self, action: #selector(self.openPhotoAlbum), for: .touchUpInside)
//        button.backgroundColor = TINT_COLOR
//        button.layer.cornerRadius = 5
//        button.setTitleColor(.white, for: .normal)
//        button.setTitle(localized("Thư viện"), for: .normal)
//        self.view.addSubview(button)
//        button.snp.makeConstraints { [weak self] (make) in
//            guard let strongSelf = self else {return}
//            make.height.equalTo(40)
//            make.width.equalTo(240)
//            make.centerX.equalToSuperview()
//            if #available(iOS 11, *) {
//                make.bottom.equalTo(strongSelf.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-10)
//            } else {
//                make.bottom.equalTo(strongSelf.view.snp.bottomMargin).offset(-10)
//            }
//        }
//
//        let cancelButton = UIButton.init()
//        cancelButton.addTarget(self, action: #selector(self.cancelScan), for: .touchUpInside)
//        cancelButton.backgroundColor = TINT_COLOR
//        cancelButton.layer.cornerRadius = 5
//        cancelButton.setTitleColor(.white, for: .normal)
//        cancelButton.setTitle("kCancelButton", for: .normal)
//        self.view.addSubview(cancelButton)
//        cancelButton.snp.makeConstraints { [weak self] (make) in
//            guard let strongSelf = self else {return}
//            make.height.equalTo(40)
//            make.width.equalTo(90)
//            make.trailingMargin.equalToSuperview().offset(-10)
//            if #available(iOS 11, *) {
//                make.top.equalTo(strongSelf.view.safeAreaLayoutGuide.snp.topMargin).offset(10)
//            } else {
//                make.bottom.equalTo(strongSelf.view.snp.topMargin).offset(10)
//            }
//        }
    }
    
    /**
     处理扫码结果，如果是继承本控制器的，可以重写该方法,作出相应地处理，或者设置delegate作出相应处理
     */
    open func handleCodeResult(arrayResult:[LBXScanResult])
    {
        if let scanResultDelegate = scanResultDelegate  {
            let result:LBXScanResult = arrayResult[0]
            
            scanResultDelegate.scanFinished(scanResult: result, error: nil)
        }
         qRScanView?.stopScanAnimation()
//        dismiss(animated: true, completion: nil)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        qRScanView?.stopScanAnimation()
        
        scanObj?.stop()
    }
    
    @objc open func openPhotoAlbum()
    {
        LBXPermissions.authorizePhotoWith { [weak self] (granted) in
            
            let picker = UIImagePickerController()
            
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            picker.delegate = self;
            
            picker.allowsEditing = true
            
            self?.present(picker, animated: true, completion: nil)
        }
    }
    
    @objc func cancelScan() {
        dismiss(animated: true, completion: nil)
    }
}
