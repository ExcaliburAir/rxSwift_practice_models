//
//  RxFunctorViewController.swift
//  RxSwiftPractice
//
//  Created by 竹影 on 2023/08/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RxFunctorViewController: UIViewController {
    
    fileprivate lazy var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - map
        
        // map
        let array = [1, 2, 3, 4]
        let _ = array.map({ $0 * $0 })
        Observable.of(1, 2, 3, 4)
            .map { $0 * $0 }
            .subscribe { (event: Event<Int>) in
                print(event)
            }
            .disposed(by: bag)
        
        // MARK: - flatMap
        
        // flatMap
        let student1 = StudentModel(score: BehaviorRelay(value: 180))
        let student2 = StudentModel(score: BehaviorRelay(value: 290))
        let student3 = StudentModel(score: BehaviorRelay(value: 3100))
        
        // 监听 student1
        let stuVariable = BehaviorRelay(value: student1)
        // 监听分数
        stuVariable
            // 订阅过的即使更改，会一直订阅
//            .flatMap { (student: Student) -> BehaviorRelay<Double> in
//                return student.score
//            }
            // 只更改订阅最后一个的
            .flatMapLatest { (student: StudentModel) -> BehaviorRelay<Double> in
                return student.score
            }
            .subscribe { (event: Event<Double>) in
                print(event)
            }
            .disposed(by: bag)
        // 对 student1 的分数更改，看是否能被监听到
        student1.score
            .accept(160)
        
        // 当然 student 的 score 自身就有监听机制
        student2.score
            .subscribe { (event: Event<Double>) in
                print(event)
            }
            .disposed(by: bag)
        // 只改分数，查看监听状态
        student2.score
            .accept(270)
            
        // 更改监听对象看是否变换监听
        stuVariable.accept(student3)
        
    }
    
}
