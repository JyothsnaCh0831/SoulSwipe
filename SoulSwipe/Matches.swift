//
//  Matches.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/31/23.
//

import UIKit
//import DropDown

class Matches: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var matchesCV: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.matchesCV.delegate = self
        self.matchesCV.dataSource = self
        self.matchesCV.collectionViewLayout = self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.matchesCV.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.matchesCV.dequeueReusableCell(withReuseIdentifier: "profiles", for: indexPath) as! MatchProfileCell
        cell.profileIMG.image = UIImage(named: profiles[indexPath.row]["image"]!)
        cell.profileName.text = profiles[indexPath.row]["name"]
        cell.profileJob.text = profiles[indexPath.row]["job"]
        cell.profileCompatableLevel.text = profiles[indexPath.row]["compatablePercent"]
        return cell
    }
    
    func setLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _,_ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let verticalStackGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                                    heightDimension: .fractionalHeight(1/2)
                ),
                repeatingSubitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: verticalStackGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
        }
        return layout
    }
}
