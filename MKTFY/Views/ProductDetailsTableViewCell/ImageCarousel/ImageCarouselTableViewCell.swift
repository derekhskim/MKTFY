//
//  ImageCarouselTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-10.
//

import UIKit

class ImageCarouselTableViewCell: UITableViewCell {
    
    private var imageCollectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var pageControlContainer: UIView!

    var listingResponse: ListingResponse? {
        didSet {
            updateImageURLs()
        }
    }

    var imageURLs: [String] = [] {
        didSet {
            if imageURLs.isEmpty {
                imageURLs = [""]
            }
            pageControl.numberOfPages = imageURLs.count
            imageCollectionView.reloadData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: frame.width, height: 375)
        layout?.invalidateLayout()
    }

    private func setupSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        imageCollectionView.backgroundColor = .clear

        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = UIColor.appColor(LPColor.SubtleGray)
        pageControl.currentPageIndicatorTintColor = UIColor.appColor(LPColor.GrayButtonGray)

        pageControlContainer = UIView()
        pageControlContainer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageCollectionView)
        contentView.addSubview(pageControlContainer)
        pageControlContainer.addSubview(pageControl)

        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 375),

            pageControlContainer.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            pageControlContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageControlContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageControlContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            pageControl.centerXAnchor.constraint(equalTo: pageControlContainer.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: pageControlContainer.centerYAnchor)
        ])
    }

    private func updateImageURLs() {
        imageURLs = listingResponse?.images ?? []
    }
}

extension ImageCarouselTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let imageURLString = imageURLs[indexPath.item]
        let imageURL = imageURLString.isEmpty ? nil : URL(string: imageURLString)

        cell.imageView.image = nil
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.loadImage(from: imageURL)

        return cell
    }
}

extension ImageCarouselTableViewCell: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / contentView.bounds.width)
        pageControl.currentPage = pageIndex
    }
}
