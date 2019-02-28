import UIKit
import Intents

final class MainViewController : UIViewController {
    
    lazy var customPresentationTransitioningDelegate = JMPresentationTransitioningDelegate()
    private var lastSegmentIndex = 0
    private var nowPlayingArtwork: UIImage = .init()
    private var containerView = UIView()
    private var scrollView = UIScrollView()
    
    deinit { }
    required init?(coder aDecoder: NSCoder) {fatalError()}
    init() {super.init(nibName: nil, bundle: nil); setupUI()}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for view in view.subviews {
            if view is UISegmentedControl {
                (view as! UISegmentedControl).setEnabled(true, forSegmentAt: lastSegmentIndex)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donateInteraction()
    }
    
    func donateInteraction() {
        if #available(iOS 12.0, *) {
            
             donateIntents([
                TVPowerOnIntent(),
                VolumeUpIntent(),
                AmbilightOnIntent(),
                SelectIntent(),
                ],
                    [
                    "Turn the TV On",
                    "Turn up the volume",
                    "Ambilight On",
                    "Select",
                ])
            
        }
        
        
        
        
        
    }
    
    func donateIntents(_ intents:[INIntent],_ phrases:[String]){
        if #available(iOS 12.0, *) {
            for (intent,phrase) in zip(intents,phrases) {
                intent.suggestedInvocationPhrase = phrase
                let interaction = INInteraction(intent: intent, response: nil)
                interaction.donate { (error) in
                    if error != nil {
                        if let error = error as NSError? {
                            print(error.localizedDescription)
                        } else {
                            print("Successfully donated interaction")
                        }
                    } else {
                        
                        print("Successfully donated interaction using: \(phrase)")
                    }
                }
            }
        }
    }
    
}


extension MainViewController {
    
    func makeActionRequest(_ action:String){
        makeAPIRequestWith(APIRequest("chosen_action", ["action": action],{_ in}))
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "AmbiLight"
        makeControllerView()
    }
    
    func customPresent(_ viewControllerToPresent:UIViewController,completion: (() -> Void)? = nil ){
        customPresentationTransitioningDelegate.descriptor = FLPresentationDescriptors.overlay()
        viewControllerToPresent.transitioningDelegate = customPresentationTransitioningDelegate
        viewControllerToPresent.modalPresentationStyle = .custom
        present(viewControllerToPresent, animated: true, completion: completion)
    }

}

//: MARK: - New View Section -
extension MainViewController {
    
    @objc
    func handleButtonPress(_ btn:UIButton) {
        switch btn.attributedTitle(for: UIControl.State())!.string {
        case "Volume Up":
            makeActionRequest("Volume Up")
        case "Volume Down":
            makeActionRequest("Volume Down")
        case "TV Power On":
            makeActionRequest("TV Power On")
        case "TV Power Off":
            makeActionRequest("TV Power Off")
        case "HDMI 1":
            makeActionRequest("HDMI 1")
        case "Menu":
            ATVCommander.menu()
        case "Top":
            makeActionRequest("Top Menu")
        case "Options":
            customPresent(UINavigationController(rootViewController:OptionsViewController()))
        default:
            break
        }
        App.successFeedback()
    }
    
    
    private func prepareButton(_ btn:UIButton,_ color:UIColor,_ text:String = "") {
        btn.backgroundColor = color
        btn.setAttributedTitle(buttonAttributedTitle(text), for: UIControl.State())
        btn.showsTouchWhenHighlighted = true
        btn.isEnabled = true
        btn.isUserInteractionEnabled = true
        
        btn.layer.maskedCorners = [
            CACornerMask.layerMaxXMaxYCorner,
            CACornerMask.layerMaxXMinYCorner,
            CACornerMask.layerMinXMaxYCorner,
            CACornerMask.layerMinXMinYCorner,
        ]
        btn.layer.cornerRadius = 12.0
        btn.layer.masksToBounds = true
        
        let edge: CGFloat = 16.0
        btn.contentEdgeInsets = .init(top: edge, left: edge, bottom: edge, right: edge)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
    }
    
