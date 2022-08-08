import Foundation
import UIKit

public class SessionViewController: UIViewController
{
    //MARK: Private Properties
    
    private let scrollView = UIScrollView(frame: CGRect.zero)
    private let sessionImageView = UIImageView(frame: CGRect.zero)
    private let titleLabel = UILabel(frame: CGRect.zero)
    private let titleLabelView = UIView(frame: CGRect.zero)
    private let keywordsScrollView = UIScrollView(frame: CGRect.zero)
    private let descriptionTextView = UITextView(frame: CGRect.zero)
    private let playButton = PlayButton(frame: CGRect.zero)
    
    private let darkBlurEffect = SessionViewController.blurView(style: .dark)
    private let keywordFocusBadge = KeywordBadge(keyword: "• watchOS", type: KeywordType.Focus)
    private let keywordTrackBadge = KeywordBadge(keyword: "• App Frameworks", type: KeywordType.Track)
    
    private let placeholderName = "placeholder.png"
    
    var model: SessionVideoModel?
    
    convenience init(WithModel model: SessionVideoModel)
    {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
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
    
    public override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let lastSubviewMaxYValue = self.descriptionTextView.frame.maxY
        self.scrollView.contentSize.height = lastSubviewMaxYValue
    }
    
    //MARK: Private Methods
    
    @objc private func dismissMe() -> Void
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupSubviews() -> Void
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(sessionImageView)
        self.scrollView.addSubview(keywordsScrollView)
        self.scrollView.addSubview(descriptionTextView)
        self.scrollView.addSubview(playButton)
        
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.sessionImageView.addSubview(titleLabelView)
        self.titleLabelView.addSubview(darkBlurEffect)
        self.titleLabelView.addSubview(titleLabel)
        
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
    
        self.keywordsScrollView.backgroundColor = UIColor.white
        self.keywordsScrollView.contentInset = UIEdgeInsets(top: 3,
                                                            left: 3,
                                                            bottom: 3,
                                                            right: 3)
        
        self.setupBadges(badges: [keywordTrackBadge, keywordFocusBadge], scrollView: keywordsScrollView)
        self.keywordsScrollView.addSubview(keywordFocusBadge)
        self.keywordsScrollView.addSubview(keywordTrackBadge)
        
        self.descriptionTextView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        self.descriptionTextView.textColor = UIColor.black
        self.descriptionTextView.backgroundColor = UIColor.white
        self.descriptionTextView.isScrollEnabled = false
        
        self.sessionImageView.image = SessionViewController.placeholderImage(imageName: placeholderName)
        self.sessionImageView.backgroundColor = UIColor.clear
        self.sessionImageView.contentMode = .scaleAspectFit
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
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        //Session Image
        self.sessionImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.sessionImageView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.sessionImageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.sessionImageView.heightAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        //Keywords list
        self.keywordsScrollView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.keywordsScrollView.topAnchor.constraint(equalTo: self.sessionImageView.bottomAnchor).isActive = true
        self.keywordsScrollView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 1.0).isActive = true
        self.keywordsScrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30.0).isActive = true
        
        //Description of session
        self.descriptionTextView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.descriptionTextView.topAnchor.constraint(equalTo: self.keywordsScrollView.bottomAnchor).isActive = true
        self.descriptionTextView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 1.0).isActive = true

        //Session title
        self.titleLabel.bottomAnchor.constraint(equalTo: self.titleLabelView.bottomAnchor,
                                                             constant: -10.0) .isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.titleLabelView.leftAnchor,
                                                           constant: 10.0).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.titleLabelView.rightAnchor,
                                                            constant: -10.0).isActive = true
        self.titleLabelView.leftAnchor.constraint(equalTo: self.sessionImageView.leftAnchor).isActive = true
        self.titleLabelView.rightAnchor.constraint(equalTo: self.sessionImageView.rightAnchor).isActive = true
        self.titleLabelView.bottomAnchor.constraint(equalTo: self.sessionImageView.bottomAnchor).isActive = true
        self.titleLabelView.topAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -10.0).isActive = true
        self.constraintToFill(forView: darkBlurEffect, inView: titleLabelView)
        
        //Play button
        self.playButton.centerXAnchor.constraint(equalTo: self.sessionImageView.centerXAnchor).isActive = true
        self.playButton.centerYAnchor.constraint(equalTo: self.sessionImageView.centerYAnchor).isActive = true
    }
    
    private func setupContent() -> Void
    {
        if let model = self.model
        {
            self.titleLabel.text = SessionViewController.titleFromSession(session: model)
            self.descriptionTextView.text = model.description
            
            self.titleLabel.sizeToFit()
            self.descriptionTextView.sizeToFit()
        }
    }
    
    private func setupBadges(badges: [KeywordBadge],
                            scrollView: UIScrollView) -> Void
    {
        var offsetOrigin = CGPoint.zero
        for badge in badges
        {
            badge.frame.origin = offsetOrigin
            scrollView.addSubview(badge)
            offsetOrigin.x += (badge.frame.width + 10)
            scrollView.contentSize.width = badge.frame.maxX
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
        let backButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action:#selector(self.dismissMe))
        
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItems = [backButton]
    }
    
    private func constraintToFill(forView forView: UIView, inView: UIView) -> Void
    {
        forView.translatesAutoresizingMaskIntoConstraints = false
        inView.translatesAutoresizingMaskIntoConstraints = false
        
        forView.leftAnchor.constraint(equalTo: inView.leftAnchor).isActive = true
        forView.rightAnchor.constraint(equalTo: inView.rightAnchor).isActive = true
        forView.topAnchor.constraint(equalTo: inView.topAnchor).isActive = true
        forView.bottomAnchor.constraint(equalTo: inView.bottomAnchor).isActive = true
    }
    
    private func constraintToWidthAsHeight(forView forView: UIView, inView: UIView) -> Void
    {
        forView.translatesAutoresizingMaskIntoConstraints = false
        inView.translatesAutoresizingMaskIntoConstraints = false
        
        forView.leftAnchor.constraint(equalTo: inView.leftAnchor).isActive = true
        forView.rightAnchor.constraint(equalTo: inView.rightAnchor).isActive = true
        forView.widthAnchor.constraint(equalTo: inView.widthAnchor).isActive = true
        forView.heightAnchor.constraint(equalTo: inView.widthAnchor).isActive = true
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
    
    private class func blurView(style style:UIBlurEffect.Style) -> UIVisualEffectView
    {
        let blurEffect = UIBlurEffect(style: style)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        return blurredView
    }
    
}
