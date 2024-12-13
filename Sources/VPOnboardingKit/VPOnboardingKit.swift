import UIKit
import Combine

// Protocol for handling VPOnboardingKit events via delegation
public protocol VPOnboardingKitDelegate: AnyObject {
    func onboardNextButtonTapped(atIndex index: Int)
    func getStartedButtonTapped()
}

@MainActor
public class VPOnboardingKit {
    
    private let slides: [Slide]
    private let slideDurationInSeconds: Int
    private let tintColor: UIColor
    private let themeFont: UIFont
    private var rootVC: UIViewController?
    
    // Delegate for handling events
    public weak var delegate: VPOnboardingKitDelegate?
    
    // Combine publishers for reactive event handling
    public var nextButtonPublisher = PassthroughSubject<Int, Never>()
    public var getStartedButtonPublisher = PassthroughSubject<Void, Never>()
    
    // Closurre for handling events via callbacks
    public var nextDidTapped: ((Int) -> Void)?
    public var getStartedDidTapped: (() -> Void)?
    
    private lazy var onboardingController: OnboardingViewController = {
        return makeOnboardingViewController()
    }()
    
    public init(
        slides: [Slide],
        slideDurationInSeconds: Int = 3,
        tintColor: UIColor,
        themeFont: UIFont = UIFont(name: "ArialRoundedMTBold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
    ) {
        self.slides = slides
        self.slideDurationInSeconds = slideDurationInSeconds
        self.tintColor = tintColor
        self.themeFont = themeFont
    }
    
    private func makeOnboardingViewController() -> OnboardingViewController {
        let controller = OnboardingViewController(
            slides: slides,
            slideDurationInSeconds: slideDurationInSeconds,
            tintColor: tintColor,
            themeFont: themeFont
        )
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.nextButtonDidTap = { [weak self] index in
            self?.delegate?.onboardNextButtonTapped(atIndex: index)
            self?.nextButtonPublisher.send(index)
            if let nextDidTapped = self?.nextDidTapped {
                nextDidTapped(index)
            }
        }
        controller.getStartedButtonDidTap = { [weak self] in
            self?.delegate?.getStartedButtonTapped()
            self?.getStartedButtonPublisher.send()
            if let getStartedDidTapped = self?.getStartedDidTapped {
                getStartedDidTapped()
            }
        }
        return controller
    }
    
    public func lauchOnboarding(rootViewController: UIViewController) {
        rootVC = rootViewController
        rootViewController.present(onboardingController, animated: true, completion: nil)
    }
    
    public func dismissOnboarding(animated: Bool, completion: (() -> Void)?) {
        onboardingController.stopAnimation()
        if rootVC?.presentedViewController == onboardingController {
            onboardingController.dismiss(animated: animated, completion: completion)
        }
    }
}
