//
//  File.swift
//  VPOnboardingKit
//
//  Created by Vince P. Nguyen on 2024-12-11.
//

import UIKit
import SnapKit
import Combine

class AnimatedBarView: UIView {
    
    private enum State {
        case clear
        case animating
        case filled
    }
    
    private lazy var foregroundView: UIView = {
        let view = UIView()
        view.backgroundColor = barColor
        view.alpha = 0
        return view
    }()
    
    private lazy var backgroundview: UIView = {
        let view = UIView()
        view.backgroundColor = barColor.withAlphaComponent(0.2)
        view.clipsToBounds = true
        return view
    }()
    
    @Published private var state: State = .clear
    private var subscribers = Set<AnyCancellable>()
    private var animator: UIViewPropertyAnimator!
    private let barColor: UIColor
    private let durationInSeconds: Int
    
    init(
        barColor: UIColor,
        durationInSeconds: Int
    ) {
        self.barColor = barColor
        self.durationInSeconds = durationInSeconds
        super.init(frame: .zero)
        setupAnimator()
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAnimator() {
        animator = UIViewPropertyAnimator(
            duration: Double(durationInSeconds),
            curve: .easeOut,
            animations: {
                self.foregroundView.transform = .identity
            })
    }
    
    private func observe() {
        $state.sink { [unowned self] state in
            switch state {
            case .clear:
                setupAnimator()
                foregroundView.alpha = 0.0
                animator.stopAnimation(false)
            case .animating:
                foregroundView.transform = .init(scaleX: 0, y: 1.0)
                foregroundView.transform = .init(translationX: -frame.size.width, y: 0)
                foregroundView.alpha = 1.0
                animator.startAnimation()
            case .filled:
                animator.stopAnimation(true)
                foregroundView.transform = .identity
            }
        }.store(in: &subscribers)
    }
    
    private func layout() {
        addSubview(backgroundview)
        backgroundview.addSubview(foregroundView)
        
        backgroundview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        foregroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func startAnimating() {
        state = . animating
    }
    
    func reset() {
        state = .clear
    }
    
    func complete() {
        state = .filled
    }
}
