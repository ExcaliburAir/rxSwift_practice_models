//
//  NetworkDataModel.swift
//  RxSwiftPractice
//
//  Created by 张桀硕 on 2023/08/06.
//

import Foundation

struct NetDataModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
