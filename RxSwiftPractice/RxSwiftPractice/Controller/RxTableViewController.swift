//
//  RxTableViewController.swift
//  RxSwiftPractice
//
//  Created by 竹影 on 2023/08/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RxTableViewController: UIViewController {
    
    fileprivate lazy var bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // 创建整体数据
        let cellsDataModel = CellDataModel()
        
        // 绑定数据到 tableView
        cellsDataModel.cellsDataOb
            .bind(to: tableView.rx
                .items(cellIdentifier: "RxTableViewCell")) {
                    row, model, cell in
                    cell.imageView?.image = UIImage(systemName: model.imageName)
                    cell.textLabel?.text = model.title + String(row)
                    cell.detailTextLabel?.text = model.subTitle + String(row)
            }
            .disposed(by: bag)
        
        // 响应 tableView itemSelected 动作
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                print(indexPath)
                // 取消选中状态，避免循环引用
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
        
        // 获得 tableView modelSelected 时候的数据
        tableView.rx.modelSelected(CellModel.self)
            .subscribe(onNext: { (cellData: CellModel) in
                // 对该行的数据做点什么
                print(cellData)
            })
            .disposed(by: bag)
        
        // 更改数据 1
        button1.rx.tap
            .subscribe { (event: Event<()>) in
                // 待修改数据模版
                var cellModelList: [CellModel] = []
                
                // 用 flatMapLatest 修改每个 cell 的数据
                // for 应该更简洁，这里反而感觉臃肿
                // 链式传递，重要的是节点上下环节的类型对接
                Observable
                    // form 里面传入数组，为了分别处理
                    .from(cellsDataModel.cellsDataOb.value)
                    // 复习，传入 CellModel ，传出 BehaviorRelay<CellModel>
                    .flatMapLatest {
                        // BehaviorRelay 应该是最一般应用的，可叠代的形式？
                        (event: CellModel) -> BehaviorRelay<CellModel> in
                        // 修改现有数据
                        return BehaviorRelay(value: CellModel(
                            imageName: event.imageName,
                            title: event.title + "*",
                            subTitle: event.subTitle + "*"
                        ))
                    }
                    .subscribe { (event: Event<CellModel>) in
                        if let element = event.element {
                            cellModelList.append(element)
                        }
                    }
                    .dispose()
                    
                // 真正改值的位置
                cellsDataModel.cellsDataOb
                    .accept(cellModelList)
            }
            .disposed(by: bag)
        
        // 更改数据 2
        button2.rx.tap
            .subscribe { (event: Event<()>) in
                // 清空
                cellsDataModel.cellsDataOb
                    .accept([])
            }
            .disposed(by: bag)
    }
    
}
