//
//  RegistUserInfoViewController.swift
//  Monggong
//
//  Created by 시혁 on 2023/09/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Then
import SnapKit

class RegistUserInfoViewController: UIViewController {
    var disposeBag: DisposeBag = DisposeBag()
    var RegistVM: RegistInfoViewModel
    
    init(RegistInfoViewModel: RegistInfoViewModel = RegistInfoViewModel()){
        self.RegistVM = RegistInfoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.RegistVM = RegistInfoViewModel()
        super.init(coder: coder)
    }
    //TODO: - 유저 이름 랜덤설정 버튼
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let randomNameBtnTrigger: Observable<Void> = self.randomNameBtn.rx.tap.asObservable()
        let input = RegistInfoViewModel.Input(RandomNameBtnTriger: randomNameBtnTrigger)
        let output = self.RegistVM.transform(input: input)
        
        output.randomName.subscribe { name in
            self.writedNameLabel.text = name
        }.disposed(by: disposeBag)
    }
    //MARK: -
    func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(randomNameBtn)
        self.view.addSubview(nameStackView)

        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(writedNameLabel)
        
        randomNameBtn.snp.makeConstraints { make in
            make.height.equalTo(75)
            make.top.equalToSuperview().offset(100)
            make.leading.centerX.equalToSuperview().inset(150)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.top.equalTo(randomNameBtn.snp.bottom).offset(20)
            make.leading.centerX.equalToSuperview().offset(20)
        }
        
    }
    //MARK: -
    lazy var randomNameBtn: UIButton = UIButton(type: .custom).then {
        $0.titleLabel?.numberOfLines = 2
        $0.setTitle("랜덤으로 \n이름 변경", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 1
        
        $0.layer.borderColor = UIColor(named: "BoderColor")?.cgColor
        $0.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
        
        $0.setTitleColor(.lightGray, for: .highlighted)
    }
    lazy var nameStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 1
    }
    lazy var nameLabel: UILabel = UILabel().then {
        $0.text = "이름:"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    lazy var writedNameLabel: UILabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "히히히"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
}
