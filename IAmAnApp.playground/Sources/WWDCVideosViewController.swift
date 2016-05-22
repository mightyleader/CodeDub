import Foundation
import UIKit

public class WWDCVideosViewController: UITableViewController
{
	//MARK: Public Properties
	
	public let reuseIdentifier = "WWDCSessionVideoCellID"
	
	//MARK: Private Properties

	let viewFrame = CGRect(x: 0, y: 0, width: 320, height: 568)
	var jsonDatasource: [SessionVideoModel] = []
    var datasourceByYear: Dictionary<String, [SessionVideoModel]> = [:]
	
	//MARK: View Lifecycle Methods
	
	override public func viewDidLoad() -> Void
	{
        super.viewDidLoad()
		self.setupTableViews()
		self.setupSubviews()
        self.setupNavigation()
        self.fetchData()
	}
	
    //MARK: Data fetching Functions
    
    func fetchData() -> Void
    {
        let completionFunction = self.fetchCompletion
        SessionVideosService.fetchSessionsFromServer(completionFunction)
    }

    func fetchCompletion(sessionObject: [SessionVideoModel]?, error: NSError?) -> Void
    {
        if (error == nil)
        {
            if let sessions = sessionObject
            {
                let years = Array(WWDCVideosViewController.setOfYears(FromSessions: sessions))
                let sessionsByYear = years.map({
                    (year: String) -> [SessionVideoModel] in
                    let byYear = WWDCVideosViewController.arrayOf(Sessions: sessions, forYear: year)
                    return byYear
                })
                
                for (key, value) in zip(years, sessionsByYear) {
                    self.datasourceByYear[key] = value
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
        else
        {
            print(error!.localizedDescription)
        }
    }
	
	//MARK: Datasource Methods
	
	public override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
        let sectionsCount = self.datasourceByYear.keys.count
		return sectionsCount
	}
	
	public override func tableView(tableView: UITableView,
	                               numberOfRowsInSection section: Int) -> Int
	{
        let years = Array(self.datasourceByYear.keys)
        let year  = years[section]
        let sessionsByYear = self.datasourceByYear[year]
		return sessionsByYear!.count
	}
	
	public override func tableView(tableView: UITableView,
	                               cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell       = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let years = Array(self.datasourceByYear.keys)
        let year = years[indexPath.section]
        let datasource = self.datasourceByYear[year]
        let title      = datasource![indexPath.row].title

        cell.textLabel?.text = title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .ByWordWrapping
		cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
		
		return cell
	}
    
    public override func tableView(tableView: UITableView,
                                   titleForHeaderInSection section: Int) -> String?
    {
        let years = Array(self.datasourceByYear.keys)
        let sectionTitle = years[section]
        return sectionTitle
    }
	
	//MARK: Delegate Methods
	
	public override func tableView(tableView: UITableView,
	                               didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void
	{
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let years = Array(self.datasourceByYear.keys)
        let sectionTitle = years[indexPath.section]
        
        let model = self.datasourceByYear[sectionTitle]![indexPath.row]

        let session = SessionViewController(WithModel: model)
        self.navigationController?.pushViewController(session, animated: true)

        
	}
    
    //MARK: Private setup methods

    func setupTableViews() -> Void
    {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.frame = viewFrame
    }
    
    func setupSubviews() -> Void
    {
        self.title = "WWDC Sessions"
    }
    
    func setupNavigation() -> Void
    {
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    //MARK: Private class methods
    
    private class func setOfYears(FromSessions sessions: [SessionVideoModel]) -> Set<String>
    {
        let arrayOfYears = sessions.map({
            (session: SessionVideoModel) -> String in
            return session.dateString
        })
        return Set(arrayOfYears)
    }
    
    private class func arrayOf(Sessions sessions: [SessionVideoModel], forYear year: String) -> [SessionVideoModel]
    {
        return sessions.filter({ (session: SessionVideoModel) -> Bool in
            session.dateString == year
        })
    }
	
}