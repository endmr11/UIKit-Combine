//
//  HomeViewModel.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 1.04.2023.
//

import Foundation
import Combine

private extension HomeViewModel {
    enum Constant {
        static let cellHeight: Double = 70
    }
}

protocol IHomeViewModel {
    var numberOfRowsInSection: Int { get }
    var heightForRowAt: Double { get }
    func viewDidLoad()
    func didSelectRowAt(index: Int)
    func getAllColors()
    func setupSearchBinding()
    var colorList: CurrentValueSubject<[ColorModel],APIError> { get }
    var searchText: CurrentValueSubject<String, Never> { get }
    var errorText: PassthroughSubject<String, Never> { get }
}

final class HomeViewModel{
    private weak var view: IHomeView?
    private let apiManager: IAPIManager
    var colorList = CurrentValueSubject<[ColorModel], APIError>([ColorModel]())
    var searchText = CurrentValueSubject<String, Never>("")
    var errorText = PassthroughSubject<String,Never>()
    var subsciptions = Set<AnyCancellable>()
    init(view: IHomeView? = nil,storeManager: IAPIManager = APIManager.shared) {
        self.view = view
        self.apiManager = storeManager
    }
}
extension HomeViewModel: IHomeViewModel {
    
    func viewDidLoad() {
        view?.setUpNavigationBar()
        view?.setUpUI()
        view?.setUpBinding()
        getAllColors()
        setupSearchBinding()
    }
    
    
    var numberOfRowsInSection: Int {
        return colorList.value.count
    }
    
    var heightForRowAt: Double {
        Constant.cellHeight
    }
    
    func didSelectRowAt(index: Int) {
        ThemeManager.shared.themeColor.send(colorList.value[index].color)
    }
    
    func getAllColors() {
        self.view?.showLoading()
        apiManager.get(endpoint: .unknown(querys: ""))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let e):
                    self.errorText.send(e.localizedDescription)
                    break
                }
            } receiveValue: { (val:Result<BaseResult<ColorModel>,APIError>) in
                switch val {
                case .success(let success):
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(1000), execute: { [weak self] in
                        self?.view?.closeLoading()
                        self?.colorList.send(success.data!)
                    })
                    
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(1000), execute: { [weak self] in
                        self?.view?.closeLoading()
                        self?.errorText.send(error.localizedDescription)
                    })
                }
            }.store(in: &subsciptions)
    }
    
    func setupSearchBinding() {
        searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .filter({ val in
                !val.isEmpty && !(val.hasPrefix(" ") || val.hasSuffix(" ") )
            })
            .map{ [unowned self] (searchText) -> AnyPublisher<Result<WithoutBaseResult<ColorModel>,APIError>, Never> in
                self.view?.showLoading()
                return self.apiManager.get(endpoint: .unknown(querys: searchText)).eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { completion in
            } receiveValue: { (val:Result<WithoutBaseResult<ColorModel>,APIError>) in
                switch val {
                case .success(let success):
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(1000), execute: { [weak self] in
                        self?.view?.closeLoading()
                        self?.colorList.send([success.data!])
                    })
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(1000), execute: { [weak self] in
                        self?.view?.closeLoading()
                        self?.errorText.send(error.localizedDescription)
                    })
                }
            }.store(in: &subsciptions)
    }
}
