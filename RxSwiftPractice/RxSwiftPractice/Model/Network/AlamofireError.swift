//
//  AlamofireError.swift
//  RxSwiftPractice
//
//  Created by 张桀硕 on 2023/08/06.
//

import Foundation

extension AlamofireNet {
    // 网络请求，错误类型
    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case serverError(Error)
    }
}
