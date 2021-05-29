//
//  ViewController.swift
//  SnakeGameiOS
//
//  Created by Shan OvO on 2021/5/29.
//

import UIKit

class ViewController: UIViewController {

    private var gestureView: UIView!
    private var collectionView: UICollectionView!
    private var horizontalNodeCount: Int?
    private var verticalNodeCount: Int?
    
    private let cellReuseIdentifier = "BoardCollectionViewCell"
    private let nodeWidth: Int = 30
    
    private var nodes: [NodePosition] = []
    private var coin: NodePosition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupGestureView()
        SnakeManager.shared.delegate = self
    }

    deinit {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        verticalNodeCount = Int(collectionView.frame.height) / nodeWidth
        horizontalNodeCount = Int(collectionView.frame.width) / nodeWidth
        
        SnakeManager.shared.startGame(mapSize: (verticalNodeCount!, horizontalNodeCount!))
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
        layout.estimatedItemSize = CGSize(width: nodeWidth, height: nodeWidth)
        layout.itemSize = CGSize(width: nodeWidth, height: nodeWidth)
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
        switch sender.direction {
        case .up:
            SnakeManager.shared.updateSnakeDirection(direction: .down)
        case .down:
            SnakeManager.shared.updateSnakeDirection(direction: .up)
        case .left:
            SnakeManager.shared.updateSnakeDirection(direction: .right)
        case .right:            
            SnakeManager.shared.updateSnakeDirection(direction: .left)
        default:
            NSLog("Additional case for swipeAction")
            break
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(collectionView.frame.height) / nodeWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(collectionView.frame.width) / nodeWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        
        let isContained = nodes.contains { (x, y) -> Bool in
            return indexPath.section == x && indexPath.item == y
        }
        cell.backgroundColor = isContained ? .green : (indexPath.section == coin?.0 && indexPath.item == coin?.1 ? .orange : (indexPath.section.isMultiple(of: 2) ? .lightGray : .darkGray))
        
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("(\(indexPath.section), \(indexPath.item))")
    }
}


extension ViewController: SnakeManagerDelegate {
    func gameDidStart(snake: Snake?, coin: NodePosition) {
        if let snake = snake {
            nodes = snake.nodes
        }
        
        self.coin = coin
        collectionView.reloadData()
    }
    
    func snakeDidUpdate(snake: Snake?) {
        if let snake = snake {
            nodes = snake.nodes
            collectionView.reloadData()
        }
    }
    
    func mapSize() -> (Int, Int) {
        return (verticalNodeCount ?? 0, horizontalNodeCount ?? 0)
    }
    
    func coinDidUpdate(coin: NodePosition) {
        self.coin = coin
        collectionView.reloadData()
    }
}
