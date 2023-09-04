//
//  RegistInfoViewModel.swift
//  Monggong
//
//  Created by 시혁 on 2023/09/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import RxFlow
protocol RegistInfoModelTypeProtocol {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
class RegistInfoViewModel: RegistInfoModelTypeProtocol, Stepper {
    var steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    let name: PublishRelay<String> = PublishRelay()
    struct Input {
        var RandomNameBtnTriger: Observable<Void>
    }
    struct Output {
        var randomName: Observable<String>
    }
   
    //MARK: -
    func transform(input: Input) -> Output {
        //버튼 트리거 되면 유저 네임 돌려서 값 전달 ✅
        //확인 버튼 유저 이름 1글자 이상 활성화
        //화인 누루면 유저 정보 파이어베이스 업로드 후 화면 이동
        
        let pickUpName : Observable<String> = self.name
            .asObservable()
        input.RandomNameBtnTriger
            .flatMap { _ in
                return Observable.create { observer in
                    Util.shared.getRandomName { response in
                        guard let res = response else {
                            observer.onNext("")
                            observer.onCompleted()
                            return
                        }
                        observer.onNext(res)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
            .bind(onNext: self.name.accept(_:))
            .disposed(by: disposeBag)
        
        
        return Output(randomName: pickUpName)
    }
}
