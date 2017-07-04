//
//  CountryAlpha3Converter.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

/**
Provides a static mapping between country names and their alpha3 code.
*/
class CountryAlpha3Converter {
    static let countryToAlpha3: [String:String] = [
        "Aruba":"ABW",
        "Afghanistan":"AFG",
        "Angola":"AGO",
        "Anguilla":"AIA",
        "Åland Islands":"ALA",
        "Albania":"ALB",
        "Andorra":"AND",
        "United Arab Emirates":"ARE",
        "Argentina":"ARG",
        "Armenia":"ARM",
        "American Samoa":"ASM",
        "Antarctica":"ATA",
        "French Southern and Antarctic Lands":"ATF",
        "French Southern Territories":"ATF",
        "Antigua and Barbuda":"ATG",
        "Australia":"AUS",
        "Austria":"AUT",
        "Azerbaijan":"AZE",
        "Burundi":"BDI",
        "Belgium":"BEL",
        "Benin":"BEN",
        "Caribbean Netherlands":"BES",
        "Bonaire, Sint Eustatius and Saba":"BES",
        "Burkina Faso":"BFA",
        "Bangladesh":"BGD",
        "Bulgaria":"BGR",
        "Bahrain":"BHR",
        "The Bahamas":"BHS",
        "Bahamas":"BHS",
        "Bosnia and Herzegovina":"BIH",
        "Saint Barthélemy":"BLM",
        "Belarus":"BLR",
        "Belize":"BLZ",
        "Bermuda":"BMU",
        "Bolivia":"BOL",
        "Bolivia, Plurinational State of":"BOL",
        "Brazil":"BRA",
        "Barbados":"BRB",
        "Brunei":"BRN",
        "Brunei Darussalam":"BRN",
        "Bhutan":"BTN",
        "Bouvet Island":"BVT",
        "Botswana":"BWA",
        "Central African Republic":"CAF",
        "Canada":"CAN",
        "Cocos (Keeling) Islands":"CCK",
        "Switzerland":"CHE",
        "Chile":"CHL",
        "China":"CHN",
        "Ivory Coast":"CIV",
        "Côte d'Ivoire":"CIV",
        "Cameroon":"CMR",
        "Democratic Republic of the Congo":"COD",
        "Congo, the Democratic Republic of the":"COD",
        "Republic of the Congo":"COG",
        "Congo":"COG",
        "Cook Islands":"COK",
        "Colombia":"COL",
        "Comoros":"COM",
        "Cabo Verde":"CPV",
        "Costa Rica":"CRI",
        "Cuba":"CUB",
        "Curaçao":"CUW",
        "Christmas Island":"CXR",
        "Cayman Islands":"CYM",
        "Cyprus":"CYP",
        "Czech Republic":"CZE",
        "Germany":"DEU",
        "Djibouti":"DJI",
        "Dominica":"DMA",
        "Denmark":"DNK",
        "Dominican Republic":"DOM",
        "Algeria":"DZA",
        "Ecuador":"ECU",
        "Egypt":"EGY",
        "Eritrea":"ERI",
        "Western Sahara":"ESH",
        "Spain":"ESP",
        "Estonia":"EST",
        "Ethiopia":"ETH",
        "Finland":"FIN",
        "Fiji":"FJI",
        "Falkland Islands":"FLK",
        "Falkland Islands (Malvinas)":"FLK",
        "France":"FRA",
        "Faroe Islands":"FRO",
        "Federated States of Micronesia":"FSM",
        "Micronesia, Federated States of":"FSM",
        "Gabon":"GAB",
        "United Kingdom":"GBR",
        "Georgia (country)":"GEO",
        "Georgia":"GEO",
        "Guernsey":"GGY",
        "GHA":"Ghana",
        "Gibraltar":"GIB",
        "Guinea":"GIN",
        "Guadeloupe":"GLP",
        "The Gambia":"GMB",
        "Gambia":"GMB",
        "Guinea-Bissau":"GNB",
        "Equatorial Guinea":"GNQ",
        "Greece":"GRC",
        "Grenada":"GRD",
        "Greenland":"GRL",
        "Guatemala":"GTM",
        "French Guiana":"GUF",
        "Guam":"GUM",
        "Guyana":"GUY",
        "Hong Kong":"HKG",
        "Heard Island and McDonald Islands":"HMD",
        "Honduras":"HND",
        "Croatia":"HRV",
        "Haiti":"HTI",
        "Hungary":"HUN",
        "Indonesia":"IDN",
        "Isle of Man":"IMN",
        "India":"IND",
        "British Indian Ocean Territory":"IOT",
        "Republic of Ireland":"IRL",
        "Ireland":"IRL",
        "Iran":"IRN",
        "Iran, Islamic Republic of":"IRN",
        "Iraq":"IRQ",
        "Iceland":"ISL",
        "Israel":"ISR",
        "Italy":"ITA",
        "Jamaica":"JAM",
        "Jersey":"JEY",
        "Jordan":"JOR",
        "Japan":"JPN",
        "Kazakhstan":"KAZ",
        "Kenya":"KEN",
        "Kyrgyzstan":"KGZ",
        "Cambodia":"KHM",
        "Kiribati":"KIR",
        "Saint Kitts and Nevis":"KNA",
        "South Korea":"KOR",
        "Korea, Republic of":"KOR",
        "Kuwait":"KWT",
        "Laos":"LAO",
        "Lao People's Democratic Republic":"LAO",
        "Lebanon":"LBN",
        "Liberia":"LBR",
        "Libya":"LBY",
        "Saint Lucia":"LCA",
        "Liechtenstein":"LIE",
        "Sri Lanka":"LKA",
        "Lesotho":"LSO",
        "Lithuania":"LTU",
        "Luxembourg":"LUX",
        "Latvia":"LVA",
        "Macau":"MAC",
        "Macao":"MAC",
        "Collectivity of Saint Martin":"MAF",
        "Saint Martin (French part)":"MAF",
        "Morocco":"MAR",
        "Monaco":"MCO",
        "Moldova":"MDA",
        "Moldova, Republic of":"MDA",
        "Madagascar":"MDG",
        "Maldives":"MDV",
        "Mexico":"MEX",
        "Marshall Islands":"MHL",
        "Republic of Macedonia":"MHL",
        "Macedonia, the former Yugoslav Republic of":"MKD",
        "Mali":"MLI",
        "Malta":"MLT",
        "Myanmar":"MMR",
        "Montenegro":"MNE",
        "Mongolia":"MNG",
        "Northern Mariana Islands":"MNP",
        "Mozambique":"MOZ",
        "Mauritania":"MRT",
        "Montserrat":"MSR",
        "Martinique":"MTQ",
        "Mauritius":"MUS",
        "Malawi":"MWI",
        "Malaysia":"MYS",
        "Mayotte":"MYT",
        "Namibia":"NAM",
        "New Caledonia":"NCL",
        "Niger":"NER",
        "Norfolk Island":"NFK",
        "Nigeria":"NGA",
        "Nicaragua":"NIC",
        "Niue":"NIU",
        "Netherlands":"NLD",
        "Norway":"NOR",
        "Nepal":"NPL",
        "Nauru":"NRU",
        "New Zealand":"NZL",
        "Oman":"OMN",
        "Pakistan":"PAK",
        "Panama":"PAN",
        "Pitcairn Islands":"PCN",
        "Pitcairn":"PCN",
        "Peru":"PER",
        "Philippines":"PHL",
        "Palau":"PLW",
        "Papua New Guinea":"PNG",
        "Poland":"POL",
        "Puerto Rico":"PRI",
        "North Korea":"PRK",
        "Korea, Democratic People's Republic of":"PRK",
        "Portugal":"PRT",
        "Paraguay":"PRY",
        "State of Palestine":"PSE",
        "Palestine, State of":"PSE",
        "French Polynesia":"PYF",
        "Qatar":"QAT",
        "Réunion":"REU",
        "Romania":"ROU",
        "Russia":"RUS",
        "Russian Federation":"RUS",
        "Rwanda":"RWA",
        "Saudi Arabia":"SAU",
        "Sudan":"SDN",
        "Senegal":"SEN",
        "Singapore":"SGP",
        "South Georgia and the South Sandwich Islands":"SGS",
        "Saint Helena, Ascension and Tristan da Cunha":"SHN",
        "Svalbard and Jan Mayen":"SJM",
        "Solomon Islands":"SLB",
        "Sierra Leone":"SLE",
        "El Salvador":"SLV",
        "San Marino":"SMR",
        "Somalia":"SOM",
        "Saint Pierre and Miquelon":"SPM",
        "Serbia":"SRB",
        "South Sudan":"SSD",
        "São Tomé and Príncipe":"STP",
        "Sao Tome and Principe":"STP",
        "Suriname":"SUR",
        "Slovakia":"SVK",
        "Slovenia":"SVN",
        "Sweden":"SWE",
        "Swaziland":"SWZ",
        "Sint Maarten":"SXM",
        "Sint Maarten (Dutch part)":"SXM",
        "Seychelles":"SYC",
        "Syria":"SYR",
        "Syrian Arab Republic":"SYR",
        "Turks and Caicos Islands":"TCA",
        "Chad":"TCD",
        "Togo":"TGO",
        "Thailand":"THA",
        "Tajikistan":"TJK",
        "Tokelau":"TKL",
        "Turkmenistan":"TKM",
        "East Timor":"TLS",
        "Timor-Leste":"TLS",
        "Tonga":"TON",
        "Trinidad and Tobago":"TTO",
        "Tunisia":"TUN",
        "Turkey":"TUR",
        "Tuvalu":"TUV",
        "Taiwan":"TWN",
        "Taiwan, Province of China":"TWN",
        "Tanzania":"TZA",
        "Tanzania, United Republic of":"TZA",
        "Uganda":"UGA",
        "Ukraine":"UKR",
        "United States Minor Outlying Islands":"UMI",
        "Uruguay":"URY",
        "United States of America":"USA",
        "Uzbekistan":"UZB",
        "Vatican City":"VAT",
        "Holy See (Vatican City State)":"VAT",
        "Saint Vincent and the Grenadines":"VCT",
        "Venezuela":"VEN",
        "Venezuela, Bolivarian Republic of":"VEN",
        "British Virgin Islands":"VGB",
        "Virgin Islands, British":"VGB",
        "United States Virgin Islands":"VIR",
        "Virgin Islands, U.S.":"VIR",
        "Vietnam":"VNM",
        "Viet Nam":"VNM",
        "Vanuatu":"VUT",
        "Wallis and Futuna":"WLF",
        "Samoa":"WSM",
        "Yemen":"YEM",
        "South Africa":"ZAF",
        "Zambia":"ZMB",
        "Zimbabwe":"ZWE"
    ]
    
    static func getAlpha3ForCountry(_ country:String)->String? {
        return countryToAlpha3[country]
    }
    
    static func getCountryForAlpha3(_ alpha3:String)->String? {
        if let index = countryToAlpha3.values.index(of: alpha3) {
            return countryToAlpha3.keys[index]
        } else {
            return nil
        }
    }
}
