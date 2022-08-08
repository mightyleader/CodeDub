import Foundation
import UIKit

public enum KeywordType: Int
{
    case Focus
    case Track
}

public class KeywordBadge: UIView
{
    //MARK: Public Properties
    var keyword: String
    let keywordLabel = UILabel(frame: CGRect.zero)
    
    //MARK: Private Properties
    let keywordFocusColor = UIColor.orange
    let keywordTrackColor = UIColor.blue
    var type: KeywordType
    
    //MARK: Public Methods
    public init(keyword: String, type: KeywordType)
    {
        self.keyword = keyword
        self.keywordLabel.text = keyword
        self.type = type
        super.init(frame: CGRect.zero)
        self.setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        self.keyword = ""
        self.keywordLabel.text = keyword
        self.type = .Focus
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    //MARK: Private Methods
    private func setupViews() -> Void
    {
        self.addSubview(keywordLabel)
        keywordLabel.textColor = UIColor.white
        keywordLabel.textAlignment = .center
        keywordLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        keywordLabel.sizeToFit()
        
        let newSize = CGSize(width: keywordLabel.frame.width + 10,
                             height: keywordLabel.frame.height + 5)
        
        self.frame.size = newSize
        
        let newOrigin = CGPoint(x: 5, y: 2.5)
        keywordLabel.frame.origin = newOrigin
        
        self.backgroundColor = self.colorForType(type: self.type)
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    private func colorForType(type: KeywordType) -> UIColor
    {
        switch type {
        case .Focus:
            return self.keywordFocusColor
        default:
            return self.keywordTrackColor
        }
    }
}
