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
        SessionVideosService.fetchSessionsFromServer(completion: completionFunction)
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
                self.tableView.reloadData()
            }
        }
        else
        {
            print(error!.localizedDescription)
        }
    }
    
    //MARK: Datasource Methods
    
    public  func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        let sectionsCount = self.datasourceByYear.keys.count
        return sectionsCount
    }
    
    public  func tableView(tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int
    {
        let years = Array(self.datasourceByYear.keys)
        let year  = years[section]
        let sessionsByYear = self.datasourceByYear[year]
        return sessionsByYear!.count
    }
    
    public  func tableView(tableView: UITableView,
                                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell       = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath)
        
        let years = Array(self.datasourceByYear.keys)
        let year = years[indexPath.section]
        let datasource = self.datasourceByYear[year]
        let title      = datasource![indexPath.row].title

        cell.textLabel?.text = title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        
        return cell
    }
    
    public  func tableView(tableView: UITableView,
                                   titleForHeaderInSection section: Int) -> String?
    {
        let years = Array(self.datasourceByYear.keys)
        let sectionTitle = years[section]
        return sectionTitle
    }
    
    //MARK: Delegate Methods
    
    public  func tableView(tableView: UITableView,
                                   didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void
    {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let years = Array(self.datasourceByYear.keys)
        let sectionTitle = years[indexPath.section]
        
        let model = self.datasourceByYear[sectionTitle]![indexPath.row]

        let session = SessionViewController(WithModel: model)
        self.navigationController?.pushViewController(session, animated: true)

        
    }
    
    //MARK: Private setup methods

    func setupTableViews() -> Void
    {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.frame = viewFrame
    }
    
    func setupSubviews() -> Void
    {
        self.title = "WWDC Sessions"
    }
    
    func setupNavigation() -> Void
    {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
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
