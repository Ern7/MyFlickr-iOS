//
//  Constants.swift
//  MyFlickr
//
//  Created by Ernest Nyumbu on 2022/01/23.
//

import Foundation

struct Constants {
    
    struct AppConfig {
        static let BackendUrl = "https://www.flickr.com/";
        static let DEBUG_MODE = true;
    }

    struct ApiKeys {
        static let FlickrApiKey = "86c3624c7983deaacdd66a7ddc874b80";
    }
    
    struct Font {
        static let bold = "Montserrat-Bold";
        static let regular = "Montserrat-Regular";
        static let medium = "Montserrat-Medium";
        static let semiBold = "Montserrat-SemiBold";
        static let thin = "Montserrat-Thin";
    }
    
    struct AppPalette {
        static let primaryColor = "#A9A8FA";
        static let invisibleGrey = "#C1D2D8"
        static let pageBackgroundGrey = "#F8F8F8"
    }

}
