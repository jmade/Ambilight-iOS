
import UIKit
import IntentsUI

final class IntentVisualViewController: UIViewController {
    
    enum DisplayType {
        case volumeUp,tvPowerOn,off
    }
    
    var displayType: DisplayType = .off
    var message:String = "-"
    let label = UILabel()
    
    
    deinit { }
    required init?(coder aDecoder: NSCoder) {fatalError()}
    init() {super.init(nibName: nil, bundle: nil)}
    init(_ message:String){
        super.init(nibName: nil, bundle: nil)
        self.message = message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.textColor = .black
        label.text = message
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            
            view.heightAnchor.constraint(equalToConstant: 200),
            NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0),
            ])
        
    }
    
}

extension IntentVisualViewController: INUIHostedViewSiriProviding {
    var displaysMessage: Bool {
        return true
    }
}

