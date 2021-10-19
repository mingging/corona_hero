//
//  HospitalListViewController.swift
//  CoronaHero
//
//  Created by minimani on 2021/10/20.
//

import UIKit

// 컬렉션뷰를 사용하기 위한 프로토콜 상속
class HospitalListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 재활용 가능한 셀을 큐의 형태로 추가
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewCell else {return UICollectionViewCell()}
        
        return cell
    }
    
        // 위 아래 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 17
        }

        // 옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 21
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