    private func buttonAttributedTitle(_ text:String) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: UIFont(descriptor: UIFont.preferredFont(forTextStyle: .headline).fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0),
                NSAttributedString.Key.foregroundColor : UIColor.white,
                ]
        )
    }
 
    func makeControllerView() {
        
        let volUp = UIButton()
        let volDown = UIButton()
        let powerOn = UIButton()
        let powerOff = UIButton()
        let hdmi = UIButton()
        
        prepareButton(volUp, #colorLiteral(red: 0.3121859333, green: 0.2966189455, blue: 0.8899508249, alpha: 1), "Volume Up")
        prepareButton(volDown, #colorLiteral(red: 0.3121859333, green: 0.2966189455, blue: 0.8899508249, alpha: 1), "Volume Down")
        prepareButton(powerOn, #colorLiteral(red: 0, green: 1, blue: 0.4282035359, alpha: 1), "TV Power On")
        prepareButton(powerOff, .red, "TV Power Off")
        prepareButton(hdmi, #colorLiteral(red: 1, green: 0.7256781276, blue: 0.396567274, alpha: 1), "HDMI 1")
        
        // TV and Volume Stack
        let tvVolumeStack = makeStackWith([powerOff,hdmi,powerOn],[volUp,volDown], view)
        // Remote TouchPad View
        let remoteTouchPadView = makeRemoteView(view)
        // Remote Buttons
        let menu = UIButton()
        prepareButton(menu, .darkGray, "Menu")
        let top = UIButton()
        prepareButton(top, .darkGray, "Top")
        // Remote
        let remoteButtonsStack = makeStackWith([menu], [top], view)
        // Options
        let options = UIButton()
        view.addSubview(options)
        prepareButton(options, #colorLiteral(red: 0.000336465678, green: 0.5532112656, blue: 1, alpha: 1), "Options")
        
        // Segment (IR HDMI Switching)
        let irSegmentControl = makeSegmentedControl(view.layoutMarginsGuide.topAnchor, view)
        
        // Layout 
        tvVolumeStack.topAnchor.constraint(equalTo: irSegmentControl.bottomAnchor, constant: 8.0).isActive = true
        tvVolumeStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        tvVolumeStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        tvVolumeStack.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.26).isActive = true
        
        remoteTouchPadView.topAnchor.constraint(equalTo: tvVolumeStack.bottomAnchor, constant: 8.0).isActive = true
        
        remoteButtonsStack.topAnchor.constraint(equalTo: remoteTouchPadView.bottomAnchor, constant: 2.0).isActive = true
        remoteButtonsStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        remoteButtonsStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        remoteButtonsStack.heightAnchor.constraint(equalTo: remoteTouchPadView.heightAnchor, multiplier: 0.35).isActive = true

        // Layout
        options.topAnchor.constraint(equalTo: remoteButtonsStack.bottomAnchor, constant: 8.0).isActive = true
        options.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        options.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        options.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0).isActive = true
        
    }
    
    
    func makeStackWith(_ leadingViews:[UIView],_ trailingViews:[UIView],_ insideView:UIView) -> UIStackView {
        let leftStack = UIStackView()
        leftStack.axis = .vertical
        leftStack.distribution = .fillEqually
        leftStack.spacing = 8.0
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        
        let rightStack = UIStackView()
        rightStack.axis = .vertical
        rightStack.distribution = .fillEqually
        rightStack.spacing = 8.0
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        leadingViews.forEach{ leftStack.addArrangedSubview($0) }
        trailingViews.forEach{ rightStack.addArrangedSubview($0) }
        
        stack.addArrangedSubview(leftStack)
        stack.addArrangedSubview(rightStack)
        
        insideView.addSubview(stack)
        
        return stack
    }
    
    
    func makeScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = true
        scrollView.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
}

//: MARK: - tv Remote -
extension MainViewController {
    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .left:
            ATVCommander.left()
        case .right:
            ATVCommander.right()
        case .up:
            ATVCommander.up()
        case .down:
            ATVCommander.down()
        default:
            break
        }
    }
    
    @objc func handleTap(_ sender:UITapGestureRecognizer) {
        ATVCommander.select()
    }
    
    func makeRemoteView(_ insideView:UIView) -> UIView {
        let remoteView = UIView()
        remoteView.translatesAutoresizingMaskIntoConstraints = false
        remoteView.backgroundColor = .darkGray
        remoteView.layer.cornerRadius = 8.0
        remoteView.layer.masksToBounds = true
        
        insideView.addSubview(remoteView)
        
        remoteView.heightAnchor.constraint(equalTo: remoteView.widthAnchor, multiplier: 0.5).isActive = true
        
        remoteView.leadingAnchor.constraint(equalTo: insideView.layoutMarginsGuide.leadingAnchor).isActive = true
        remoteView.trailingAnchor.constraint(equalTo: insideView.layoutMarginsGuide.trailingAnchor).isActive = true
        
        addGesturesTo(remoteView)
        
        return remoteView
    }
    
    func addGesturesTo(_ view:UIView){
        makeSwipeGestureRecognizer(.left, view)
        makeSwipeGestureRecognizer(.right, view)
        makeSwipeGestureRecognizer(.up, view)
        makeSwipeGestureRecognizer(.down, view)
        makeTapGestureRecognizer(view)
    }
    
    func makeTapGestureRecognizer(_ onView:UIView) {
        let tap = UITapGestureRecognizer()
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(handleTap(_:)))
        onView.addGestureRecognizer(tap)
    }
    
    func makeSwipeGestureRecognizer(_ direction:UISwipeGestureRecognizer.Direction,_ onView:UIView) {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = direction
        swipe.addTarget(self, action: #selector(handleSwipe(_:)))
        onView.addGestureRecognizer(swipe)
    }
    
}


