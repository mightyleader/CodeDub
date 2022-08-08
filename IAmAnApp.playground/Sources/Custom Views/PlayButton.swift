import Foundation
import UIKit

public class PlayButton: UIButton
{
    let constantFontSize: CGFloat  = 50.0
    let constantFrame = CGRect(x: 0,
                               y: 0,
                               width: 175.0,
                               height: 175.0)
    
    override init(frame: CGRect)
    {
        super.init(frame: constantFrame)
        
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(frame: constantFrame)
        
        self.setupView()
    }
    
    private func setupView() -> Void
    {
        let backingView = UIView(frame: constantFrame)
        backingView.layer.cornerRadius =  backingView.frame.height / 2
        self.addSubview(backingView)
        backingView.center = self.center

        self.titleLabel?.textAlignment = .center
        self.setTitleColor(UIColor.white, for: [])
        self.setTitleColor(UIColor.black, for: .highlighted)
        self.titleLabel?.font = UIFont.systemFont(ofSize: constantFontSize)
        self.setTitle("▶︎", for: [])
        self.isUserInteractionEnabled = true
    }
}
