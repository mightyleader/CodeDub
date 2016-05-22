import Foundation
import UIKit

public class SessionViewController: UIViewController
{
    //MARK: Private Properties
    
    private let scrollView = UIScrollView(frame: CGRectZero)
    private let sessionImageView = UIImageView(frame: CGRectZero)
    private let titleLabel = UILabel(frame: CGRectZero)
    private let titleLabelView = UIView(frame: CGRectZero)
    private let keywordsScrollView = UIScrollView(frame: CGRectZero)
    private let descriptionTextView = UITextView(frame: CGRectZero)
    private let playButton = PlayButton(frame: CGRectZero)
    
    private let darkBlurEffect = SessionViewController.blurView(style: .Dark)
    private let keywordFocusBadge = KeywordBadge(keyword: "• watchOS", type: KeywordType.Focus)
    private let keywordTrackBadge = KeywordBadge(keyword: "• App Frameworks", type: KeywordType.Track)
    
    private let placeholderName = "placeholder.png"
    
    var model: SessionVideoModel?
    
    convenience init(WithModel model: SessionVideoModel)
    {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //MARK: View lifecycle methods
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupSubviews()
        self.setupAutoLayout()
        self.setupContent()
    }
    
    public override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        let lastSubviewMaxYValue = CGRectGetMaxY(self.descriptionTextView.frame)
        self.scrollView.contentSize.height = lastSubviewMaxYValue
    }
    
    //MARK: Private Methods
    
    @objc private func dismissMe() -> Void
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func setupSubviews() -> Void
    {
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(sessionImageView)
        self.scrollView.addSubview(keywordsScrollView)
        self.scrollView.addSubview(descriptionTextView)
        self.scrollView.addSubview(playButton)
        
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.sessionImageView.addSubview(titleLabelView)
        self.titleLabelView.addSubview(darkBlurEffect)
        self.titleLabelView.addSubview(titleLabel)
        
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.textAlignment = .Left
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .ByWordWrapping
        self.titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    
        self.keywordsScrollView.backgroundColor = UIColor.whiteColor()
        self.keywordsScrollView.contentInset = UIEdgeInsets(top: 3,
                                                            left: 3,
                                                            bottom: 3,
                                                            right: 3)
        
        self.setupBadges([keywordTrackBadge, keywordFocusBadge], scrollView: keywordsScrollView)
        self.keywordsScrollView.addSubview(keywordFocusBadge)
        self.keywordsScrollView.addSubview(keywordTrackBadge)
        
        self.descriptionTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        self.descriptionTextView.textColor = UIColor.blackColor()
        self.descriptionTextView.backgroundColor = UIColor.whiteColor()
        self.descriptionTextView.scrollEnabled = false
        
        self.sessionImageView.image = SessionViewController.placeholderImage(placeholderName)
        self.sessionImageView.backgroundColor = UIColor.clearColor()
        self.sessionImageView.contentMode = .ScaleAspectFit
    }
    
    private func setupAutoLayout() -> Void
    {
        //Set translates to autoresize to no
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.sessionImageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabelView.translatesAutoresizingMaskIntoConstraints = false
        self.keywordsScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Scrollview
        self.scrollView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.scrollView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
        self.scrollView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        self.scrollView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        
        //Session Image
        self.sessionImageView.topAnchor.constraintEqualToAnchor(self.scrollView.topAnchor).active = true
        self.sessionImageView.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor).active = true
        self.sessionImageView.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
        self.sessionImageView.heightAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
        
        //Keywords list
        self.keywordsScrollView.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor).active = true
        self.keywordsScrollView.topAnchor.constraintEqualToAnchor(self.sessionImageView.bottomAnchor).active = true
        self.keywordsScrollView.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, multiplier: 1.0).active = true
        self.keywordsScrollView.heightAnchor.constraintGreaterThanOrEqualToConstant(30.0).active = true
        
        //Description of session
        self.descriptionTextView.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor).active = true
        self.descriptionTextView.topAnchor.constraintEqualToAnchor(self.keywordsScrollView.bottomAnchor).active = true
        self.descriptionTextView.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, multiplier: 1.0).active = true

        //Session title
        self.titleLabel.bottomAnchor.constraintEqualToAnchor(self.titleLabelView.bottomAnchor,
                                                             constant: -10.0) .active = true
        self.titleLabel.leftAnchor.constraintEqualToAnchor(self.titleLabelView.leftAnchor,
                                                           constant: 10.0).active = true
        self.titleLabel.rightAnchor.constraintEqualToAnchor(self.titleLabelView.rightAnchor,
                                                            constant: -10.0).active = true
        self.titleLabelView.leftAnchor.constraintEqualToAnchor(self.sessionImageView.leftAnchor).active = true
        self.titleLabelView.rightAnchor.constraintEqualToAnchor(self.sessionImageView.rightAnchor).active = true
        self.titleLabelView.bottomAnchor.constraintEqualToAnchor(self.sessionImageView.bottomAnchor).active = true
        self.titleLabelView.topAnchor.constraintEqualToAnchor(self.titleLabel.topAnchor, constant: -10.0).active = true
        self.constraintToFill(forView: darkBlurEffect, inView: titleLabelView)
        
        //Play button
        self.playButton.centerXAnchor.constraintEqualToAnchor(self.sessionImageView.centerXAnchor).active = true
        self.playButton.centerYAnchor.constraintEqualToAnchor(self.sessionImageView.centerYAnchor).active = true
    }
    
    private func setupContent() -> Void
    {
        if let model = self.model
        {
            self.titleLabel.text = SessionViewController.titleFromSession(model)
            self.descriptionTextView.text = model.description
            
            self.titleLabel.sizeToFit()
            self.descriptionTextView.sizeToFit()
        }
    }
    
    private func setupBadges(badges: [KeywordBadge],
                            scrollView: UIScrollView) -> Void
    {
        var offsetOrigin = CGPointZero
        for badge in badges
        {
            badge.frame.origin = offsetOrigin
            scrollView.addSubview(badge)
            offsetOrigin.x += (badge.frame.width + 10)
            scrollView.contentSize.width = CGRectGetMaxX(badge.frame)
        }
    }
    
    private func debugDescription() -> Void
    {
        print(("SCROLL" + scrollView.description + "\n"),
              ("IMAGEVIEW" + sessionImageView.description + "\n"),
              ("TITLEVIEW" + titleLabelView.description + "\n"),
              ("TITLE" + titleLabel.description + "\n"),
              ("TITLEBLUR" + darkBlurEffect.description + "\n"),
              ("KEYWORDS" + keywordsScrollView.description + "\n"),
              ("DESCRIPTION" + descriptionTextView.description + "\n")
            )
        
        for subview in keywordsScrollView.subviews
        {
            print("SUBVIEW: " + subview.description)
        }
    }
    
    private func setupNavigation() -> Void
    {
        let backButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                         target: self,
                                         action:#selector(self.dismissMe))
        
        backButton.tintColor = UIColor.blackColor()
        self.navigationItem.leftBarButtonItems = [backButton]
    }
    
    private func constraintToFill(forView forView: UIView, inView: UIView) -> Void
    {
        forView.translatesAutoresizingMaskIntoConstraints = false
        inView.translatesAutoresizingMaskIntoConstraints = false
        
        forView.leftAnchor.constraintEqualToAnchor(inView.leftAnchor).active = true
        forView.rightAnchor.constraintEqualToAnchor(inView.rightAnchor).active = true
        forView.topAnchor.constraintEqualToAnchor(inView.topAnchor).active = true
        forView.bottomAnchor.constraintEqualToAnchor(inView.bottomAnchor).active = true
    }
    
    private func constraintToWidthAsHeight(forView forView: UIView, inView: UIView) -> Void
    {
        forView.translatesAutoresizingMaskIntoConstraints = false
        inView.translatesAutoresizingMaskIntoConstraints = false
        
        forView.leftAnchor.constraintEqualToAnchor(inView.leftAnchor).active = true
        forView.rightAnchor.constraintEqualToAnchor(inView.rightAnchor).active = true
        forView.widthAnchor.constraintEqualToAnchor(inView.widthAnchor).active = true
        forView.heightAnchor.constraintEqualToAnchor(inView.widthAnchor).active = true
    }

    //MARK: Private Type Methods
    
    private class func titleFromSession(session: SessionVideoModel) -> String
    {
        if session.sessionID != "0"
        {
            return "Session " + session.sessionID + ": " + session.title
        }
        
        return session.title
    }
    
    private class func placeholderImage(imageName: String) -> UIImage
    {
        return UIImage(named: imageName)!
    }
    
    private class func blurView(style style:UIBlurEffectStyle) -> UIVisualEffectView
    {
        let blurEffect = UIBlurEffect(style: style)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        return blurredView
    }
    
}