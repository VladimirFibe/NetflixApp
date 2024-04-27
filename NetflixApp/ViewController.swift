//
//  ViewController.swift
//  NetflixApp
//
//  Created by FibeApp on 26.04.2024.
//

import UIKit

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
        let file = "Movie.json"
        guard let url = Bundle.main.url(forResource: file, withExtension: nil)
        else { fatalError("Failed to locate \(file) in bundle.") }
        print("DEBUG: ", url)
        
        guard let data = try? Data(contentsOf: url)
        else { fatalError("Failed to load \(file) from bundle.")}
        print("DEBUG: ", String(data: data, encoding: .utf8) ?? "no data")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let loaded = try? decoder.decode([Movie].self, from: data) else
        { fatalError("Failed to decode \(file) from bundle.")}
        
        loaded.forEach { print($0.title)}
        
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    private func cellRegistrationHandler<T: SelfCofiguringMovieCell>(cell: T, indexPath: IndexPath, movie: Movie) {
        cell.configure(with: movie)
    }
    
    private func headerRegistrationHandler(view: HomeSectionHeader, kind: String, indexPath: IndexPath) {
        view.confugure(with: "Continue Watching for Ellie")
    }
    
    private func createDataSource() {
        let heroRegistration = UICollectionView.CellRegistration<HeroCell, Movie>(handler: cellRegistrationHandler)
        
        let cellRegistration = UICollectionView.CellRegistration<MovieCell, Movie>(handler: cellRegistrationHandler)
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<HomeSectionHeader>(elementKind: UICollectionView.elementKindSectionHeader, handler: headerRegistrationHandler)
        
        dataSorce = DataSource(collectionView: collectionView) { collectionView, indexPath, movie in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            switch section {
            case .hero: return collectionView.dequeueConfiguredReusableCell(using: heroRegistration, for: indexPath, item: movie)
            case .movie: return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
            }
        }
        
        dataSorce.supplementaryViewProvider = { collectionView, kind, indexPath in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func reloadData() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([], toSection: .hero)
        snapshot.appendItems([], toSection: .movie)
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
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [header]
        
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

