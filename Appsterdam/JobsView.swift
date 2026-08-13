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
                    footer: Text(.init("_Please note: this job data is coming from our friends._"))
                ) {
                    if let loadedJobs = jobs.model {
                        ForEach(loadedJobs) { job in
                            Button {
                                selectedJob = job
                            } label: {
                                JobCell(job: job)
                            }
                            .buttonStyle(CellButtonStyle())
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                        }
                    } else {
                        ProgressView()
                            .controlSize(.large)
                            .frame(maxWidth: .infinity)
                    }
                }
            } // /list
            .listStyle(.insetGrouped)
            .appGroupedBackground()
            .navigationTitle("Jobs")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await jobs.update()
            }
            .onChange(of: jobs.model?.count) { _ in
                Settings.shared.jobsCount = "\(jobs.model?.count ?? 0)"
            }
        } // /navigationview
        .sheet(item: $selectedJob, content: JobView.init)
    }
}

private struct JobCell: View {
    let job: JobsModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "briefcase.fill")
                .font(.title3)
                .foregroundStyle(AppTheme.accent)
                .frame(width: 42, height: 42)
                .background(Color(uiColor: .tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 10) {
                Text(.init(job.jobTitle))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(.init(job.jobShortDescription))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                FlowingJobMetadata(job: job)
            }
        }
        .padding(14)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct FlowingJobMetadata: View {
    let job: JobsModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                JobMetadataChip(title: job.jobCity, systemImage: "mappin.and.ellipse")

                if let provider = job.jobProvider, !provider.isEmpty {
                    JobMetadataChip(title: provider, systemImage: "building.2")
                }
            }

            if !job.jobPublishEndDate.isEmpty {
                JobMetadataChip(title: "Apply by \(job.jobPublishEndDate)", systemImage: "calendar")
            }
        }
    }
}

private struct JobMetadataChip: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption)
            .lineLimit(1)
            .foregroundStyle(.secondary)

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
                }
                .padding()
                .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(.horizontal)

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
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .accessibilityHint("Opens the job posting in Safari")
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