//: MARK: - Segmented Control -
extension MainViewController {
    
    @objc func handleSegmentChange(_ sender:UISegmentedControl) {
        
        if sender.selectedSegmentIndex != lastSegmentIndex {
            switch sender.selectedSegmentIndex {
            case 0:
                makeActionRequest("Apple TV")
            case 1:
                makeActionRequest("Nintendo Switch")
            case 2:
                makeActionRequest("PS4")
            default:
                break
            }
        }
        
        App.successFeedback()
        lastSegmentIndex = sender.selectedSegmentIndex
    }
    
    // Squared Segment Control
    func makeSegmentedControl(_ under:NSLayoutYAxisAnchor? = nil,_ insideView:UIView) -> UISegmentedControl {
        
        let segmentedControl = UISegmentedControl()
        
        let firstImage = UIImage(named: "apple-tv")!
        let secondImage = UIImage(named: "Nintendo_Switch")!
        let thirdImage = UIImage(named: "playstation")!
        
        segmentedControl.insertSegment(with: firstImage, at: 0, animated: true)
        segmentedControl.insertSegment(with: secondImage, at: 1, animated: true)
        segmentedControl.insertSegment(with: thirdImage, at: 2, animated: true)
        segmentedControl.tintColor = .black
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange(_:)), for: .allEvents)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        insideView.addSubview(segmentedControl)
        segmentedControl.leadingAnchor.constraint(equalTo: insideView.layoutMarginsGuide.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: insideView.layoutMarginsGuide.trailingAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1/3).isActive = true
        if let bottomAnchor = under {
            segmentedControl.topAnchor.constraint(equalTo: bottomAnchor, constant: 8.0).isActive = true
        }
        
        segmentedControl.selectedSegmentIndex = lastSegmentIndex
        
        return segmentedControl
        
    }
    
}
