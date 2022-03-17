//
//  Mock.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 17/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import Foundation

public class Mock {
    static let person = Person.init(
        name: "Person",
        picture: "https://appsterdam.rs/logo.png",
        function: "My Function",
        twitter: "myTwitter",
        linkedin: "myLinkedin",
        website: "https://appsterdam.rs/",
        bio: "Hello i'm myself."
    )

    static let jobs = JobsModel.init(
        JobUrl: "https://appsterdam.rs",
        JobTitle: "Fake Job",
        JobShortDescription: "Job Description (Short)",
        JobDescription: "Longer job descriptions <b>la</b><i>la</i><s>la</s>",
        JobCriteria: "Criteria",
        JobPublishStartDate: "2022-02-22",
        JobPublishEndDate: "2022-12-22",
        JobLocation: .init(JobLocationCity: "Amsterdam")
    )

    static let event = Event.init(
        id: "0",
        name: "preview",
        description: "preview string",
        price: "0",
        organizer: "Appsterdam",
        location_name: "Cafe Bax",
        location_address: "Kinkerstraat 119, 1053CC Amsterdam, Netherlands",
        date: "0:0",
        attendees: "2",
        icon: "star",
        latitude: "",
        longitude: ""
    )
}
