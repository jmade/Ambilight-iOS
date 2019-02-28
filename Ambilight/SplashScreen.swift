

import UIKit

//: MARK: - Ping -
struct Ping {
    let endpoint : String
    let message : String
    let status : Int
    let success : Bool
}

extension Ping {
    enum Keys: String {
        case endpoint = "endpoint"
        case message = "message"
        case status = "status"
        case success = "success"
    }
}

extension Ping {
    init(_ data:[String:Any] = ["":""]){
        self.endpoint = data[Keys.endpoint.rawValue] as? String ?? ""
        self.message = data[Keys.message.rawValue] as? String ?? ""
        self.status = data[Keys.status.rawValue] as? Int ?? 0
        self.success = data[Keys.success.rawValue] as? Int ?? 0 == 1
    }
}


//: MARK: - SplashScreen -
final class SplashScreen: UIViewController {
    
    
    var lastIP: Int = 0 {
        didSet {
            newBase = "http://192.168.0.\(lastIP):8080/"
        }
    }
    
    var newBase: String = "" {
        didSet {
            print("New EndPoint Set...\(newBase)")
            makeAPIRequestWith(APIRequest("ping", nil) { [weak self] in
                print($0.value)
                self?.ping = Ping($0.value)
            })
            
        }
    }

    var ping: Ping! {
        didSet {
            guard ping.success else { presentConnectionError(); return }
            UIView.animate(withDuration: 0.5, animations: {
                UIApplication.shared.delegate?.window??.rootViewController = UINavigationController(rootViewController: MainViewController())
            })
        }
    }
    
    lazy var customPresentationTransitioningDelegate = JMPresentationTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        setupImageView()
        makeStartTerminalRequest()
    }
    
    @objc
    func handleDoubleTap(){
        /*
        let title = "Did The IP change?"
        let message = "Change Last Digit of the IP Address"
        let _lastIP = lastIP
        let _self = self
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "\(_lastIP)"
        }
        
        let updateIntervalAction = UIAlertAction(title: "Update IP", style: .default){ _ in
            if alert.textFields!.first!.text != "" {
                if let newDigit = Int(alert.textFields!.first!.text!) {
                    _self.lastIP = newDigit
                }
            }
        }
        
        alert.addAction(updateIntervalAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in})
        present(alert, animated: true, completion: nil)
        */
        
        self.ping = Ping(endpoint: "ambi", message: "hello", status: 200, success: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func makeStartTerminalRequest(){
        
        makeAPIRequestWith(APIRequest("ping", nil) { [weak self] in
            print($0.value)
            self?.ping = Ping($0.value)
        })
        
        //self.ping = Ping(endpoint: "ambi", message: "hello", status: 200, success: true)
    }
    
    func setupImageView(){
        
        let bigRect = max(view.bounds.size.width+75.0, view.bounds.size.height+75.0).squaredRect()
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "wheel"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = bigRect
        imageView.alpha = 0.5
        view.addSubview(imageView)
        imageView.center = view.center
        
        UIView.animate(withDuration: 0.5) {
            imageView.alpha = 1.0
        }
        
        
        // CABasicAnimation
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.duration = 12
        animate.repeatCount = Float.infinity
        animate.fromValue = 0.0
        animate.toValue = .pi * 2.0
        
        // Add Animation
        imageView.layer.add(animate, forKey: "rotation")
        
    }
    

    func presentConnectionError(){
        
        let controller = CustomAlertViewController("Cannot Connect to\nAmbilight System") { [weak self] in
            print("Alert Controller Action Fire")
            self?.makeStartTerminalRequest()
        }
        
        customPresent(controller)
    }
    
    func customPresent(_ viewControllerToPresent:UIViewController,completion: (() -> Void)? = nil ){
        customPresentationTransitioningDelegate.descriptor = FLPresentationDescriptors.customAlert()
        viewControllerToPresent.transitioningDelegate = customPresentationTransitioningDelegate
        viewControllerToPresent.modalPresentationStyle = .custom
        present(viewControllerToPresent, animated: true, completion: completion)
    }
    
}
