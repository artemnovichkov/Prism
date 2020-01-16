//
//  AssetIdentitySpec.swift
//  PrismTests
//
//  Created by Shai Mishali on 23/05/2019.
//  Copyright © 2019 Gett. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import PrismCore
@testable import ZeplinAPI

class AssetIdentitySpec: QuickSpec {
    let project = try! Prism(jwtToken: "fake").mock(type: .successful).get()

    override func spec() {
        describe("raw identities") {
            let rawIdentities = [
                "A great color",
                "Sky Red",
                "Title M Regular",
                "Accent Blue",
                "PrimaryRed",
                "My Color 2",
                "My Color3",
                "My-Awesome_Color"
            ].map(Project.AssetIdentity.init)

            context("camel case") {
                it("should return camel-cased identities") {
                    let expectedIdentities = [
                        "aGreatColor",
                        "skyRed",
                        "titleMRegular",
                        "accentBlue",
                        "primaryRed",
                        "myColor2",
                        "myColor3",
                        "myAwesomeColor"
                    ]

                    let processedIdentities = rawIdentities.map { Project.AssetIdentity.Style.camelcase.identifier(for: $0) }
                    expect(processedIdentities) == expectedIdentities
                }
            }

            context("snake case") {
                it("should return lowercased identities with underscores") {
                    let expectedIdentities = [
                        "a_great_color",
                        "sky_red",
                        "title_m_regular",
                        "accent_blue",
                        "primary_red",
                        "my_color_2",
                        "my_color3",
                        "my_awesome_color"
                    ]

                    let processedIdentities = rawIdentities.map { Project.AssetIdentity.Style.snakecase.identifier(for: $0) }
                    expect(processedIdentities) == expectedIdentities
                }
            }
        }

        describe("color identities") {
            context("camel case") {
                it("should return valid identities") {
                    let expectedIdentities = ["blueSky", "clearReddish"]
                    let proccessedIdentities = self.project.colors.map { Project.AssetIdentity.Style.camelcase.identifier(for: $0.identity) }

                    expect(proccessedIdentities) == expectedIdentities
                }
            }

            context("snake case") {
                it("should return valid identities") {
                    let expectedIdentities = ["blue_sky", "clear_reddish"]
                    let proccessedIdentities = self.project.colors.map { Project.AssetIdentity.Style.snakecase.identifier(for: $0.identity) }

                    expect(proccessedIdentities) == expectedIdentities
                }
            }
        }

        describe("text style identities") {
            context("camel case") {
                it("should return valid identities") {
                    let expectedIdentities = ["body", "largeHeading"]
                    let proccessedIdentities = self.project.textStyles.map { Project.AssetIdentity.Style.camelcase.identifier(for: $0.identity) }

                    expect(proccessedIdentities) == expectedIdentities
                }
            }

            context("snake case") {
                it("should return valid identities") {
                    let expectedIdentities = ["body", "large_heading"]
                    let proccessedIdentities = self.project.textStyles.map { Project.AssetIdentity.Style.snakecase.identifier(for: $0.identity) }

                    expect(proccessedIdentities) == expectedIdentities
                }
            }
        }
        
        describe("empty identity") {
            it("should return empty identities") {
                let identity = Project.AssetIdentity(name: "")
                
                let all = Project.AssetIdentity.Style.allCases.map { $0.identifier(for: identity) }
                expect(all) == ["", "", ""]
            }
        }
    }
}
