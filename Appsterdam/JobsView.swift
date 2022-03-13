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

    private let jobs = Model<JobsModel>.init(
        url: "https://appsterdam.rs/api/jobs.json"
    ).load()

    var body: some View {
        let _ = print(jobs)

        NavigationView {
            if let jobs = jobs {
                List(jobs) { job in
                    Text("Vacancy \(job.JobTitle)")
                }
            }
        }
    }
}

struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        JobsView()
    }
}
