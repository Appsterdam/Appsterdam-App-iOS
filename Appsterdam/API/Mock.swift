//
//  Mock.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 17/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import Foundation

public class Mock {
    static let app = AppModel.init(
        home: """
                **[Join the community](https://appsterdam.rs/join-community/)**
                We are 4,500 members of makers, designers and developers.
                App makers helping app makers -  come join our community!

                **[Collaborate](https://appsterdam.rs/collaborate/)**
                Do you have an SDK, API or plugin that you want to share with Appsterdamers?
                Contact us if you want to host a workshop or guru session.

                **[Share a project](https://appsterdam.rs/shared-projects/)**
                Our members are always developing new projects, products and solutions.
                Check out the projects they are most proud of here.
                """,

                people: [
                    .init(
                        team: "FakeTeam",
                        members: [Mock.person]
                    )
                ]
    )

    static let person = Person.init(
        name: "Person",
        picture: "https://appsterdam.rs/wp-content/uploads/2022/01/cropped-Appsterdam-Logo-512x512-2.png",
        function: "My Function",
        twitter: "myTwitter",
        linkedin: "myLinkedin",
        website: "https://appsterdam.rs/",
        bio: "Hello i'm *myself*, and this ~text~,\r\ncontaining _mark_**down**. and a [Link](https://appsterdam.rs)"
    )

    static let jobs = JobsModel.init(
        JobUrl: "https://appsterdam.rs",
        JobTitle: "Fake Job",
        JobShortDescription: "Job Description (Short)",
        JobDescription: "Longer job descriptions <b>la</b><i>la</i><s>la</s>",
        JobCriteria: "Criteria",
        JobPublishStartDate: "2022-02-22",
        JobPublishEndDate: "2022-12-22",
        JobProvider: "Wesley de Groot 🤪",
        JobCity: "Appsterdam"
    )

    static let event = Event.init(
        id: "0",
        name: "Weekly Meeten & Drinken",
        description: "Weekly Meeten & Drinken, Weekly Meeten & Drinken, Weekly Meeten",
        price: "0",
        organizer: "Appsterdam",
        location_name: "Cafe Bax",
        location_address: "Kinkerstraat 119, 1053CC Amsterdam, Netherlands",
        date: "20250101190000:20250101235959",
        attendees: "2",
        icon: "star",
        latitude: "",
        longitude: ""
    )
}
