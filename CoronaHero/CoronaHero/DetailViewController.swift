//
//  DetailViewController.swift
//  CoronaHero
//
//  Created by minimani on 2021/10/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    var hospital: [String:Any]?

    @IBOutlet weak var hospitalInfoView: UIView!
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblHospitalNumber: UILabel!
    @IBOutlet weak var lblHospitalAddress: UILabel!
    @IBOutlet weak var lblIsOpen: UILabel!
    
    
    
    
    @IBOutlet weak var roadWorkView: UIView!
    @IBOutlet weak var roadTransportView: UIView!
    @IBOutlet weak var roadCarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(hospital)
        // view round 조정
        hospitalInfoView.layer.masksToBounds = true
        hospitalInfoView.layer.cornerRadius = 10
        
        roadWorkView.layer.masksToBounds = true
        roadWorkView.layer.cornerRadius = 10
        
        roadTransportView.layer.masksToBounds = true
        roadTransportView.layer.cornerRadius = 10
        
        roadCarView.layer.masksToBounds = true
        roadCarView.layer.cornerRadius = 10
        
        // 병원 정보 나타내기
        guard let hospital = hospital else {return}
        lblHospitalName.text = hospital["orgnm"] as? String
        lblHospitalNumber.text = hospital["orgTlno"] as? String
        lblHospitalAddress.text = hospital["orgZipaddr"] as? String
        if hospital["hldyYn"] as? String == "Y" {
            lblIsOpen.text = "휴무일"
            lblIsOpen.textColor = UIColor(hex: "#F94646ff")
        } else {
            lblIsOpen.text = "운영중"
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
