//
//  HospitalListTableViewController.swift
//  CoronaHero
//
//  Created by minimani on 2021/10/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class HospitalListTableViewController: UITableViewController, UISearchBarDelegate {
        
    var collectionView: UICollectionView?
    var lblStartInfo: UILabel?
    let SERVICE_KEY = ""
    var hospitals: [[String:Any]]?

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(hex: "#0080ffff")
        
        // 네비게이션바 설정
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#0080ffff")
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // searchBar 배경 없애기
        searchBar.backgroundImage = UIImage()
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = .white
        }
        
        searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func search(query: String) {
        lblStartInfo?.isHidden = true
        let strURL = "https://api.odcloud.kr/api/apnmOrg/v1/list"
        let params: Parameters = ["serviceKey":SERVICE_KEY, "cond[orgZipaddr::LIKE]":query]
        let request = AF.request(strURL, method: .get, parameters: params)
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                let root = JSON(value)
                self.hospitals = root["data"].arrayObject as? [[String:Any]]
                print(self.hospitals)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    print(error)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            search(query: query)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // cell custom
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = UIColor(hex: "#0080ffff")

        // collection view setting
        self.collectionView = cell.viewWithTag(1) as? UICollectionView
        if let collectionView = self.collectionView {
            collectionView.delegate = self
            collectionView.dataSource = self
            tableView.rowHeight = collectionView.frame.height
            collectionView.clipsToBounds = true
            collectionView.layer.cornerRadius = 30
            collectionView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
        
        self.lblStartInfo = cell.viewWithTag(2) as? UILabel
        
       
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//    }
    
    
}

extension HospitalListTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let hospitals = self.hospitals {
            return hospitals.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? UICollectionViewCell else {return UICollectionViewCell()}
        
        // cell round 조정
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        // cell shadow 추가
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 2)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        
        // collection view insert info
        guard let hospitals = self.hospitals else {return cell}
        let hospital = hospitals[indexPath.row]
        
        let hospital_name = cell.viewWithTag(2) as? UILabel
        hospital_name?.text = hospital["orgnm"] as? String
        hospital_name?.textColor = UIColor(hex: "#0080ffff")
        
        let hospital_number = cell.viewWithTag(3) as? UILabel
        hospital_number?.text = hospital["orgTlno"] as? String
        
        let hospital_status = cell.viewWithTag(4) as? UILabel
        let open = hospital["hldyYn"] as? String
        if open == "N" {
            hospital_status?.text = "운영일"
            hospital_status?.textColor = UIColor(hex: "#0080ffff")
        } else {
            hospital_status?.text = "휴무일"
            hospital_status?.textColor = UIColor(hex: "#F94646ff")
        }
//        guard let open = open else {return cell}

        
        return cell
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 21
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? DetailViewController,
              let indexPath = collectionView?.indexPathsForSelectedItems?.first,
              let hospitals = self.hospitals
        else {return}
        
        let hospital = hospitals[indexPath.row]
        destVC.hospital = hospital
    }
    
}

extension UIColor {
    public convenience init?(hex: String) {
         let r, g, b, a: CGFloat

         if hex.hasPrefix("#") {
             let start = hex.index(hex.startIndex, offsetBy: 1)
             let hexColor = String(hex[start...])

             if hexColor.count == 8 {
                 let scanner = Scanner(string: hexColor)
                 var hexNumber: UInt64 = 0

                 if scanner.scanHexInt64(&hexNumber) {
                     r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                     g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                     b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                     a = CGFloat(hexNumber & 0x000000ff) / 255

                     self.init(red: r, green: g, blue: b, alpha: a)
                     return
                 }
             }
         }

         return nil
     }
}
