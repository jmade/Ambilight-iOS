
import UIKit

//: MARK: - LoadingView -

// UIView
func addLoadingView(_ toView:UIView,_ opaque:Bool=false){
    DispatchQueue.main.async(execute: {
        let loadingView = NewLoadingView(frame: toView.bounds)
        if opaque { loadingView.backgroundColor = UIColor(white: 1.0, alpha: 1.0) }
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        toView.addSubview(loadingView)
        toView.bringSubviewToFront(loadingView)
        loadingView.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
    })
}


func removeLoadingView(_ fromView:UIView){
    DispatchQueue.main.async(execute: {
        for view in fromView.subviews {
            if view is NewLoadingView {
                (view as! NewLoadingView).end()
            }
        }
    })
}

//: MARK: - MessageView -  
func addMessageViewTo(_ toView:UIView,_ message:String){
    let messageView = UIView()
    messageView.backgroundColor = UIColor(white: 0.98, alpha: 0.7)
    let label = UILabel()
    label.text = message
    
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    
    messageView.addSubview(label)
    label.topAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: messageView.leadingAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: messageView.trailingAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
    messageView.translatesAutoresizingMaskIntoConstraints = false
    
    toView.addSubview(messageView)
    messageView.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
    messageView.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
    messageView.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
    messageView.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
}



//: MARK: - API Error Handling

func newHandleAPIError(apiError: APIError,
                       msg: String?,
                       viewController: UIViewController?,
                       retryFunction: (()->())?)
{
    guard let vc = viewController else { return }
    
    let errorView = UIView()
    errorView.backgroundColor = UIColor(white: 0.20, alpha: 0.99)
    
    let errorLabel = UILabel()
    errorLabel.text = "Error Retrieving \(apiError.endpoint)"
    errorLabel.textColor = .white
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    errorLabel.textAlignment = .center
    errorLabel.font = UIFont.preferredFont(forTextStyle: .body)
    errorLabel.adjustsFontSizeToFitWidth = true
    errorLabel.allowsDefaultTighteningForTruncation = true
    errorLabel.numberOfLines = 0
    errorLabel.lineBreakMode = .byWordWrapping
    errorView.addSubview(errorLabel)
    errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor).isActive = true
    errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor).isActive = true
    errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor).isActive = true
    errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor).isActive = true
    
    let errorSize = CGSize(width: vc.view.bounds.size.width * 0.90, height: 52.0)
    let visibleY = vc.view.bounds.size.height-errorSize.height
    let underY = vc.view.bounds.size.height+errorSize.height
    let errorOrigin = CGPoint(x:(vc.view.bounds.size.width - errorSize.width)/2,y: underY)
    let underRect = CGRect(origin: errorOrigin, size: errorSize)
    let visibleRect = CGRect(x: errorOrigin.x,y: visibleY,width: errorSize.width,height: errorSize.height)
    
    let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: errorSize), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 12, height: 12))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    errorView.layer.mask = mask
    
    errorView.alpha = 0
    vc.view.addSubview(errorView)
    
    errorView.frame = underRect
    
    UIView.animate(withDuration: 1.0, animations: {
        errorView.alpha = 1.0
        errorView.frame = visibleRect
    }) { (complete) in
        UIView.animate(withDuration: 0.5, delay: 3.5, options: [], animations: {
            errorView.frame = underRect
            errorView.alpha = 0
        }) { (complete) in
            errorView.removeFromSuperview()
        }
    }
}

