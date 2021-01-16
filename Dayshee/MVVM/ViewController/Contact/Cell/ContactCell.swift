//
//  ContactCell.swift
//  Dayshee
//
//  Created by paxcreation on 12/25/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RxCocoa
import RxSwift

class ContactCell: UITableViewCell, CLLocationManagerDelegate {
    
    //    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tvContent: UITextView!
    private let disposeBag = DisposeBag()
    var locationManager = CLLocationManager()
    override func awakeFromNib() {
        super.awakeFromNib()
        mapView.delegate = self
        locationManager.delegate = self
        let locationDayshee = CLLocationCoordinate2D(latitude: 10.742936, longitude: 106.697322)
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegion(center: locationDayshee,
                                                  latitudinalMeters: regionRadius * 6.0, longitudinalMeters: regionRadius * 6.0)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationDayshee
        //        annotation.title = "SDKP"
        mapView.addAnnotation(annotation)
        mapView.setRegion(coordinateRegion, animated: false)
        
        self.tvContent.text = "Nhập nội dung đánh giá của bạn vào đây"
        self.tvContent.textColor = #colorLiteral(red: 0.3882352941, green: 0.4470588235, blue: 0.5019607843, alpha: 1)
        
        setupRX()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
extension ContactCell {
    private func setupRX() {
        tvContent.rx.didBeginEditing.bind { _ in
            self.tvContent.text = nil
            self.tvContent.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
        }.disposed(by: disposeBag)
    }
}
extension ContactCell: MKMapViewDelegate {
    // Delegate method for mapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.glyphImage = UIImage(named: "ic_pin")
        return annotationView
    }
}
