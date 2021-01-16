//
//  ListAgency.swift
//  Dayshee
//
//  Created by haiphan on 12/26/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import CoreLocation

class ListAgency: UIViewController, ActivityTrackingProgressProtocol, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @VariableReplay private var listAgency: [ListAgencyModel] = []
    private var listView: [UIView] = []
    private var locationManager = CLLocationManager()
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
    
    @IBAction func policyAction(_ sender: Any) {
        guard let url = URL(string: POLICY_WEBSITE) else {
            return
        }
        UIApplication.shared.open(url, options: [:]) { (success) in
            //
        }
    }
    
}
extension ListAgency {
    private func visualize() {
        let buttonLeft = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        buttonLeft.setImage(UIImage(named: "ic_arrow_left_black"), for: .normal)
        buttonLeft.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem(customView: buttonLeft)

        navigationItem.leftBarButtonItem = leftBarButton
        buttonLeft.rx.tap.bind { _ in
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)

        title = "Nhà phân phối"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15.0) ?? UIImage() ]
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ColorApp")
        let vLine: UIView = UIView(frame: .zero)
        vLine.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        self.view.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        mapView.delegate = self
        locationManager.delegate = self
        
    }
    private func setupRX() {
        self.getListAgency()
        
        self.indicator.asObservable().bind(onNext: { (item) in
            item ? LoadingManager.instance.show() : LoadingManager.instance.dismiss()
        }).disposed(by: disposeBag)
        
        self.$listAgency.asObservable().bind(onNext: weakify({ (list, wSelf) in
            list.forEach { (listAgency) in
                let locationDayshee = CLLocationCoordinate2D(latitude: listAgency.latitude ?? 0, longitude: listAgency.longitude ?? 0)
                
//                let annotation = MyCustomPointAnnotation(listAgency: listAgency.agencies ?? [], name: listAgency.province ?? "")
//                annotation.coordinate = locationDayshee
//                annotation.title = listAgency.province
//                wSelf.mapView.addAnnotation(annotation)
                
                let annotation = OriginAnnotation()
                let name = listAgency.agencies?.first?.name
                let code = listAgency.agencies?.first?.code

                annotation.title = "\(listAgency.province ?? "")-\(name ?? "")-\(code ?? "")"
                annotation.coordinate = locationDayshee
                wSelf.mapView.addAnnotation(annotation)

            }
            //this is the center location to view the map VN
            let locationDayshee = CLLocationCoordinate2D(latitude: 16.313281, longitude: 106.224423)
            let regionRadius: CLLocationDistance = 500000
            let coordinateRegion = MKCoordinateRegion(center: locationDayshee,
                                                      latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
            wSelf.mapView.setRegion(coordinateRegion, animated: false)
        })).disposed(by: disposeBag)
    }
    private func getListAgency() {
        RequestService.shared.APIData(ofType: OptionalMessageDTO<[ListAgencyModel]>.self,
                                      url: APILink.agency.rawValue,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { [weak self] (result) in
                guard let wSelf = self else {
                    return
                }
                switch result {
                case .success( let data):
                    guard let data = data.data, let list = data else {
                        return
                    }
                    wSelf.listAgency = list.filter({ (model) -> Bool in
                        if let agencies = model.agencies, agencies.count > 0 {
                            return true
                        }
                        return false
                    })
                case .failure( _):
                    break
                }}.disposed(by: disposeBag)
    }

}
extension ListAgency: MKMapViewDelegate {
    // Delegate method for mapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
        if annotation.isKind(of: OriginAnnotation.self) {
//            view.image = UIImage(named: "ic_pin")
                        view.image = UIImage(named: "pin_origin")

            
            view.canShowCallout = true
        }
return view
//        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
//        annotationView.glyphImage = UIImage(named: "ic_pin")
//        annotationView.canShowCallout = true
//        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        listView.forEach { (v) in
//            v.removeFromSuperview()
//        }
//        guard let customAnnotation = view.annotation as? MyCustomPointAnnotation else {
//            return
//        }
//        let v: UIView = UIView(frame: .zero)
//        var listViewAgency: [UIView] = []
//        customAnnotation.listAgency.forEach { (agency) in
//            let viewAgency: UIView = UIView(frame: .zero)
//            viewAgency.backgroundColor = .clear
//
////            let lbProvince: UILabel = UILabel()
////            lbProvince.text = "\(customAnnotation.nameProvince)"
////            lbProvince.font = UIFont(name: "Montserrat-Regular", size: 8)
////            viewAgency.addSubview(lbProvince)
////            lbProvince.snp.makeConstraints { (make) in
////                make.left.bottom.top.equalToSuperview()
////                make.height.equalTo(20)
////            }
//
//            let lbNameAgency: UILabel = UILabel()
//            lbNameAgency.text = " \(agency.name ?? "")"
//            lbNameAgency.font = UIFont(name: "Montserrat-Regular", size: 8)
//            viewAgency.addSubview(lbNameAgency)
//            lbNameAgency.snp.makeConstraints { (make) in
//                make.left.bottom.top.equalToSuperview()
//                make.height.equalTo(20)
//            }
//
//            let lbCode: UILabel = UILabel()
//            lbCode.text = " \(agency.code ?? "")"
//            lbCode.font = UIFont(name: "Montserrat-Regular", size: 8)
//            viewAgency.addSubview(lbCode)
//            lbCode.snp.makeConstraints { (make) in
//                make.left.equalTo(lbNameAgency.snp.right)
//                make.centerY.equalTo(lbNameAgency)
//            }
//            listViewAgency.append(viewAgency)
//        }
//        let stackView: UIStackView = UIStackView(arrangedSubviews: listViewAgency, axis: .vertical)
//        stackView.spacing = 5
//        v.addSubview(stackView)
//        stackView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//
//        }
//        self.listView.append(v)
//        view.addSubview(v)
//        v.backgroundColor = .white
//        v.snp.makeConstraints { (make) in
//            make.left.equalTo(view.snp.right).inset(-10)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(400)
//            make.height.equalTo((20 + 5) * listViewAgency.count )
//        }

    }
}
class MyCustomPointAnnotation: MKPointAnnotation {
    var listAgency: [Agency] = []
    var nameProvince: String = ""

    init(listAgency: [Agency], name: String) {
        self.listAgency = listAgency
        self.nameProvince = name
     }
}
class OriginAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?

    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.image = nil
    }
}
