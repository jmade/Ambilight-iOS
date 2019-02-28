import UIKit

typealias ActionClosure = () -> ()

struct AlertAction {
    let title: String
    let action: ActionClosure
    init(_ title:String = "", _ action: @escaping ActionClosure = {}) {
        self.title = title
        self.action = action
    }
}

final class CustomAlertViewController: UIViewController {
    
    private var alertTitle: String = ""
    private var actionTitle: String = ""
    private var alertAction: ActionClosure = {}
    
    // network...
    private var networkRequests: [APIRequest] = []
    private var alertActions: [AlertAction] = []
    

    // UI
    private var titleLabel = UILabel()
    private var actionButton = UIButton()
    
    deinit {print("CustomAlertViewController DEINIT!!!")}
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
    init(_ title:String,_ actionTitle:String = "Okay",_ action: @escaping () -> () = {}) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.alertAction = action
        self.actionTitle = actionTitle
    }
    
    init(_ title:String,_ action:AlertAction){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.alertActions.append(action)
    }
    
    init(_ title:String,_ networkRequest:APIRequest){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.actionTitle = "Okay"
        self.networkRequests.append(networkRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        
        view.backgroundColor = .white
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.masksToBounds = true
        
        
        let label = makeTitleLabel(alertTitle)
        
        let contentView = makeContentView()
        
        if alertActions.isEmpty {
            
            let retryButton = makeActionButton(actionTitle)
            contentView.addSubview(retryButton)
            let constraints = Array([
                layoutConstraintsFor(label, contentView),
                [retryButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
                 retryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                 retryButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                 ],
                ].joined())
            
            NSLayoutConstraint.activate(constraints)
            actionButton = retryButton
            
        } else {
            // multi
            let retryButton = makeActionButton(alertActions.first!.title)
            
            contentView.addSubview(retryButton)
            
            
            let constraints = Array([
                layoutConstraintsFor(label, contentView),
                
                [retryButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
                 retryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                 retryButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                 ],
                ].joined())
            NSLayoutConstraint.activate(constraints)
            actionButton = retryButton
        }

        
        titleLabel = label
        
    }
    
    // Title Label
    func makeTitleLabel(_ titleText:String = "") -> UILabel {
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    func makeContentView() -> UIView {
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        return contentView
    }
    
    func layoutConstraintsFor(_ titleLabel:UILabel,_ contentView:UIView) -> [NSLayoutConstraint] {
        return [
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 4.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.0),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4.0),
        ]
    }
    
    // Action Button
    func makeActionButton(_ titleText:String = "") -> UIButton {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = .blue
        
        button.layer.maskedCorners = [
            CACornerMask.layerMaxXMaxYCorner,
            CACornerMask.layerMaxXMinYCorner,
            CACornerMask.layerMinXMaxYCorner,
            CACornerMask.layerMinXMinYCorner,
        ]
        
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        
        let buttonAttributedTitle = NSAttributedString(
            string: titleText,
            attributes: [
                NSAttributedString.Key.font: UIFont(descriptor: UIFont.preferredFont(forTextStyle: .headline).fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0),
                NSAttributedString.Key.foregroundColor : UIColor.white,
            ]
        )
        button.setAttributedTitle(buttonAttributedTitle, for: UIControl.State())
        
        button.showsTouchWhenHighlighted = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        let edge: CGFloat = 16.0
        button.contentEdgeInsets = .init(top: edge, left: edge, bottom: edge, right: edge)
        button.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    @objc
    func buttonPressed(_ sender:UIButton) {
        
        if !networkRequests.isEmpty {
            makeNetworkRequest()
        } else {
            if alertActions.isEmpty {
                let action = alertAction
                dismiss(animated: true) { action() }
            } else {
                // multi
                let action = alertActions.first!
                dismiss(animated: true) { action.action() }
            }
        }
        
    }
}





//: MARK: - makeActionRequest -
extension CustomAlertViewController {
    
    func makeActionRequest(_ chosenAction:String?){
        let req = APIRequest(
            "chosen_action",
            ["action": chosenAction ?? ""]) { [weak self] in
                print("Server Response: \($0.value)")
                self?.performSuccess()
        }
        addLoadingView(view)
        makeAPIRequestWith(req)
    }
    
    
    func makeNetworkRequest(){
        if let req = networkRequests.first {
            print("Performing Request!")
            addLoadingView(view)
            let newReq = APIRequest(req.endpoint, req.additionalParameters) { [weak self] in
                print("Server Response: \($0.value)")
                self?.performSuccess()
            }
            makeAPIRequestWith(newReq)
        }
    }
    
}



//: MARK: - performSuccess -
extension CustomAlertViewController {
    
    func performSuccess(){
        
        for view in view.subviews {
            if view is NewLoadingView {
                view.removeFromSuperview()
            }
        }
        
        let successFont = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .title1).fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
        let attributedTitle = NSAttributedString(
            string: "Success!",
            attributes: [
                NSAttributedString.Key.font : successFont,
                NSAttributedString.Key.foregroundColor : UIColor.white,
                ]
        )
        
        let sucessLabel = UILabel()
        sucessLabel.textAlignment = .center
        sucessLabel.attributedText = attributedTitle
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            if #available(iOS 10.0, *) {
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.success)
            }
            
            if let strongSelf = self {
                
                strongSelf.actionButton.isHidden = true
                strongSelf.titleLabel.isHidden = true
                strongSelf.view.backgroundColor = .green
                
                NSLayoutConstraint.activate(
                    LayoutManager.overlay(sucessLabel, onView: strongSelf.view)
                )
                
            }
        }
        
        
        TimeDelay.withSeconds(1.75) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func addConfimButton(_ titleText:String = "") {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]), for: UIControl.State())
        button.setTitleColor(.black, for: UIControl.State())
        button.isEnabled = true
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        view.addSubview(button)
        NSLayoutConstraint.activate(LayoutManager.pin(button, toView: view))
    }
    
}


