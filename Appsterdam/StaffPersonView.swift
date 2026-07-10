//
//  StaffPersonView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 15/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import SwiftUI
import SwiftExtras

struct StaffPersonView: View {
    let person: Person

    var body: some View {
        CardView(title: person.name, subtitle: person.function) {
            ScrollView {
                VStack(spacing: 18) {
                    StaffProfileHeader(person: person)
                    StaffSocialLinks(person: person)
                    StaffBioCard(bio: person.bio)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private struct StaffProfileHeader: View {
    let person: Person

    var body: some View {
        VStack(spacing: 14) {
            StaffAvatar(person: person)

            VStack(spacing: 6) {
                Text(.init(person.name))
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text(.init(person.function))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(AppTheme.softAccent)
                        .frame(width: 132, height: 132)
                        .offset(x: 40, y: -48)
                }
        }
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct StaffAvatar: View {
    let person: Person

    var body: some View {
        Group {
            if let picture = person.picture, !picture.isEmpty, let pictureURL = URL(string: picture) {
                AsyncImage(url: pictureURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(AppTheme.accent.opacity(0.75))
                        .padding(18)
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(AppTheme.accent.opacity(0.75))
                    .padding(18)
            }
        }
        .frame(width: 142, height: 142)
        .background(.regularMaterial, in: Circle())
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(AppTheme.accent.opacity(0.18), lineWidth: 3)
        }
        .shadow(color: AppTheme.accent.opacity(0.18), radius: 16, y: 8)
        .accessibilityHidden(true)
    }
}

private struct StaffSocialLinks: View {
    let person: Person

    var body: some View {
        HStack(spacing: 12) {
            if let twitter = person.twitter, !twitter.isEmpty {
                StaffSocialButton(
                    title: "Twitter",
                    assetName: "twitter",
                    accessibilityLabel: "Open \(person.name) on Twitter"
                ) {
                    open("https://twitter.com/\(twitter)")
                }
            }

            if let linkedin = person.linkedin, !linkedin.isEmpty {
                StaffSocialButton(
                    title: "LinkedIn",
                    assetName: "linkedin",
                    accessibilityLabel: "Open \(person.name) on LinkedIn"
                ) {
                    open("https://linkedin.com/in/\(linkedin)")
                }
            }

            if let website = person.website, !website.isEmpty {
                StaffSocialButton(
                    title: "Website",
                    assetName: "globe",
                    accessibilityLabel: "Open \(person.name)'s website"
                ) {
                    open(website)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func open(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

private struct StaffSocialButton: View {
    let title: String
    let assetName: String
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 7) {
                Image(assetName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 22, height: 22)

                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

private struct StaffBioCard: View {
    let bio: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Biography", systemImage: "text.quote")
                .font(.headline)
                .foregroundStyle(.primary)

            Text(.init(bio))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.primary)
                .lineSpacing(3)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

struct StaffPersonView_Previews: PreviewProvider {
    static var previews: some View {
        StaffPersonView(
            person: Mock.person
        )
    }
}
