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
        var nextBtnTrigger: Observable<Void>
    }
    struct Output {
        var randomName: Observable<String>
    }
    init(){
        
        Util.shared.getRandomName { response in
            let randomname = response ?? ""
            self.name.accept(randomname)
        }
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
                return Util.shared.pickUpName()
            }
            .flatMap({ (name: String?) in
                if let name = name {
                    return Observable.just(name)
                }else{
                    return Observable.just("")
                }
            })
            .bind(onNext: self.name.accept(_:))
            .disposed(by: disposeBag)
        
        input.nextBtnTrigger
            .map { _ in
                FirebaseLoginService.shared.write(name: pickUpName)
//                UserDefaults.standard.set(user.id, forKey: "uid")
                return AppStep.mainTabBarIsRequired
            }.bind(to: self.steps)
            .disposed(by: disposeBag)
        
        return Output(randomName: pickUpName)
    }
}
