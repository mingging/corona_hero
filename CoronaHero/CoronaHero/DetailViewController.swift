//
//  DetailViewController.swift
//  CoronaHero
//
//  Created by minimani on 2021/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController {
    
    var hospital: [String:Any]?
    var mapView: MTMapView = MTMapView()
    let API_KEY = ""
    var lat: Double?
    var lon: Double?

    @IBOutlet weak var hospitalInfoView: UIView!
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblHospitalNumber: UILabel!
    @IBOutlet weak var lblHospitalAddress: UILabel!
    @IBOutlet weak var lblIsOpen: UILabel!
    @IBOutlet var onMapView: UIView!
    
    @IBOutlet var moreInfoView: UIView!
    @IBOutlet var findloadView: UIView!
    
    @IBOutlet var lblOpenTime: UILabel!
    @IBOutlet var lblLunchTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        
     

        // map view 나타내기
        mapView = MTMapView(frame: onMapView.bounds)
        mapView.baseMapType = .standard
        onMapView.addSubview(mapView)
        
        // view round 조정
        hospitalInfoView.layer.masksToBounds = true
        hospitalInfoView.layer.cornerRadius = 10
        moreInfoView.layer.masksToBounds = true
        moreInfoView.layer.cornerRadius = 10
        findloadView.layer.masksToBounds = true
        findloadView.layer.cornerRadius = 10
 
        
        // 병원 정보 나타내기
        guard let hospital = hospital,
              let hospitalAddress =  hospital["orgZipaddr"] as? String
        else {return}
        lblHospitalName.text = hospital["orgnm"] as? String
        lblHospitalNumber.text = hospital["orgTlno"] as? String
        lblHospitalAddress.text = hospitalAddress
        if hospital["hldyYn"] as? String == "Y" {
            lblIsOpen.text = "휴무일"
            lblIsOpen.textColor = UIColor(hex: "#F94646ff")
        } else {
            lblIsOpen.text = "운영일"
        }
        guard let startTime = hospital["sttTm"] as? String,
              let endTime = hospital["endTm"] as? String,
              let lunchStartTime = hospital["lunchSttTm"] as? String,
              let lunchEndTim = hospital["lunchEndTm"] as? String
        else {return}
        lblOpenTime.text = "\(timeFormatter(time: startTime)) ~ \(timeFormatter(time: endTime))"
        lblLunchTime.text = "\(timeFormatter(time: lunchStartTime)) ~ \(timeFormatter(time: lunchEndTim))"
        
        // 병원 정보 기준 위치 나타내기
        getGeo(query: hospitalAddress)
    }
    
    // 시간 중간에 : 표시하기
    func timeFormatter(time: String) -> String {
        let array = Array(time)
        var temp = ""
        for i in 0..<array.count {
            if (i == 1) {
                temp += "\(array[i]):"
            } else {
                temp += "\(array[i])"
            }
        }
        return temp
    }
    
    func getGeo(query: String) {
        let strURL = "https://dapi.kakao.com/v2/local/search/address.json"
        let params: Parameters = ["query":query]
        let headers: HTTPHeaders = ["Authorization":API_KEY]
        let alamo = AF.request(strURL, method: .get, parameters: params, headers: headers)
        
        alamo.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.lat = json["documents"].arrayValue[0]["y"].doubleValue
                self.lon = json["documents"].arrayValue[0]["x"].doubleValue
                
                // 지도에 핀띄우기
                guard let lat = self.lat, let lon = self.lon else {return}
                let item = MTMapPOIItem()
                let pointGeo = MTMapPointGeo(latitude: lat, longitude: lon)
                let mapPoint = MTMapPoint(geoCoord: pointGeo)
                self.mapView.setMapCenter(mapPoint, animated: true)
                self.mapView.setZoomLevel(-1, animated: true)
                item.mapPoint = mapPoint
                item.markerType = .redPin
                self.mapView.add(item)
            case .failure(let error):
                if let error = error.errorDescription {
                    print(error)
                }
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
