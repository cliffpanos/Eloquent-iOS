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
    
    public var itemSets: [LearnItemSet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.collectionViewLayout = self.collectionViewLayout(for: traitCollection.horizontalSizeClass, size: self.view.bounds.size)
        
        // TESTING
        let urlStrings: [String] = [
            "https://quizlet.com/145245325/midterm-review-flash-cards/",
            "https://quizlet.com/190542265/world-war-2-people-flash-cards/",
            "https://quizlet.com/419957631/psychology-flash-cards/",
            "https://quizlet.com/hk/360473641/art-history-greek-art-flash-cards/",
            "https://quizlet.com/408107038/roman-poets-latin-1-flash-cards/",
            "https://quizlet.com/292038032/heart-diagram/",
            "https://quizlet.com/302588994/american-history-flash-cards/",
            "https://quizlet.com/465219970/health-flash-cards/",
        ]
        for urlString in urlStrings {
            let quizletExtractor = QuizletSetExtractor(setURL: URL(string: urlString)!)
            quizletExtractor.extractItems { newItemSet in
                guard let newItemSet = newItemSet else { return }
                self.itemSets.append(newItemSet)
                self.collectionView.insertItems(at: [IndexPath(row: self.itemSets.count - 1, section: 0)])
            }
        }
    }
    
    private var currentColumnCount: Int = 1
    
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
        self.currentColumnCount = count
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count)
        group.interItemSpacing = .fixed((regular || medium) ? 16 : 8)
        
        let section = NSCollectionLayoutSection(group: group)
        let constantInset: CGFloat = regular ? 50 : 16//self.view.layoutMargins.left
        section.contentInsets = NSDirectionalEdgeInsets(top: constantInset / 2.0, leading: constantInset,
                                                        bottom: constantInset, trailing: constantInset)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.collectionViewLayout = self.collectionViewLayout(for: self.traitCollection.horizontalSizeClass, size: size)
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? UINavigationController {
            if let addQuizletVC = navigationVC.viewControllers.first as? AddQuizletViewController {
                addQuizletVC.delegate = self
            } else if let explainTermVC = navigationVC.viewControllers.first as? ExplainTermViewController,
                let sender = sender as? UICollectionViewCell,
                let indexPath = collectionView.indexPath(for: sender) {
                explainTermVC.itemSet = self.itemSets[indexPath.row]
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemSets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemSetCollectionViewCell
        
        let (row, col) = indexPath.row.quotientAndRemainder(dividingBy: self.currentColumnCount)
        let indexPathSum = row + col
        
        let gradientCount = colorsGradients.count
        let (_, colorGradientIndex) = indexPathSum.quotientAndRemainder(dividingBy: gradientCount)
        let colorGradient = self.colorsGradients[colorGradientIndex]
        
        cell.decorate(for: self.itemSets[indexPath.row], colors: colorGradient)
        return cell
    }
    
    
    // MARK: - Private
    
    private let colorsGradients = [
        [UIColor.mainShade1, UIColor.mainShade1.with(hueDelta: 0.03)],
        [UIColor.mainShade2, UIColor.mainShade2.with(hueDelta: 0.03)],
        [UIColor.mainShade3, UIColor.mainShade3.with(hueDelta: 0.03)],
        [UIColor.mainShade4, UIColor.mainShade4.with(hueDelta: 0.03)],
        [UIColor.mainShade3, UIColor.mainShade3.with(hueDelta: 0.03)],
        [UIColor.mainShade2, UIColor.mainShade2.with(hueDelta: 0.03)],
    ]


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
                self.alpha = high ? 0.9 : 1.0
                self.transform = high ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            }
        }
    }
    
    func decorate(for itemSet: LearnItemSet, colors: [UIColor]) {
        self.titleLabel.text = itemSet.name.capitalized
        self.itemCountLabel.text = "\(itemSet.items.count) Items"
        self.gradientView.gradientColors = colors
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        self.dateLabel.text = "Created \(dateFormatter.string(from: itemSet.dateCreated))"
    }
    
}
