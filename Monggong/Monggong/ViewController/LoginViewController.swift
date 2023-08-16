//
//  LoginViewController.swift
//  Monggong
//
//  Created by 시혁 on 2023/08/14.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Then
import SnapKit

class LoginViewController: UIViewController {
    var disposeBag: DisposeBag = DisposeBag()
    var loginVM: LoginViewModel
    
    init(loginViewMoel: LoginViewModel = LoginViewModel()){
        self.loginVM = loginViewMoel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.loginVM = LoginViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        
        let googleBtnTrigger: Observable<Void> = self.googleLoginBtn.rx.tap.asObservable()
        let input = LoginViewModel.Input(googleLoginBtnTriger: googleBtnTrigger)
    }
    
    func configureUI() {
        self.view.addSubview(loginBtnStack)
        self.loginBtnStack.addArrangedSubview(googleLoginBtn)
        loginBtnStack.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(100)
            make.left.equalTo(self.view.snp.left).offset(85)
            make.centerX.equalToSuperview()
        }
        googleLoginBtn.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    // 로고 예정
    
    lazy var loginBtnStack: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    lazy var googleLoginBtn: UIButton = UIButton(type: .custom).then {
        guard let image = UIImage(named: "GoogleLogo") else {
            // 이미지 로드에 실패한 경우에 대한 처리
            return
        }
        $0.setImage(image, for: .normal)
        $0.setTitle("Sign in with Google", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.setTitleColor(UIColor(named: "GoogleFontColor"), for: .normal)
        
        $0.adjustsImageWhenHighlighted = false // 이미지 반전 제거
        $0.backgroundColor = UIColor(named: "GoogleLoginBGColor")
        
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor(named: "BoderColor")?.cgColor
        
        $0.imageView?.contentMode = .scaleAspectFit
        $0.layer.borderColor = UIColor(named: "BoderColor")?.cgColor
        $0.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
    }
}
