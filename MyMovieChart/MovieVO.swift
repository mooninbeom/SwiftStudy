//
//  MovieVO.swift
//  MyMovieChart
//
//  Created by 문인범 on 2023/06/22.
//

import Foundation
import UIKit

class MovieVO {
    var thumbnail: String? // 영화 섬네일 이미지 주소
    var title: String? // 영화 제목
    var description: String? // 영화 설명
    var detail: String? // 상세정보
    var opendate: String? // 개봉일
    var rating: Double? // 평점
    var thumnailImage: UIImage? // 썸네일 이미지
    
    /*
    init(title: String? = nil, description: String? = nil, opendate: String? = nil, rating: Double? = nil) {
        self.title = title
        self.description = description
        self.opendate = opendate
        self.rating = rating
    }
     */
}
