//
//  JobsView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 13/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import SwiftUI
import SwiftExtras

struct JobsModel: Codable, Equatable, Identifiable {
    var jobURL: String
    var jobTitle: String
    var jobShortDescription: String
    var jobDescription: String
    var jobCriteria: String
    var jobPublishStartDate: String
    var jobPublishEndDate: String
    var jobProvider: String?
    var jobCity: String

    var id: String { jobURL }

    enum CodingKeys: String, CodingKey {
        case jobURL = "JobUrl"
        case jobTitle = "JobTitle"
        case jobShortDescription = "JobShortDescription"
        case jobDescription = "JobDescription"
        case jobCriteria = "JobCriteria"
        case jobPublishStartDate = "JobPublishStartDate"
        case jobPublishEndDate = "JobPublishEndDate"
        case jobProvider = "JobProvider"
        case jobCity = "JobCity"
    }
}

struct JobsView: View {
    @State private var selectedJob: JobsModel?

    @StateObject private var jobs = Model<[JobsModel]>.init(
        url: "https://appsterdam.rs/api/jobs.json"
    )

    var body: some View {
        NavigationStack {
            List {
                Section(
                    footer:
                        Text(.init(
                            "_Please note: this job data is coming from our friends._"
                        ))
                ) {
                    if let loadedJobs = jobs.model {
                        ForEach(loadedJobs) { job in
                            Button {
                                selectedJob = job
                            } label: {
                                Text(.init(job.jobTitle))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.body)

                                Text(.init(job.jobShortDescription))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption2)
                                Spacer()
                                HStack {
                                    Text("📍 \(job.jobCity)")
                                        .font(.caption)
                                    Spacer()
                                    Text("🏠 \(job.jobProvider ?? "")")
                                        .font(.caption)
                                }
                            }
                            .buttonStyle(CellButtonStyle())
                        }
                    } else {
                        ProgressView()
                            .controlSize(.large)
                            .frame(maxWidth: .infinity)
                    }
                }
            } // /list
            .refreshable {
                await jobs.update()
            }
            .onChange(of: jobs.model?.count) { _ in
                Settings.shared.jobsCount = "\(jobs.model?.count ?? 0)"
            }
        } // /navigationview
        .navigationTitle("Jobs")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedJob, content: JobView.init)
    }
}

struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        JobsView()
    }
}

struct JobView: View {
    // whether or not to show the Safari ViewController
    @State private var showSafari = false

    // initial URL string
    @State private var urlString = "https://appsterdam.rs"

    // Which job are we showing
    let job: JobsModel

    var body: some View {
        CardView(title: job.jobTitle) {
            VStack {
                HStack {
                    VStack {
                        Text("Apply Before: \(job.jobPublishEndDate)")
                            .font(.subheadline)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )

                        Text("Location: \(job.jobCity)")
                            .font(.subheadline)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("\(job.jobProvider ?? "")\u{3000}")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.subheadline)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        Text("\u{3000}")
                    }
                }.padding(.horizontal)

                ScrollView {
                    GroupBox(label: Text("Description")) {
                        Text(.init(job.jobDescription))
                            .font(.body)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }.padding(.horizontal)

                    GroupBox(label: Text("Criteria")) {
                        Text(.init(job.jobCriteria))
                            .font(.body)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }.padding(.horizontal)
                }

                GroupBox {
                    Button("View on Web") {
                        self.urlString = job.jobURL
                        showSafari = true
                    }
                }
            }
        }
        .sheet(isPresented: $showSafari,
               content: {
            SafariView(url: $urlString)
        })
    }
}

struct JobView_Previews: PreviewProvider {
    static var previews: some View {
        JobView(job: Mock.jobs)
    }
}
