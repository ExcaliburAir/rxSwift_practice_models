//
//  AlamofireNet.swift
//  RxSwiftPractice
//
//  Created by 张桀硕 on 2023/08/06.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class AlamofireNet {
    /*
     （https://jsonplaceholder.typicode.com/）
      这是一个提供测试数据的公开API。
      我们将实现GET和POST请求，处理异常情况，并给出调用方法的示例
     */
    private let baseURL = "https://jsonplaceholder.typicode.com"

    // get 方法示例
    func getRequest<T: Decodable>(
        path: String,
        parameters: Parameters? = nil) -> Single<T>
    {
        // single
        return Single<T>.create { single in
            let request = AF
                // 发送
                .request(self.baseURL + path, parameters: parameters)
                // 状态
                .validate(statusCode: 200..<300)
                // 解析
                .responseDecodable(of: T.self) { response in
                    // 结果
                    switch response.result {
                    // 成功
                    case .success(let value):
                        single(.success(value))
                    // 失败
                    case .failure(let error):
                        single(.failure(APIError.serverError(error)))
                    }
                }
            // 因为返回的是 Observable 必然要回收内存
            return Disposables.create {
                request.cancel()
            }
        }
    }

    // post 方法示例
    func postRequest<T: Decodable>(
        path: String,
        parameters: Parameters? = nil) -> Single<T>
    {
        // sigle
        return Single<T>.create { single in
            let request = AF
                // 发送
                .request(self.baseURL + path,
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                // 状态
                .validate(statusCode: 200..<300)
                // 解析
                .responseDecodable(of: T.self) { response in
                    // 结果
                    switch response.result {
                    // 成功
                    case .success(let value):
                        single(.success(value))
                    // 失败
                    case .failure(let error):
                        single(.failure(APIError.serverError(error)))
                    }
                }
            // 回收
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
