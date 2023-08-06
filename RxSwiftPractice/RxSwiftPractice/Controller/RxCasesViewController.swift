//
//  RxCasesViewController.swift
//  RxSwiftPractice
//
//  Created by 张桀硕 on 2023/08/06.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

// 场景：错误处理
enum CustomError: Error {
    case someError
}

class RxCasesViewController: UIViewController {
    
    fileprivate lazy var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - 场景：错误处理
        
        performAsyncTask()
            .subscribe(onSuccess: { value in
                print("Success: \(value)")
            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: bag)
        
    }
    
}

extension RxCasesViewController {
    
    // 场景：错误处理
    func performAsyncTask() -> Single<String> {
        
        return Single.create { single in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Simulate an error
                single(.failure(CustomError.someError))
            }
            return Disposables.create()
        }
    }
}
