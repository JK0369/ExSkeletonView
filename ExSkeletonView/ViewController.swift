//
//  ViewController.swift
//  ExSkeletonView
//
//  Created by Jake.K on 2022/01/18.
//

import UIKit
import SnapKit
import SkeletonView
import Then

class ViewController: UIViewController {
  private let tableView = UITableView().then {
    $0.register(MyCell.self, forCellReuseIdentifier: "cell")
    $0.backgroundColor = .black
  }
  private let label = UILabel().then {
    $0.text = "123456577765"
    $0.numberOfLines = 0
    $0.textColor = .white
    $0.isSkeletonable = true
  }
  private var dataSource = [MyData]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .black
    self.view.addSubview(self.tableView)
    self.view.addSubview(self.label)
    
    self.label.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().inset(52)
    }
    self.tableView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(120)
      $0.left.right.bottom.equalToSuperview()
    }
    
    self.tableView.dataSource = self
    
    let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
//    self.label.showSkeleton(usingColor: .gray)
    /// transition: 스켈레톤 보여질때와 사라질때 효과
    self.label.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]), animation: skeletonAnimation, transition: .none)
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.label.hideSkeleton()
    }
//    self.tableView.isSkeletonable = true
//    self.tableView.showSkeleton(usingColor: .gray, transition: .crossDissolve(1))
    
//    self.fetchDataSource()
  }
  
  private func fetchDataSource() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      let datas = (0...30)
        .map {
          MyData(
            image: UIImage(named: "jake"),
            title: "title \($0)",
            description: "description \($0)"
          )
        }
      self.dataSource.append(contentsOf: datas)
      self.tableView.reloadData()
      
      self.tableView.stopSkeletonAnimation()
      self.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1))
    }
  }
}

extension ViewController: SkeletonTableViewDelegate {}
extension ViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "cell"
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
    let data = dataSource[indexPath.row]
    cell.prepare(picture: data.image, title: data.title, description: data.description)
    return cell
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }
}
