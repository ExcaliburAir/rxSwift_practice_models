//
//  RxNetworkViewController.swift
//  RxSwiftPractice
//
//  Created by 竹影 on 2023/08/06.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RxNetworkViewController: UIViewController {
    
    fileprivate lazy var bag = DisposeBag()
    let networkService = AlamofireNet()
    
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - 单请求封装
        
        getButton.rx.tap
            .subscribe { [weak self] (event: Event<()>) in
                print("-------------- tap button get --------------")
                self?.sendGetRequest()
            }.disposed(by: bag)

        postButton.rx.tap
            .subscribe { [weak self] (event: Event<()>) in
                print("-------------- tap button post --------------")
                self?.sendPostRequest()
            }.disposed(by: bag)
        
        // MARK: - 多请求组合
        
        let getRequestSingle: Single<NetData> = networkService
            .getRequest(path: "/posts/1")
        let postRequestSingle: Single<NetData> = networkService
            .postRequest(path: "/posts", parameters: [
            "userId": 1,
            "title": "New Post",
            "body": "This is a new post created using RxSwift."
        ])
        
        Single
            .zip(getRequestSingle, postRequestSingle)
            .subscribe(onSuccess: { (getResponse, postResponse) in
                // get 部分
                print("GET Request Success:")
                print("UserID: \(getResponse.userId)")
                print("Title: \(getResponse.title)")
                print("Body: \(getResponse.body)")
                // post 部分
                print("POST Request Success:")
                print("New Post ID: \(postResponse.id)")
            }, onFailure: { error in
                print("Error: \(error.localizedDescription)")
            })
            .disposed(by: bag)
    }
    
}

// network 方法
extension RxNetworkViewController {
    
    fileprivate func sendGetRequest() {
        // GET请求示例
        networkService
            // get
            .getRequest(path: "/posts/1")
            // 成功返回
            .subscribe(onSuccess: { (post: NetData) in
                print("GET Request Success:")
                print("UserID: \(post.userId)")
                print("Title: \(post.title)")
                print("Body: \(post.body)")
            // 失败返回
            }, onFailure: { error in
                print("GET Request Error: \(error.localizedDescription)")
            })
            .disposed(by: bag)
    }
    
    fileprivate func sendPostRequest() {
        // POST请求参数
        let newPost: [String: Any] = [
            "userId": 1,
            "title": "New Post",
            "body": "This is a new post created using RxSwift."
        ]
        
        // POST请求示例
        networkService
            // post
            .postRequest(path: "/posts", parameters: newPost)
            // 成功返回
            .subscribe(onSuccess: { (createdPost: NetData) in
                print("POST Request Success:")
                print("New Post ID: \(createdPost.id)")
            // 失败返回
            }, onFailure: { error in
                print("POST Request Error: \(error.localizedDescription)")
            })
            .disposed(by: bag)
    }
    
}
