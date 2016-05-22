import UIKit
import XCPlayground

//: Allow the playground to continue to run in the background
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: *Constants*
let viewFrame = CGRect(x: 0, y: 0, width: 320, height: 600)

//: View Controller(s)
let simpleViewController = WWDCVideosViewController(style: .Grouped)
let simpleNavController	 = UINavigationController(rootViewController: simpleViewController)
simpleNavController.view.frame = viewFrame
simpleNavController.setToolbarHidden(false, animated: true)
simpleViewController.navigationController?.setToolbarHidden(true, animated: false)
simpleNavController.view

//: ***Assign the top-most view of the root view controller to the playgrounds live view...***
XCPlaygroundPage.currentPage.liveView = simpleNavController.view

//: [Next](@next)


