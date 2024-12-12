import UIKit

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
    
    public weak var delegate: VPOnboardingKitDelegate?
    
    private lazy var onboardingController: OnboardingViewController = {
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
        }
        controller.getStartedButtonDidTap = { [weak self] in
            self?.delegate?.getStartedButtonTapped()
        }
        return controller
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
