import Foundation

struct RecipeSites {
    static let popular = [
        "https://allrecipes.com",
        "https://foodnetwork.com",
        "https://bonappetit.com",
        "https://epicurious.com",
        "https://food.com",
        "https://tasteofhome.com",
        "https://simplyrecipes.com",
        "https://thekitchn.com",
        "https://seriouseats.com",
        "https://delish.com",
        "https://cooking.nytimes.com",
        "https://foodandwine.com",
        "https://myrecipes.com",
        "https://eatingwell.com",
        "https://cookinglight.com"
    ]
    
    static let blogs = [
        "https://pinchofyum.com",
        "https://minimalistbaker.com",
        "https://budgetbytes.com",
        "https://skinnytaste.com",
        "https://halfbakedharvest.com",
        "https://damndelicious.net",
        "https://cafedelites.com",
        "https://therecipecritic.com",
        "https://gimmesomeoven.com",
        "https://cookieandkate.com"
    ]
    
    static let international = [
        "https://bbcgoodfood.com",           // British
        "https://jamieoliver.com",          // British
        "https://marmiton.org",             // French
        "https://giallozafferano.it",       // Italian
        "https://kochbar.de",               // German
        "https://cookpad.com"               // Japanese/Global
    ]
    
    static let all = popular + blogs + international
}
