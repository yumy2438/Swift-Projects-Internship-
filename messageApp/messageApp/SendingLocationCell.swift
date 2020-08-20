//
//  SendingLocationCell.swift
//  messageApp
//
//  Created by esra.yildiz on 2.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import MapKit

class SendingLocationCell: UITableViewCell,CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()
    
    override func awakeFromNib()
    {
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
