//
//  WeatherViewController.swift
//  joey_project
//
//  Created by T04-09 on 28/2/23.
//  Copyright © 2023 ITE. All rights reserved.
//

import UIKit
import CoreData

struct Weather: Codable {
    let coord: coordType
    struct coordType: Codable {
        let lon: Double?
        let lat: Double?
}
let weather: [resultsArray]
struct resultsArray: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}
let base: String?
let main: mainType
struct mainType: Codable {
    let temp: Double?
    let pressure: Int?
    let humidity: Int?
    let temp_min: Double?
    let temp_max: Double?
    }
    let visibility: Int?
    let wind: windType
    struct windType: Codable {
        let speed: Double?
        let deg: Int?
    }
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}

var newCredits: Int16 = 0

class WeatherViewController: UIViewController {
    var regArray = [User]()
    let app = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    @IBOutlet var weather_lbl: UILabel!
    @IBOutlet var detail_lbl: UILabel!
    @IBOutlet var delivery_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detail_lbl.text = "Thank you for making you purchase with us!"
        context = app.persistentContainer.viewContext
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Singapore,SG&appid=49d074a262bef23d8cb88073269bf0dc") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let decoder = JSONDecoder()
                let model = try decoder.decode(Weather.self, from: dataResponse)
        
                DispatchQueue.main.async {
                    self.weather_lbl.text =
                        "\(model.weather[0].description!)"
                    if model.weather[0].description! == "light rain" {
                        self.delivery_lbl.text = "Item will be delivered the next day."
                    } else {
                        self.delivery_lbl.text = "Item will be delivered today."
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
                }
            }
            task.resume()
        }
    
    @IBAction func home_btn(_ sender: UIButton) {
        do {
            let results = try context.fetch(User.fetchRequest())
            for result in results as! [User] {
                newCredits = (result.credits - Int16((finalPrice)))
                result.credits = newCredits
                try context.save()
                print(newCredits)
                print(finalPrice)
            }
        } catch {
            print(error)
        }
        performSegue(withIdentifier: "toHomePage", sender: nil)
    }
    
    @IBAction func logout_btn(_ sender: UIButton) {
        do {
            let results = try context.fetch(User.fetchRequest())
            for result in results as! [User] {
                newCredits = (result.credits - Int16((finalPrice)))
                result.credits = newCredits
                try context.save()
                print(newCredits)
                print(finalPrice)
            }
        } catch {
            print(error)
        }
         performSegue(withIdentifier: "toLoginPage", sender: nil)
    }
    // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


