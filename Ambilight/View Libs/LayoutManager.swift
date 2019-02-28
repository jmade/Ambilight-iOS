
import UIKit
 
struct LayoutManager {
    
    static func overlay(_ view:UIView, onView to:UIView,_ padding:CGFloat = 0) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        to.addSubview(view)
        return [
            view.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: padding),
            view.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: -padding),
            view.topAnchor.constraint(equalTo: to.topAnchor, constant: padding),
            view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -padding),
        ]
    }
    
    
    
    static func pin(_ view:UIView,toView to:UIView,_ padding:CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            view.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: padding),
            view.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: -padding),
            view.topAnchor.constraint(equalTo: to.topAnchor, constant: padding),
            view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -padding),
        ]
    }
    
    static func stack(_ views:[UIView],verticallyUnder underView:UIView,_ constant:CGFloat = 3.0) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        (0..<views.count).forEach({
            let view = views[$0]
            let bottomAnchor = $0 == 0 ? underView.bottomAnchor : views[$0-1].bottomAnchor
            constraints.append(view.leadingAnchor.constraint(equalTo: underView.leadingAnchor))
            constraints.append(view.centerXAnchor.constraint(equalTo: underView.centerXAnchor))
            let topToBottom = view.topAnchor.constraint(equalTo: bottomAnchor, constant: constant)
            topToBottom.identifier = "Top (\($0)) to Bottom of Last View (\($0-1))~StackVerticallyUnder~"
            topToBottom.priority = UILayoutPriority(749.0)
            constraints.append(topToBottom)
        })
        return constraints
    }
    
    // Single Column
   static func stackViewsCentered(_ views:[UIView],
                          underneathAnchor topAnchor: NSLayoutYAxisAnchor,
                          withTopAnchorPadding topPadding: CGFloat,
                          withVerticalSpacing verticalSpacing: CGFloat,
                          withHorizontalSpacing horizontalSpacing: CGFloat,
                          insideView container: UIView) -> [NSLayoutConstraint] {
    
        var constraints: [NSLayoutConstraint] = []
        var guide: UILayoutGuide = container.layoutMarginsGuide
        if #available(iOS 11.0, *) { guide = container.safeAreaLayoutGuide }
    
        (0..<views.count).forEach({
            let view = views[$0]
            // Add view into the Container
            view.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(view)
            // This is the Anchor that the View's topAnchor will be constrained to.
            let bottomAnchor = $0 == 0 ? topAnchor : views[$0-1].bottomAnchor
            
            constraints.append(view.centerXAnchor.constraint(equalTo: guide.centerXAnchor))
            // Leading to Container Leading
            //constraints.append(view.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: horizontalSpacing))
            // Trailing to Container Trailing
            //constraints.append(view.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -horizontalSpacing))
            // Top Anchor to last view's bottom or for the first item, the topAnchor sent into the function
            constraints.append(view.topAnchor.constraint(equalTo: bottomAnchor, constant: verticalSpacing))
        })
        return constraints
    }
    
    // 2 column layout
    func stackViewsDoubleColumn(_ views:[UIView], underneathAnchor topAnchor:NSLayoutYAxisAnchor, withSpacing spacing:CGFloat, insideView container:UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        // center the last label if its odd?
        //var centerLast: Bool = false
        
        
        
        (0..<views.count).forEach({
            let view = views[$0]
            // Add view into the Container
            container.addSubview(view)
            // This is the Anchor that the View's topAnchor will be constrained to.
            let bottomAnchor = $0 == 0 ? topAnchor : views[$0-1].bottomAnchor
            // Leading to Container Leading
            constraints.append(view.leadingAnchor.constraint(equalTo: container.leadingAnchor))
            
            // trailing
            
            // Trailing to Container Trailing
            constraints.append(view.trailingAnchor.constraint(equalTo: container.trailingAnchor))
            // Top Anchor to last view's bottom or for the first item, the topAnchor sent into the function
            constraints.append(view.topAnchor.constraint(equalTo: bottomAnchor, constant: spacing))
        })
        return constraints
    }
    
    
    
    
    static func layout(_ views:[UIView],_ containerView:UIView,_ topAnchorView:UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        var guide: UILayoutGuide = containerView.layoutMarginsGuide
        if #available(iOS 11.0, *) { guide = containerView.safeAreaLayoutGuide }
        let columnSpacing: CGFloat = 4.0
        let topAnchor = topAnchorView.topAnchor
        (0..<views.count).forEach({
            let label = views[$0]
            label.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(label)
            constraints.append(label.topAnchor.constraint(equalTo: topAnchor, constant: 2.0))
            if $0 == 0 {
                constraints.append(label.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: columnSpacing))
            } else {
                constraints.append(label.leadingAnchor.constraint(equalTo: views[$0-1].trailingAnchor, constant: columnSpacing))
            }
        })
        return constraints
    }
    
    
}
