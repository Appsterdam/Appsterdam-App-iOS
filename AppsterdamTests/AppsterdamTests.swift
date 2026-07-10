//
//  AppsterdamTests.swift
//  AppsterdamTests
//
//  Created by Wesley de Groot on 23/01/2022.
//

import XCTest
@testable import Appsterdam

final class AppsterdamTests: XCTestCase {
    func testModelIdentityIsStable() {
        XCTAssertEqual(Mock.event.id, Mock.event.id)
        XCTAssertEqual(Mock.jobs.id, Mock.jobs.id)
        XCTAssertEqual(Mock.person.id, Mock.person.id)
        XCTAssertEqual(Mock.app.people[0].id, Mock.app.people[0].id)
    }

    func testEventDateFormatterParsesEventRange() {
        XCTAssertNotNil(EventDateFormatter.date(from: "20250101190000:20250101235959"))
        XCTAssertNil(EventDateFormatter.date(from: "invalid"))
        XCTAssertEqual(EventDateFormatter.string(from: "invalid"), "invalid")
    }

    func testEventDecodesServerKeys() throws {
        let data = Data(
            """
            {
              "id": "42",
              "name": "Meetup",
              "description": "Description",
              "price": "0",
              "organizer": "Appsterdam",
              "location_name": "Cafe",
              "location_address": "Street",
              "date": "20250101190000:20250101235959",
              "attendees": "10",
              "icon": "star",
              "latitude": "1",
              "longitude": "2"
            }
            """.utf8
        )

        let event = try JSONDecoder().decode(Event.self, from: data)

        XCTAssertEqual(event.locationName, "Cafe")
        XCTAssertEqual(event.locationAddress, "Street")
    }

    func testJobDecodesServerKeys() throws {
        let data = Data(
            """
            {
              "JobUrl": "https://example.com/job",
              "JobTitle": "iOS Engineer",
              "JobShortDescription": "Build apps",
              "JobDescription": "Build reliable apps",
              "JobCriteria": "Swift",
              "JobPublishStartDate": "2026-01-01",
              "JobPublishEndDate": "2026-02-01",
              "JobProvider": "Appsterdam",
              "JobCity": "Amsterdam"
            }
            """.utf8
        )

        let job = try JSONDecoder().decode(JobsModel.self, from: data)

        XCTAssertEqual(job.id, "https://example.com/job")
        XCTAssertEqual(job.jobTitle, "iOS Engineer")
    }
}
