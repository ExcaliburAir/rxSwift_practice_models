//
//  RxObservableViewController.swift
//  RxSwiftPractice
//
//  Created by 竹影 on 2023/08/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RxObservableViewController: UIViewController {
    
    fileprivate lazy var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建一个 never 的 obserable
        let neverOb = Observable<String>.never()
        neverOb
            .subscribe { (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        
        // 创建一个 empty 的 obserable
        let emptyOb = Observable<String>.empty()
        emptyOb
            .subscribe { (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        
        // 创建一个 just 的 obserable
        let justOb = Observable.just("just")
        justOb
            .subscribe { (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        
        // 创建一个 of 的 obserable
        let ofOb = Observable.of("a", "b", "c")
        ofOb
            .subscribe { (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        
        // 创建一个 from 的 obserable
        let array = [1, 2, 3, 4, 5]
        let fromOb = Observable.from(array)
        fromOb
            .subscribe { (event: Event<Int>) in
                print(event)
            }.disposed(by: bag)
        
        // 创建一个 create 的 obserable
        let createOb = createObserable()
        createOb
            .subscribe{ (event: Event<Any>) in
                print(event)
            }.disposed(by: bag)
        
        // 调用自己创建的 just 方法
        let myJustOb = myJuseObserable(element: "my just")
        myJustOb
            .subscribe{ (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
        
        // 创建一个 range 的 obserable
        let rangeOb = Observable.range(start: 1, count: 6)
        rangeOb
            .subscribe{ (event: Event<Int>) in
                print(event)
            }.disposed(by: bag)
        
        // 创建一个 repeat 的 obserable
        let repeatOb = Observable.repeatElement("Hello RxSwift")
        repeatOb
            .take(3)
            .subscribe{ (event: Event<String>) in
                print(event)
            }.disposed(by: bag)
    }
}

extension RxObservableViewController {
    
    // 在 create 中，自定义 onNext ，并且必须完成 onCompleted 和 disposable
    func createObserable() -> Observable<Any> {
        // 演示自定义 create
        return Observable.create({ (observer: AnyObserver<Any>) ->
            Disposable in
            observer.onNext("create 1")
            observer.onNext("create 2")
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func myJuseObserable(element: String) -> Observable<String> {
        // 用 create 方法自定义 just
        return Observable.create({ (observer: AnyObserver<String>) ->
            Disposable in
            observer.onNext(element)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    
    
}
