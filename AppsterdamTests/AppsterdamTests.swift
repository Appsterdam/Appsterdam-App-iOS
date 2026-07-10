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

    func testEventUpdateDetectorFindsOnlyNewEvents() {
        let knownEvent = Mock.event
        var newEvent = Mock.event
        newEvent.id = "new-event"
        newEvent.name = "New Meetup"

        let sections = [
            EventModel(name: "Upcoming", events: [knownEvent, newEvent])
        ]

        let newEvents = EventUpdateDetector.newEvents(
            in: sections,
            knownEventIDs: [knownEvent.id]
        )

        XCTAssertEqual(newEvents.map(\.id), ["new-event"])
        XCTAssertEqual(EventUpdateDetector.eventIDs(in: sections), ["0", "new-event"])
    }

    func testEventUpdateDetectorNotificationCopy() {
        XCTAssertNil(EventUpdateDetector.notification(for: []))
        XCTAssertEqual(
            EventUpdateDetector.notification(for: [Mock.event])?.title,
            "New Appsterdam event"
        )
        XCTAssertEqual(
            EventUpdateDetector.notification(for: [Mock.event, Mock.event])?.title,
            "2 new Appsterdam events"
        )
    }

    func testEventDescriptionParserKeepsTextOnlyMarkdown() {
        let blocks = EventDescriptionParser.blocks(from: "**Hello** [Appsterdam](https://appsterdam.rs)")

        XCTAssertEqual(blocks, [
            .text("**Hello** [Appsterdam](https://appsterdam.rs)")
        ])
    }

    func testEventDescriptionParserExtractsImageTags() throws {
        let blocks = EventDescriptionParser.blocks(
            from: """
            **Before**
            <img alt="Venue photo" src="https://example.com/venue.jpg" />
            _After_
            """
        )

        XCTAssertEqual(blocks.count, 3)
        XCTAssertEqual(blocks.first, .text("**Before**"))
        XCTAssertEqual(blocks.last, .text("_After_"))

        guard case .image(let imageBlock) = blocks[1] else {
            return XCTFail("Expected image block")
        }

        XCTAssertEqual(imageBlock.url.absoluteString, "https://example.com/venue.jpg")
        XCTAssertEqual(imageBlock.altText, "Venue photo")
    }

    func testEventDescriptionParserSupportsSingleQuotedImageAttributes() throws {
        let blocks = EventDescriptionParser.blocks(
            from: "<img src='https://example.com/image.png' alt='Schedule'>"
        )

        guard case .image(let imageBlock) = blocks.first else {
            return XCTFail("Expected image block")
        }

        XCTAssertEqual(imageBlock.url.absoluteString, "https://example.com/image.png")
        XCTAssertEqual(imageBlock.altText, "Schedule")
    }
}
