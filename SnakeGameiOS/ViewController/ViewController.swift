//
//  ViewController.swift
//  SnakeGameiOS
//
//  Created by Shan OvO on 2021/5/29.
//

import UIKit

class ViewController: UIViewController {

    private var startButton: UIButton!
    private var buttonView: UIView!
    private var gestureView: UIView!
    private var collectionView: UICollectionView!
    private var horizontalNodeCount: Int?
    private var verticalNodeCount: Int?
    
    private let cellReuseIdentifier = "BoardCollectionViewCell"
    private let gridWidth: Int = 30
    private var viewModel: SnakeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupGestureView()
        setupButtonView()
        setupViewModel()
    }

    deinit {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        verticalNodeCount = Int(collectionView.frame.height) / gridWidth
        horizontalNodeCount = Int(collectionView.frame.width) / gridWidth
    }
    
    private func setupViewModel() {
        viewModel = SnakeViewModel()
        viewModel?.delegate = self
    }
    
    private func setupButtonView() {
        buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        let centerXAnchor = buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centerYanchor = buttonView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthAnchor = buttonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        let heightAnchor = buttonView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        
        startButton = UIButton()
        startButton.backgroundColor = .black
        startButton.contentHorizontalAlignment = .center
        startButton.contentVerticalAlignment = .center
        startButton.addTarget(self, action: #selector(startAction(_:)), for: .touchUpInside)
        startButton.setTitle("Tap to start!", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(startButton)
        let startButtonCenterXAnchor = startButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor)
        let startButtonCenterYanchor = startButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        let startButtonWidthAnchor = startButton.widthAnchor.constraint(equalTo: buttonView.widthAnchor, multiplier: 0.8)
        let startButtonHeightAnchor = startButton.heightAnchor.constraint(equalTo: buttonView.heightAnchor, multiplier: 0.6)
        
        NSLayoutConstraint.activate([centerXAnchor, centerYanchor, widthAnchor, heightAnchor, startButtonCenterXAnchor, startButtonCenterYanchor, startButtonWidthAnchor, startButtonHeightAnchor])
    }
    
    private func updateStartButtonState(enable: Bool) {
        buttonView.isHidden = !enable
        startButton.setTitle("Game Over! \nTap to retry", for: .normal)
        startButton.titleLabel?.numberOfLines = 2
        startButton.titleLabel?.lineBreakMode = .byCharWrapping
        view.layoutIfNeeded()
    }
    
    private func setupGestureView() {
        gestureView = UIView()
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        gestureView.layer.opacity = 0.1
        view.addSubview(gestureView)
        let leadingAnchor = gestureView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingAnchor = gestureView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let bottomAnchor = gestureView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let topAnchor = gestureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([leadingAnchor, trailingAnchor, bottomAnchor, topAnchor])
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeLeftRecognizer.direction = .left
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeUpRecognizer.direction = .up
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeDownRecognizer.direction = .down
        gestureView.addGestureRecognizer(swipeRightRecognizer)
        gestureView.addGestureRecognizer(swipeLeftRecognizer)
        gestureView.addGestureRecognizer(swipeUpRecognizer)
        gestureView.addGestureRecognizer(swipeDownRecognizer)
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.estimatedItemSize = CGSize(width: gridWidth, height: gridWidth)
        layout.itemSize = CGSize(width: gridWidth, height: gridWidth)
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.isUserInteractionEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        let leadingAnchor = collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let trailingAnchor = collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let topAnchor = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([leadingAnchor, trailingAnchor, bottomAnchor, topAnchor])
    }
    
    @objc
    private func swipeAction(_ sender: UISwipeGestureRecognizer) {
        guard let direction = sender.direction.getDirection() else { return }
        viewModel?.updateSnakeMovingDirection(direction)
    }
    
    @objc
    private func startAction(_ sender: UIButton) {
        updateStartButtonState(enable: false)
        viewModel?.startGame(mapSize: (horizontalNodeCount!, verticalNodeCount!))
    }
    
    private func mapGridColor(at position: NodePosition) -> UIColor {
        return position.0.isMultiple(of: 2) ? .lightGray : .darkGray
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(collectionView.frame.height) / gridWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(collectionView.frame.width) / gridWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        let isOccupied = viewModel?.isSnakeOccupied(at: indexPath.position) ?? false
        let isCoin = viewModel?.isCoin(at: indexPath.position) ?? false
        cell.backgroundColor = isOccupied ? .green : (isCoin ? .orange : mapGridColor(at: indexPath.position))
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("(\(indexPath.section), \(indexPath.item))")
    }
}

// MARK: - SnakeViewModelDelegate
extension ViewController: SnakeViewModelDelegate {
    func mapSize() -> (Int, Int) {
        return (horizontalNodeCount ?? 0, verticalNodeCount ?? 0)
    }
    
    func gameDidUpdate() {
        collectionView.reloadData()
    }
    
    func gameDidEnd() {
        updateStartButtonState(enable: true)
    }
}
