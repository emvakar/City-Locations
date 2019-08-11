//
//  ViewController.swift
//  Fetch Locations
//
//  Created by Emil Karimov on 09/08/2019.
//  Copyright © 2019 TAXCOM. All rights reserved.
//

import UIKit
import DevHelper
import AstrologyCalc
import SwiftyJSON

struct CityModel: Codable {
    var ruName: String
    var enName: String
    var lat: Double
    var lng: Double

    func getDict() -> [String: Any] {
        return ["ruName": self.ruName, "enName": self.enName, "lat": self.lat, "lng": self.lng]
    }
}


class ViewController: UIViewController {


    var cities = [CityModel]() {
        didSet {
            print(cities.count, " - ", cities.last?.ruName)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let fileManager = FileManager.default

        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = URL(string: documentsDirectoryPathString)!

        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("cities_coordinates.json")

        print(documentsDirectoryPathString)

        let baseManager = DataBaseManager()
        let countries = baseManager.makeCountriesFromJSON()

        var cc = [String]()

        let cities = countries.reduce([]) { (result, model) -> [DBCityModel] in
            return result + model.cities
        }


        for (city) in cities {
            cc.append(city.cityName)

            let name = city.cityName == "Астана" ? "Нур-Султан" : city.cityName
            let resp = Request.shared.fetchCity(name: name)
            if let result = resp.0 {
                let title = result.components.city ?? (result.components.state ?? result.components.country)
                if let city = title, let bounds = result.bounds {
                    let cityModel = CityModel(ruName: resp.1, enName: city, lat: bounds.northeast.lat, lng: bounds.northeast.lng)
                    self.cities.append(cityModel)
                } else {
                    print("error -", city.cityName)
                }
            } else {
                print("error - ", city.cityName)
            }

        }

        self.writeToDisk(path: jsonFilePath.absoluteString, manager: fileManager)

    }

    private func writeToDisk(path: String, manager: FileManager) {

        let js = self.cities.compactMap({ JSON($0.getDict()) })
        let str = JSON(js).description
        let data = str.data(using: .utf8)

        let _ = manager.createFile(atPath: path, contents: data, attributes: nil)
    }
}

