//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by 문인범 on 2023/06/22.
//

import UIKit

struct test {
    var first: String?
}

class ListViewController: UITableViewController {
    
    var a = test()

    
    override func viewDidLoad() {
        callMovieAPI()
    }
    
    // 현재까지 읽어온 데이터의 페이지 정보
    var page = 1
    
    @IBOutlet var moreBtn: UIButton!
    @IBAction func more(_ sender: Any){
        
        // 0. 현재 페이지 값에 1을 추가한다.
        self.page += 1
        
        callMovieAPI()
        
        self.tableView.reloadData()
    }
    
    /*
    // 튜플 아이템을 가진 배열로 정의된 데이터 세트
    var dataset = [
        ("다크나이트", "영웅물에 철학에 음악까지 더해져 예술이 되다.", "2008-09-04", 8.95)
    ] as [Any]
    
    var test = Array<(String, String, String, Double, String)>([
        ("다크나이트", "영웅물에 철학에 음악까지 더해져 예술이 되다.", "2008-09-04", 8.95, "darknight.jpg"),
        ("호우시절", "때를 알고 내리는 좋은 비", "2009-10-08", 7.31, "rain.jpg"),
        ("말할 수 없는 비밀", "여기서 너까지 다섯 걸음", "2015-05-07", 9.19, "secret.jpg")
    ])
     */
    
    // 테이블 뷰를 구성할 리스트 데이터
    lazy var list: [MovieVO] = {() -> Array<MovieVO> in
        var datalist = [MovieVO]()
        
        /*
        for a in self.test {
            let mvo = MovieVO()
            mvo.title = a.0
            mvo.description = a.1
            mvo.opendate = a.2
            mvo.rating = a.3
            mvo.thumbnail = a.4
            
            datalist.append(mvo)
        }
         */
        
        return datalist
    }()
    
    // 테이블의 행 개수 결정
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 주어진 행에 맞는 데이터 소스를 읽어온다.
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        // 데이터 소스에 저장된 값을 각 아울렛 변수에 할당
        cell.title.text = row.title
        cell.desc.text = row.description
        cell.opendate.text = row.opendate
        cell.rating.text = "\(row.rating!)"
        
        // 비동기 방식으로 썸네일 이미지를 읽어옴
        DispatchQueue.main.async(execute: {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        })
//        cell.thumbnail.image = row.thumnailImage
        
        // 이미지 뷰 처리
        //cell.thumbnail.image = UIImage(data: try! Data(contentsOf: URL(string: row.thumbnail!)!))
        
        /*
        // 테이블 셀 객체를 직접 생성하는 대신 큐로부터 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
        
        // custom 테이블 뷰
        // 영화제목이 표시될 레이블을 title 변수로 받음
        let title = cell.viewWithTag(101) as? UILabel
        
        // 영화요약이 표시될 레이블을 desc 변수로 받음
        let desc = cell.viewWithTag(102) as? UILabel
        
        // 영화 개봉일이 표시될 레이블을 opendate 변수로 받음
        let opendate = cell.viewWithTag(103) as? UILabel
        
        // 영화 별점이 표시될 레이블을 rating 변수로 받음
        let rating = cell.viewWithTag(104) as? UILabel
        
        // 데이터 소스에 저장된 값을 각 레이블 변수에 할당
        title?.text = row.title
        desc?.text = row.description
        opendate?.text = row.opendate
        rating?.text = "\(row.rating!)"
         */
        
        /*
        cell.textLabel?.text = row.title
        
        // 추가사항 : 서브타이틀에 데이터 연결
        cell.detailTextLabel?.text = row.description
         */
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row) 번째 행입니다.")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    /*
    override func viewDidLoad() {
        
        // 첫번째 행
        var mvo = MovieVO()
        mvo.title = "다크나이트"
        mvo.description = "영웅물에 철학에 음악까지 더해져 예술이 되다."
        mvo.opendate = "2008-09-04"
        mvo.rating = 8.95
        // 배열에 추가
        self.list.append(mvo)
        
        // 두번째 행
        mvo = MovieVO()
        mvo.title = "호우시절"
        mvo.description = "때를 알고 내리는 좋은 비"
        mvo.opendate = "2008-10-08"
        mvo.rating = 7.31
        // 배열에 추가
        self.list.append(mvo)
        
        // 세번째 행
        mvo = MovieVO()
        mvo.title = "말할 수 없는 비밀"
        mvo.description = "여기서 너까지 다섯 걸음"
        mvo.opendate = "2015-05-07"
        mvo.rating = 9.19
        // 배열에 추가
        self.list.append(mvo)
        
    }
     */
    
    // 영화 차트 API 호출 메소드
    func callMovieAPI(){
        // 1. 호핀 API 호출을 위한 URI를 생성
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        
        // 2. REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        // 3. 데이터 전송 결과를 로그로 출력 (반드시 필요한 코드는 아님)
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? "데이터가 없습니다"
        NSLog("API Result = \(log)")
        
        // 4. JSON 객체를 파싱하여 NSDictionary 객체로 변환
        do{
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata) as! NSDictionary
            
            // 5. 데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            // 6. Iterator 처리를 하면서 API 데이터를 MovieVO 객체에 저장한다.
            for row in movie {
                // 순회 상수를 NSDictionary 타입으로 캐스팅
                let r = row as! NSDictionary
                
                // 테이블 뷰 리스트를 구성할 데이터 형식
                let mvo = MovieVO()
                
                // movie 배열의 각 데이터를 mvo 상수의 속성에 대입
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = (r["ratingAverage"] as! NSString).doubleValue
                
                let url: URL! = URL(string: mvo.thumbnail!)
                let imageData = try! Data(contentsOf: url)
                mvo.thumnailImage = UIImage(data: imageData)
                
                
                
                self.list.append(mvo)
                
            }
            
            // 7. 전체 데이터 카운트를 얻는다.
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            
            // 8. totalCount가 읽어온 데이터 크기와 같거나 클 경우 더보기 버튼을 막는다.
            if self.list.count >= totalCount {
                self.moreBtn.isHidden = true
            }
        } catch{ NSLog("에러남 ㅋㅋ")}
    }
    
    func getThumbnailImage(_ index: Int) -> UIImage {
        // 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
        let mvo = self.list[index]
        
        // 메모이제이션 : 저장된 이미지가 있으면 그것을 반환하고, 없을 경우 내려받아 저장한 후 반환
        if let savedImage = mvo.thumnailImage {
            return savedImage
        } else {
            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumnailImage = UIImage(data: imageData) // UIImage를 MovieVO 객체에 우선 저장
            
            return mvo.thumnailImage!
        }
    }
    
}

// MARK: - 화면 전환 시 값을 넘겨주기 위한 세그웨이 관련 처리
extension ListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 실행된 세그웨이의 식별자가 "segue_detail"이라면
        if segue.identifier == "segue_detail" {
            // 사용자가 클릭한 행을 찾아간다.
            let path = self.tableView.indexPath(for: sender as! MovieCell)
            
            // 행 정보를 통해 선택된 영화 데이터를 찾은 다음, 목적지 뷰 컨트롤러의 mvo 변수에 대입한다.
            let detailVC = segue.destination as? DetailViewController
            detailVC?.mvo = self.list[path!.row]
        }
    }
}
