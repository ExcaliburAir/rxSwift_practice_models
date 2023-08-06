//
//  StudentModel.swift
//  RxSwiftPractice
//
//  Created by 竹影 on 2023/08/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct StudentModel {
    // 创建时是可监听
    var score: BehaviorRelay<Double>
    // 默认值
    var clas = BehaviorRelay(value: "class 1")
}
