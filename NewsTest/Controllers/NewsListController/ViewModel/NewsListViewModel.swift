//
//  NewsListViewModel.swift
//  NewsTest
//
//  Created by Victor on 15/08/2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import SwiftyJSON
import Alamofire

//MARK: -Class define
class NewsListViewModel {
  //MARK: Properties
  private var currentPage: Int = 0
  private var numberOfNews: Int = 5
  private var newsData: NewsData
  private var network: Network
  private var allNews: [MDNews] = []
  private let router: Router
  private var loadingNews: [MDNews] = []
  private var canPreload: Bool = true

  //MARK: Reactive properties
  var alert: Signal<(String , (() -> Void)?), NoError>
  fileprivate var alertObserver: Signal<(String , (() -> Void)?), NoError>.Observer

  fileprivate var _refresh: MutableProperty<Bool> = MutableProperty<Bool>.init(false)
  lazy var refresh: Property<Bool> = Property<Bool>.init(_refresh)

  fileprivate var _loading: MutableProperty<Bool> = MutableProperty<Bool>.init(false)
  lazy var loading: Property<Bool> = Property<Bool>.init(_loading)

  private var _newsDidLoad: Signal<[IndexPath], NoError>
  fileprivate var newsDidLoadObserver: Signal<[IndexPath], NoError>.Observer
  var newsDidLoad: Signal<[IndexPath], NoError> {
    return _newsDidLoad.delay(1.5, on: QueueScheduler.main)
  }

  var reload: Signal<(), NoError>
  fileprivate var reloadObserver: Signal<(), NoError>.Observer

  //MARK: Init
  init(newsData: NewsData = NewsData.shared,
     network: Network = Network.shared,
     router: Router = NewsService.topHeadlines) {
    self.newsData = newsData
    self.network = network
    self.router = router
    (alert, alertObserver) = Signal.pipe()
    (_newsDidLoad, newsDidLoadObserver) = Signal.pipe()
    (reload, reloadObserver) = Signal.pipe()
  }
}

//MARK: -Network
extension NewsListViewModel {
  func preload() {
    getNews()
  }
  
  private func getNews() {
    currentPage = 0
    canPreload = true
    self._refresh.value = true
    network.request(router: router) { [weak self] (response) in
      self?._refresh.value = false
      self?.checkResponse(response)
    }
  }

  private func checkResponse(_ response: DefaultDataResponse) {
    if let error = response.error {
      checkError(error)
      return
    }

    if let data = response.data, let articles = JSON(data)["articles"].array {
      self._refresh.value = false
      self.loadingNews = []
      self.reloadObserver.send(value: ())
      self.allNews = articles.map({ (json) -> MDNews in
        return MDNews(from: json)
      })
      self.preloadNextPage()
    }
  }

  private func checkError(_ error: Error) {
    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
      self.alertObserver.send(value: ("Проверьте подключение к сети", { [weak self] in
        self?.fetchNews()
      }))
    } else {
      self.alertObserver.send(value: (error.localizedDescription, nil))
    }
  }
}

//MARK: -Table Methods
extension NewsListViewModel {
  func cellForRowAtIndexPath(_ indexPath: IndexPath) -> MDNews? {
    guard indexPath.row < self.loadingNews.count else {return nil}
    return self.loadingNews[indexPath.row]
  }
  
  func count() -> Int {
    return self.loadingNews.count
  }
}

//MARK: -View events
extension NewsListViewModel {
  func reloadNews() {
    if refresh.value == false {
      getNews()
    }
  }
  
  func preloadNextPage() {
    if canPreload {
      canPreload = false
      preloadNews(at: currentPage)
      currentPage += 1
    }
  }
  
  func didInsertRows() {
    canPreload = true
    self._loading.value = false
  }
  
  private func preloadNews(at page: Int) {
    self._loading.value = true
    var count: Int
    
    if numberOfNews * (page + 1) > self.allNews.count {
      count = self.allNews.count - numberOfNews * page
    } else {
      count = numberOfNews
    }
    
    if count <= 0 {
      canPreload = false
      self._loading.value = false
      return
    }
    
    let loadedNews = self.allNews[page * count ..< (page+1) * count]
    
    var indexPaths: [IndexPath] = []
    for index in page * numberOfNews ..< (page+1) * numberOfNews {
      let indexPath = IndexPath(row: index, section: 0)
      indexPaths.append(indexPath)
    }
    
    self.loadingNews.append(contentsOf: loadedNews)
    self.newsDidLoadObserver.send(value: indexPaths)
  }
}

//MARK: -Database
extension NewsListViewModel {
  private func saveNews() {
    DispatchQueue.global().async {
      self.newsData.saveNewsList(model: self.allNews, failed: { [weak self] (error) in
        self?.alertObserver.send(value: (error.localizedDescription, nil))
      })
    }
  }
  
  private func fetchNews() {
    do {
      let oldValue = self.loadingNews
      self.loadingNews = try newsData.getNewsList()
      if self.loadingNews.count == 0 {
        alertObserver.send(value: ("Закешированный список новостей отсутствует", nil))
      }
      preloadFetchedNews(oldValue: oldValue)
    } catch {
      alertObserver.send(value: (error.localizedDescription, nil))
    }
  }
  
  private func preloadFetchedNews(oldValue: [MDNews]) {
    var indexPaths: [IndexPath] = []
    for (index,_) in self.loadingNews.enumerated() {
      let indexPath = IndexPath(row: index, section: 0)
      indexPaths.append(indexPath)
    }
    self.reloadObserver.send(value: ())
  }
}
