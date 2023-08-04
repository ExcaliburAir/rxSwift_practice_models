//
//  RxSubjectViewController.swift
//  RxSwiftPractice
//
//  Created by 竹影 on 2023/08/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RxSubjectViewController: UIViewController {
    
    fileprivate lazy var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 订阅者既能订阅，又能发送
        
        // PublishSubject 订阅者只能接受，订阅之后发出的事件
        let publishSub = PublishSubject<String>()
        // 订阅前发送
        publishSub.onNext("Send Publish Subject Before")
        // 订阅
        publishSub
            .subscribe { (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        // 发出事件，订阅才能接收
        publishSub.onNext("Send Publish Subject After")
        
        // replaySubject 订阅者可以接收订阅之前，和之后的事件
        let replaySub = ReplaySubject<String>
            .create(bufferSize: 2)
            //.createUnbound() // 无限制
        // 订阅之前发送，影响 bufferSize
        replaySub.onNext("repaly subject 1 before")
        replaySub.onNext("repaly subject 2 before")
        replaySub.onNext("repaly subject 3 before")
        // 订阅
        replaySub
            .subscribe { (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        // 订阅之后发送，不影响 bufferSize
        replaySub.onNext("repaly subject 4 after")
        replaySub.onNext("repaly subject 5 after")
        replaySub.onNext("repaly subject 6 after")
        
        // behaviorSubject 订阅者可以接收订阅之前最后一个事件
        let behaviorSub = BehaviorSubject(value: "behevior subject 0 before")
        // 订阅之前，只有最后一个被接收
        behaviorSub.onNext("behevior subject 1 before")
        behaviorSub.onNext("behevior subject 2 before")
        // 订阅
        behaviorSub
            .subscribe { (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        // 订阅之后，全部接收
        behaviorSub.onNext("behevior subject 3 after")
        behaviorSub.onNext("behevior subject 4 after")
        
        // BehaviorRelay
        // Variable 是 BehaviorSubject 的一个包装，需要 asObserable 转 obserable
        // 发出事件时，直接修改 value 即可
        // 已经被弃用，还是用 BehaviorRelay
        let variable = BehaviorRelay(value: "BehaviorRelay subject 0 before")
        // 订阅
        variable
            .subscribe { (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        // 修改值
        variable.accept("BehaviorRelay subject 1 before")
    }
    
}
