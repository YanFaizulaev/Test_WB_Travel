//
//  MainController.swift
//  Test_WB_Travel
//
//  Created by Bandit on 04.08.2023.
//

import UIKit

class MainController: UIViewController {
    
    // MARK: - Views
    
    private lazy var collectionView: UICollectionView = {
        let tempLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tempLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - DataSource
    
    typealias CollectionDataSource = UICollectionViewDiffableDataSource<Section, ModelCell>
    typealias CollectionSnapshot = NSDiffableDataSourceSnapshot<Section, ModelCell>
    
    enum Section {
        case main
    }
    
    private lazy var dataSource = makeDataSource()
    
    // MARK: - Variables & Initializers
    
    private var travel: [ModelCell]
    private var config: Configuration
    
    private var travelId: [UUID] = []
    
    struct Configuration {
        let showAddButtons: Bool
        
        static let `default` = Configuration(showAddButtons: true)
    }
    
    init(travelling: [ModelCell], config: Configuration = .default) {
        self.travel = travelling
        self.config = config
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Пора в путешествие"
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.collectionViewLayout = makeLayout()
        applySnapshot(animatingDifferences: false)
    }
    
    func toggleStatus(for travel: ModelCell) -> Bool {
        if let index = travelId.firstIndex(of: travel.id) {
            travelId.remove(at: index)
        } else {
            travelId.append(travel.id)
        }
        
        return addToFavorites(travel: travel)
    }
    
    func addToFavorites(travel: ModelCell) -> Bool {
        return travelId.contains(travel.id)
    }
}

// MARK: - DataSource Implementation

extension MainController {
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = CollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(travel)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> CollectionDataSource {
        collectionView.register(
            CollectionCell.self,
            forCellWithReuseIdentifier: CollectionCell.reuseIdentifier
        )
        
        return CollectionDataSource(collectionView: collectionView) { collectionView, indexPath, travel in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CollectionCell
            
            cell?.travel = travel
            cell?.showAddButton = self.config.showAddButtons
            cell?.isBookInCart = self.addToFavorites(travel: travel)
            
            cell?.didTapCartButton = {
                return self.toggleStatus(for: travel)
            }
            
            return cell
        }
    }
}

// MARK: - Layout Implementation

extension MainController {
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(160)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}
