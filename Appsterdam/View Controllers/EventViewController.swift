//
//  EventViewController.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 21/01/2022.
//

import UIKit
import Aurora

struct event: Codable {
    var name: String
    var description: String
    var date: Date
    var attendees: Int
    var image: String
}

class EventViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    // Need to come from internet
    var sections = [
        "Upcoming",
        "Past",

        "2022","2021","2020","2019","2018","2017","2016","2015","2014","2013","2012"
    ];

    var fakeEvents = [
        event.init(name: "Weekly meeten & drinken", description: "Hap", date: .init(), attendees: 1, image: "🍺"),
        event.init(name: "Coffee coding", description: ".", date: .init(), attendees: 1, image: "laptopcomputer.and.iphone"),
        event.init(name: "Weekend fun", description: ".", date: .init(), attendees: 1, image: "star"),

        event.init(name: "Weekly meeten & drinken", description: "Hap", date: .init(), attendees: 1, image: "🍺"),
        event.init(name: "Coffee coding", description: ".", date: .init(), attendees: 1, image: "laptopcomputer.and.iphone"),
        event.init(name: "Weekend fun", description: ".", date: .init(), attendees: 1, image: "star"),

        event.init(name: "Weekly meeten & drinken", description: "Hap", date: .init(), attendees: 1, image: "🍺"),
        event.init(name: "Coffee coding", description: ".", date: .init(), attendees: 1, image: "laptopcomputer.and.iphone"),
        event.init(name: "Weekend fun", description: ".", date: .init(), attendees: 1, image: "star"),

        event.init(name: "ZOO", description: ".", date: .init(), attendees: 1, image: "🐘")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = "Events"

        tableView.delegate = self
        tableView.dataSource = self

        getData()
    }

    func getData() {
        // Get the data and reload.
        tableView.reloadData()
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Settings.shared.showSectionIndexTitles ? sections : nil
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Cell")

        var content = cell.defaultContentConfiguration()
        let event = fakeEvents[indexPath.row]

        if event.image.length > 2 {
            content.image = UIImage.init(systemName: event.image)
        } else {
            content.image = event.image.emojiToImage
        }

        content.text = event.name
        content.secondaryText = event.description

        cell.contentConfiguration = content


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
