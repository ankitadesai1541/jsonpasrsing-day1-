//
//  ViewController.swift
//  jsonparsing(day1)
//
//  Created by Student P_08 on 09/10/19.
//  Copyright © 2019 felix. All rights reserved.
//

import UIKit
class ViewController: UIViewController,UITableViewDataSource {
    var myarray = [String]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myarray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = myarray[indexPath.row]
        return cell
    }
    enum JsonErrors:Error{
        case dataError
        case conversionError
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseJson()
        print(myarray)
        // Do any additional setup after loading the view, typically from a nib.
    }
func ParseJson()
{
    let urlstring = "http://api.github.com/repositories/19438/commits"
    let url:URL = URL(string : urlstring)!
    let sessionConfigration = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfigration)
    let dataTask = session.dataTask(with: url) { (data, response, error) in
        do {
            guard let data = data
                else
            {
                throw JsonErrors.dataError
            }
           
            guard let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:Any]]
            else
            {
                throw JsonErrors.conversionError
            }
            for dic in array {
                let commitdic:[String:Any] = (dic["commit"] as? [String:Any])!
                let authordic:[String:Any] = (commitdic["author"] as? [String:Any])!
                let name:String = authordic["name"] as! String
                     self.myarray.append(name)
                print(name)
           
            }; if self.myarray.count>0
            {
                self.tableview.reloadData()
            }
        }
    
        
            catch JsonErrors.dataError
            {
                print("dataerror \(error?.localizedDescription)")
        }
        catch JsonErrors.conversionError
        {
            print("conversionerror \(error?.localizedDescription)")
        }
        catch let error {
             print(error.localizedDescription)
        }
    }
    dataTask.resume()
    
    }
    @IBOutlet weak var tableview: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

