//
//  ViewController.swift
//  NetflixApp
//
//  Created by FibeApp on 26.04.2024.
//

import UIKit

struct Movie: Hashable {
    var id = UUID().uuidString
}

class ViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case hero
        case movie
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    private var dataSorce: DataSource!
    private var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .blue
        view.addSubview(collectionView)
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Movie> { cell, indexPath, movie in
            cell.backgroundColor = .red
        }
        
        dataSorce = DataSource(collectionView: collectionView) { collectionView, indexPath, movie in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([Movie()], toSection: .hero)
        snapshot.appendItems([Movie(), Movie(), Movie(), Movie(), Movie()], toSection: .movie)
        dataSorce.apply(snapshot)
    }
}

extension ViewController {
    private func createHeroSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(106),
                                               heightDimension: .absolute(152))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        return section
    }
 
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{ index, environment in
            if index == 0 {
                self.createHeroSection()
            } else {
                self.createMovieSection()
            }
        }
        return layout
    }
}

#Preview {
    ViewController()
}

