
import UIKit

//: MARK: Reusable Transition AnimationDescriptor -
typealias TransitioningContextClosure = (UIViewControllerContextTransitioning) -> ()
typealias PresentedFrameClosure = (CGRect,CGSize) -> (CGRect)
typealias ContainerSizeClosure = (CGSize) -> (CGSize)
typealias RegularSizeClosure = (CGSize) -> (CGSize)

public
struct PresentationAnimationDescriptor {
    let dimBackground: Bool
    let duration: TimeInterval
    let containerSize: ContainerSizeClosure
    let presentedFrame: PresentedFrameClosure
    let presentation: TransitioningContextClosure
    let dissmisal: TransitioningContextClosure
    init(
         _ dimBackground: Bool = true,
         _ duration: TimeInterval,
         _ containerSize: @escaping ContainerSizeClosure,
         _ presentedFrame: @escaping PresentedFrameClosure,
         _ presentation: @escaping TransitioningContextClosure,
         _ dissmisal: @escaping TransitioningContextClosure
        )
    {
        self.dimBackground = dimBackground
        self.duration = duration
        self.containerSize = containerSize
        self.presentedFrame = presentedFrame
        self.presentation = presentation
        self.dissmisal = dissmisal
    }
}

extension PresentationAnimationDescriptor {
    static func defaultDescriptor() -> PresentationAnimationDescriptor {
        
        let dimBackground = true
        
        let duration = 0.3
        
        let containerSize: ContainerSizeClosure = { (parentSize) in
            return CGSize(width: parentSize.width*0.75, height: parentSize.height*0.75)
        }
        
        let presentedFrame: PresentedFrameClosure = { (containerBounds, size) in
            var presentedFrame = CGRect.zero
            presentedFrame.size = size
            presentedFrame.origin.y = (containerBounds.size.height/2 - size.height/2)
            presentedFrame.origin.x = (containerBounds.size.width/2 - size.width/2)
            return presentedFrame
        }
        
        let presentation: TransitioningContextClosure = { (context) in
            let controller = context.viewController(forKey: UITransitionContextViewControllerKey.to)!
            controller.view.layer.masksToBounds = true
            controller.view.layer.cornerRadius = 12.0
            context.containerView.addSubview(controller.view)
            let presentedFrame = context.finalFrame(for: controller)
            var dismissedFrame = presentedFrame
            dismissedFrame.origin.y = context.containerView.frame.size.height
            let initialFrame = dismissedFrame
            let finalFrame = presentedFrame
            controller.view.frame = initialFrame
            UIView.animate(withDuration: duration, animations: {
                controller.view.frame = finalFrame
            }) { finished in
                context.completeTransition(finished)
            }
        }
        
        let dismissal: TransitioningContextClosure = { (context) in
            let controller = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
            let presentedFrame = context.finalFrame(for: controller)
            var dismissedFrame = presentedFrame
            dismissedFrame.origin.y = context.containerView.frame.size.height
            let initialFrame = presentedFrame
            let finalFrame = dismissedFrame
            controller.view.frame = initialFrame
            UIView.animate(withDuration: duration, animations: {
                controller.view.frame = finalFrame
            }) { finished in
                context.completeTransition(finished)
            }
        }
        
        return PresentationAnimationDescriptor.init(dimBackground, duration, containerSize, presentedFrame, presentation, dismissal)
    }
}


// MARK: - JMPresentationController
final class JMPresentationController: UIPresentationController {
    
    // MARK: - Properties
    fileprivate var dimmingView: UIView!
    let descriptor:PresentationAnimationDescriptor!
    
    override var frameOfPresentedViewInContainerView: CGRect {
       return descriptor.presentedFrame(containerView!.bounds,size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size))
    }
    
    // MARK: - Initializers
    init(_ presentedViewController: UIViewController,_ presentingViewController: UIViewController?,_ descriptor:PresentationAnimationDescriptor) {
        self.descriptor = descriptor
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
        
        if descriptor.dimBackground {
            setupDimmingView()
        } else {
            setupBackgroundView()
        }
    }
    
    override func presentationTransitionWillBegin() {
        
        containerView?.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return descriptor.containerSize(parentSize)
    }
}

// MARK: - Dimming View
private extension JMPresentationController {
    
    func setupBackgroundView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = .clear
        dimmingView.alpha = 0.0
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}



// Reusable
// MARK: - UIViewControllerTransitioningDelegate
final class JMPresentationTransitioningDelegate: NSObject {
    var descriptor: PresentationAnimationDescriptor = .defaultDescriptor()
}

extension JMPresentationTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = JMPresentationController(presented, presenting, descriptor)
        presentationController.delegate = self
        presented.modalPresentationStyle = .custom
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JMPresentationAnimator(true,descriptor)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JMPresentationAnimator(false,descriptor)
    }
}

extension JMPresentationTransitioningDelegate: UIAdaptivePresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
        /*
         if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
         return .overFullScreen
         } else {
         return .none
         }
         */
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return nil
        /*
         guard case(.overFullScreen) = style else { return nil }
         return nil
         */
    }
}


// MARK: - JMPresentationAnimator (Reusable Animator Class)
final class JMPresentationAnimator: NSObject {
    let isPresentation: Bool
    let animationDescriptor: PresentationAnimationDescriptor
    
    // MARK: - Initializers
    init(_ isPresentation: Bool,_ animationDescriptor:PresentationAnimationDescriptor = .defaultDescriptor()) {
        self.isPresentation = isPresentation
        self.animationDescriptor = animationDescriptor
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension JMPresentationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDescriptor.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresentation ? animationDescriptor.presentation(transitionContext) : animationDescriptor.dissmisal(transitionContext)
    }
}
