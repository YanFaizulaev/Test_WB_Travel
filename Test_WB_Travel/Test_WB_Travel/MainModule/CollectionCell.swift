//
//  CollectionCell.swift
//  Test_WB_Travel
//
//  Created by Bandit on 04.08.2023.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    private lazy var imageTravelView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var departureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var departureCityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var departureDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var modeOfTravelView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var arrivalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var arrivalCityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var returnDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var addToFavoritesButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.image = UIImage(systemName: "hand.thumbsup")
        
        let button = UIButton(type: .system)
        button.configuration = config
        button.tintColor = .systemRed
        
        button.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            let symbolName = self.isBookInCart ? "hand.thumbsup.fill" : "hand.thumbsup"
            config?.image = UIImage(systemName: symbolName)
            button.configuration = config
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(
            UIAction { _ in
                if let inCart = self.didTapCartButton?() {
                    self.isBookInCart = inCart
                }
            },
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    public var travel: ModelCell? {
        didSet {
            guard let travel = travel else { return }
            imageTravelView.image = UIImage(named: travel.imageTravel)
            departureCityLabel.text = travel.departureCity
            departureDateLabel.text = travel.departureDate
            modeOfTravelView.image = UIImage(systemName: travel.modeOfTravel)
            arrivalCityLabel.text = travel.arrivalCity
            returnDateLabel.text = travel.returnDate
            priceLabel.text = travel.price
            
            addToFavoritesButton.isEnabled = travel.available
        }
    }
    
    public var showAddButton = true {
        didSet {
            addToFavoritesButton.isHidden = !showAddButton
        }
    }
    
    public var isBookInCart = false {
        didSet {
            addToFavoritesButton.setNeedsUpdateConfiguration()
        }
    }
    public var didTapCartButton: (() -> Bool)?
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageTravelView)
        contentView.addSubview(departureStackView)
        
        departureStackView.addArrangedSubview(departureCityLabel)
        departureStackView.addArrangedSubview(departureDateLabel)
        
        contentView.addSubview(modeOfTravelView)
        contentView.addSubview(arrivalStackView)
        
        arrivalStackView.addArrangedSubview(arrivalCityLabel)
        arrivalStackView.addArrangedSubview(returnDateLabel)
        
        contentView.addSubview(priceStackView)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(addToFavoritesButton)
        
        contentView.addSubview(separatorView)
        
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWidthRatio: CGFloat = traitCollection.userInterfaceIdiom == .pad ? 1 / 8 : 1 / 4
        
        NSLayoutConstraint.activate([
            imageTravelView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            imageTravelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageTravelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imageTravelView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: imageWidthRatio),
            
            departureStackView.leadingAnchor.constraint(equalTo: imageTravelView.trailingAnchor, constant: 10),
            departureStackView.centerYAnchor.constraint(equalTo: imageTravelView.centerYAnchor),
            departureStackView.trailingAnchor.constraint(equalTo: modeOfTravelView.leadingAnchor, constant: -10),
            
            modeOfTravelView.leadingAnchor.constraint(equalTo: departureStackView.trailingAnchor, constant: 10),
            modeOfTravelView.centerYAnchor.constraint(equalTo: departureStackView.centerYAnchor),
            modeOfTravelView.trailingAnchor.constraint(equalTo: arrivalStackView.leadingAnchor, constant: -10),
            
            arrivalStackView.leadingAnchor.constraint(equalTo: modeOfTravelView.trailingAnchor, constant: 10),
            arrivalStackView.centerYAnchor.constraint(equalTo: modeOfTravelView.centerYAnchor),
            arrivalStackView.trailingAnchor.constraint(equalTo: priceStackView.leadingAnchor, constant: -10),
            
            priceStackView.leadingAnchor.constraint(equalTo: arrivalStackView.trailingAnchor, constant: 10),
            priceStackView.centerYAnchor.constraint(equalTo: departureStackView.centerYAnchor),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
