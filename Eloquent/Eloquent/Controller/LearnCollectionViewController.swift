//
//  LearnCollectionViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ItemSetCell"

///
/// The card collection view controller
///
class LearnCollectionViewController: UICollectionViewController {
    
    var itemSets: [LearnItemSet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.collectionViewLayout = self.collectionViewLayout(for: traitCollection.horizontalSizeClass, size: self.view.bounds.size)
    }
    
    func collectionViewLayout(for horizontalSizeClass: UIUserInterfaceSizeClass, size: CGSize) -> UICollectionViewLayout {
        let regular = horizontalSizeClass == .regular
        let medium = !regular && (size.width > 500)

        //1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        //3
        let count = regular ? 3 : (medium ? 2 : 1)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count)
        group.interItemSpacing = .fixed((regular || medium) ? 16 : 8)
        
        let section = NSCollectionLayoutSection(group: group)
        let constantInset: CGFloat = regular ? 50 : self.view.layoutMargins.left
        section.contentInsets = NSDirectionalEdgeInsets(top: constantInset / 2.0, leading: constantInset,
                                                        bottom: constantInset, trailing: constantInset)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.collectionViewLayout = self.collectionViewLayout(for: self.traitCollection.horizontalSizeClass, size: size)
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? UINavigationController {
            if let addQuizletVC = navigationVC.viewControllers.first as? AddQuizletViewController {
                addQuizletVC.delegate = self
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemSets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemSetCollectionViewCell
        cell.decorate(for: self.itemSets[indexPath.row])
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension LearnCollectionViewController: AddQuizletViewControllerDelegate {
    
    func addQuizletController(_ controller: AddQuizletViewController, didFinishWithAddedItemSet itemSet: LearnItemSet) {
        print("SUCCESSFULLY retrieved new item set: \(itemSet)")
        
        self.itemSets.append(itemSet)
        self.collectionView.insertItems(at: [IndexPath(row: itemSets.count - 1, section: 0)])
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - ItemSetCollectionViewCell

public class ItemSetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var gradientView: EloquentGradientView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var itemCountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerContinuously()
        self.gradientView.cornerContinuously()
        self.gradientView.gradientColors = [UIColor(named: "Green-Upper")!, UIColor(named: "Green-Lower")!]
    }
    
    public override var isHighlighted: Bool {
        didSet {
            let high = isHighlighted
            UIView.animate(withDuration: high ? 0.2 : 0.3) {
                self.alpha = high ? 0.85 : 1.0
                self.transform = high ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            }
        }
    }
    
    func decorate(for itemSet: LearnItemSet) {
        self.titleLabel.text = itemSet.name.capitalized
        self.itemCountLabel.text = "\(itemSet.items.count) Items"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        self.dateLabel.text = "Created \(dateFormatter.string(from: itemSet.dateCreated))"
    }
    
}
