//
//  TakenLocationCell.swift
//  
//
//  Created by esra.yildiz on 3.08.2018.
//

import UIKit
import MapKit

class TakenLocationCell: UITableViewCell,CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }


    func goTheRegion()
    {
        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600)
        self.map.setRegion(viewRegion, animated: true)
    }
    
}
