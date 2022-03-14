//
//  JobsView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 13/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import SwiftUI

struct JobCompanyModel: Codable {

}

struct JobLocationModel: Codable {
    var JobLocationCity: String
}

struct JobsModel: Codable {
    var JobUrl: String
    var JobTitle: String
    var JobShortDescription: String
    var JobDescription: String
    var JobCriteria: String
    var JobPublishStartDate: String
    var JobPublishEndDate: String
    var JobLocation: JobLocationModel
}

extension JobsModel: Identifiable {
    var id: UUID {
        return UUID()
    }
}

struct JobsView: View {
    // whether or not to show the Safari ViewController
    @State private var showSafari = false

    // initial URL string
    @State private var urlString = "https://appsterdam.rs"

    @State private var searchText = ""

    private let jobs = Model<JobsModel>.init(
        url: "https://appsterdam.rs/api/jobs.json"
    ).load()

    var body: some View {
        let nav = NavigationView {
            if let jobs = jobs {
                List {
                    Section(footer: Text("Please note: this job data is coming from our friends the house of appril.")) {
                    ForEach(jobs) { job in
                        VStack {
                            Text("\(job.JobTitle)")
                                .font(.body)

                            Text("\(job.JobShortDescription)")
                                .font(.caption2)

                            Text("📍 \(job.JobLocation.JobLocationCity), enddate: \(job.JobPublishEndDate)")
                                .font(.caption)
                        }.onTapGesture {
                            print("OpenView for:")
                            print(job)
                        }
                    }
                    }
                }
                .navigationTitle("Jobs @ The house of appril")
            }
        }

        if #available(iOS 15.0, *) {
            nav.searchable(text: $searchText)
        } else {
            nav.unredacted()
        }
    }
}

struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        JobsView()
    }
}
