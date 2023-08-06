//
//  CellDataModel.swift
//  RxSwiftPractice
//
//  Created by 竹影 on 2023/08/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CellDataModel {
    
    // 实装数据，这里是模拟实装
    var cellsDataOb: BehaviorRelay<[CellModel]> = {
        var dataList: [CellModel] = []
        // 样板 cell
        let modelCell = CellModel(
            imageName: "square.and.arrow.up",
            title: "Title",
            subTitle: "Subtitle")
        
        // 这里用 for 更好更简洁
        // 刚学的 Rx 不想试试么
        Observable.repeatElement(modelCell)
            .take(35) // 重复你的敏感数
            .subscribe{ (event: Event<CellModel>) in
                if let element = event.element {
                    dataList.append(element)
                }
            }
            .dispose()
        
        return BehaviorRelay(value: dataList)
    } ()
}
