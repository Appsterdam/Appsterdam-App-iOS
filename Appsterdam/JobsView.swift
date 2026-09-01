//
//  JobsView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 13/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import MapKit
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

    @Model("https://appsterdam.rs/api/jobs.json")
    private var jobs: [JobsModel]

    var body: some View {
        NavigationView {
            List {
                Section(
                    footer: Text(.init("_Please note: this job data is coming from our friends._"))
                ) {
                    if $jobs.model != nil {
                        ForEach(jobs) { job in
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
                            .accessibilityLabel("Loading jobs")
                    }
                }
            } // /list
            .listStyle(.insetGrouped)
            .appGroupedBackground()
            .navigationTitle("Jobs")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await $jobs.update()
            }
            .onChange(of: jobs.count) { _ in
                Settings.shared.jobsCount = "\(jobs.count)"
            }
        } // /navigationview
        .navigationViewStyle(.stack)
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
        CardView(title: job.jobTitle, subtitle: job.jobProvider) {
            VStack {
                VStack {
                    Text(job.jobProvider ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)

                    if !job.jobPublishEndDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text("Apply Before: \(job.jobPublishEndDate)")
                            .font(.subheadline)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }

                    Text("Location: \(job.jobCity)")
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .allowsTightening(true)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )

                    CompactLocationMap(
                        locationName: job.jobCity,
                        searchQuery: job.jobCity
                    )
                }
                .padding()
                .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(.horizontal)

                ScrollView {
                    VStack {
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
                    .padding(.bottom, 40)
                }
            }
        }
        .overlay(alignment: .bottom) {
            Group {
                if #available(iOS 26.0, *) {
                    jobButton
                        .buttonStyle(.glass)
                } else {
                    jobButton
                        .buttonStyle(.borderedProminent)
                }
            }
            .controlSize(.large)
            .accessibilityLabel("View \(job.jobTitle) on the web")
            .accessibilityHint("Opens the job posting in Safari")
            .padding(.bottom)
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: $urlString)
        }
    }

    private var jobButton: some View {
        Button {
            urlString = job.jobURL
            showSafari = true
        } label: {
            Label(
                "View on Web",
                systemImage: "arrow.up.forward.app"
            )
            .font(.headline)
        }
    }
}

struct CompactMapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct CompactLocationMap: View {
    let locationName: String
    let searchQuery: String
    var coordinate: CLLocationCoordinate2D?

    @State private var location: CompactMapLocation?
    @State private var lookupFailed = false

    var body: some View {
        Group {
            if let location {
                Map(
                    coordinateRegion: .constant(region(around: location.coordinate)),
                    interactionModes: [],
                    annotationItems: [location]
                ) { location in
                    MapMarker(coordinate: location.coordinate)
                }
                .accessibilityLabel("Map of \(locationName)")
            } else if lookupFailed {
                Label("Map unavailable", systemImage: "map")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel("Map unavailable for \(locationName)")
            } else {
                ProgressView("Loading map")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel("Loading map for \(locationName)")
            }
        }
        .frame(height: 120)
        .background(Color(uiColor: .tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .task(id: searchQuery) {
            await loadLocation()
        }
    }

    private func region(around coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    }

    @MainActor
    private func loadLocation() async {
        location = nil
        lookupFailed = false

        if let coordinate, CLLocationCoordinate2DIsValid(coordinate) {
            location = CompactMapLocation(coordinate: coordinate)
            return
        }

        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            lookupFailed = true
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address

        do {
            let response = try await MKLocalSearch(request: request).start()
            try Task.checkCancellation()

            guard let coordinate = response.mapItems.first?.placemark.coordinate else {
                lookupFailed = true
                return
            }

            location = CompactMapLocation(coordinate: coordinate)
        } catch is CancellationError {
            return
        } catch {
            lookupFailed = true
        }
    }
}

struct JobView_Previews: PreviewProvider {
    static var previews: some View {
        JobView(job: Mock.jobs)
    }
}
