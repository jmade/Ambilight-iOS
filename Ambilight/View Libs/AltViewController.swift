import UIKit

final class AltViewController: UIViewController {
    private var action: String = ""
    deinit {print("AltViewController DEINIT!!!")}
    init(_ chosenAction:String) {super.init(nibName: nil, bundle: nil); self.action = chosenAction}
    required init?(coder aDecoder: NSCoder) {fatalError()}

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addConfimButton("\(action)?")
    }
    
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
    
    func performSuccess(){
        
        for view in view.subviews {
            if view is NewLoadingView {
                view.removeFromSuperview()
            }
        }
        
        let successFont = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .headline).fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
        let attributedTitle = NSAttributedString(
            string: "Success!",
            attributes: [
                NSAttributedString.Key.font : successFont,
                NSAttributedString.Key.strokeColor : UIColor.blue,
                NSAttributedString.Key.foregroundColor : UIColor.blue,
                ]
        )
        
        for subview in view.subviews {
            if subview is UIButton {
                
                let button = (subview as! UIButton)
                button.isEnabled = false
                
                UIView.animate(withDuration: 0.5) { [weak self] in
                    if #available(iOS 10.0, *) {
                        let generator = UINotificationFeedbackGenerator()
                        generator.prepare()
                        generator.notificationOccurred(.success)
                    }
                    self?.view.backgroundColor = .green
                    button.setAttributedTitle(attributedTitle,for: UIControl.State())
                }
                
                TimeDelay.withSeconds(1.75) { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
                
            }
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
    
    func setup(){
        
    }
    
    
    func makeButton(_ titleText:String = ""){
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]), for: UIControl.State())
        button.setTitleColor(.black, for: UIControl.State())
        button.isEnabled = true
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
    }
    
    @objc
    func buttonPressed(_ sender:UIButton) {
        makeActionRequest(action)
    }

}
