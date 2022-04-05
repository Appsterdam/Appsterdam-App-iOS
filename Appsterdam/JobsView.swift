//
//  JobsView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 13/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import SwiftUI
import Aurora

struct JobsModel: Codable {
    var JobUrl: String
    var JobTitle: String
    var JobShortDescription: String
    var JobDescription: String
    var JobCriteria: String
    var JobPublishStartDate: String
    var JobPublishEndDate: String
    var JobProvider: String?
    var JobCity: String
}

extension JobsModel: Identifiable {
    var id: UUID {
        return UUID()
    }
}

struct JobsView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var showJob = false
    @State private var job: JobsModel = Mock.jobs

    @State private var searchText = ""

    private let jobs = Model<JobsModel>.init(
        url: "https://appsterdam.rs/api/jobs.json"
    ).loadArray()

    init() {
        if let jobs = jobs {
            Settings.shared.jobsCount = "\(jobs.count)"
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section(
                    footer:
                        Text(.init(
                            "_Please note: this job data is coming from our friends._"
                        ))
                ) {
                    if let jobs = jobs {
                        ForEach(jobs) { job in
                            VStack {
                                Text(.init(job.JobTitle))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.body)

                                Text(.init(job.JobShortDescription.decodeHTML()))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption2)
                                Spacer()
                                HStack {
                                    Text("📍 \(job.JobCity)")
                                        .font(.caption)
                                    Spacer()
                                    Text("🏠 \(job.JobProvider ?? "")")
                                        .font(.caption)
                                }
                            }.onTapGesture {
                                self.job = job
                                self.showJob = true
                            }
                        }
                    }
                }
            } // /list
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Jobs")
                            .font(.headline)
                        Text("For everyone who is creating.")
                            .font(.subheadline)
                    }
                }
            }
        } // /navigationview
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showJob, content: {
            JobView(job: $job)
        })
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
    @Binding var job: JobsModel

    var body: some View {
        CardView(title: job.JobTitle) {
            VStack {
                HStack {
                    VStack {
                        Text("Apply Before: \(job.JobPublishEndDate)")
                            .font(.subheadline)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )

                        Text("Location: \(job.JobCity)")
                            .font(.subheadline)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("\(job.JobProvider ?? "")\u{3000}")
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
                        Text(.init(job.JobDescription))
                            .font(.body)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }.padding(.horizontal)

                    GroupBox(label: Text("Criteria")) {
                        Text(.init(job.JobCriteria))
                            .font(.body)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }.padding(.horizontal)
                }

                GroupBox() {
                    Button ("View on Web") {
                        self.urlString = job.JobUrl
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
        JobView(job: .constant(Mock.jobs))
    }
}
