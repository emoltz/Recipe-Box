import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    
    @State private var isScrapingInProgress = false
    @State private var scrapingStatus = "Ready to scrape"
    @State private var scrapedCount = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Recipe Box Scraper")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Found \(recipes.count) recipes")
                .font(.headline)
            
            Text(scrapingStatus)
                .foregroundColor(isScrapingInProgress ? .blue : .primary)
            
            if scrapedCount > 0 {
                Text("Scraped \(scrapedCount) new recipes")
                    .foregroundColor(.green)
            }
            
            Button("Start Scraping!") {
                Task {
                    await startScraping()
                }
            }
            .disabled(isScrapingInProgress)
            .buttonStyle(.borderedProminent)
            
            if isScrapingInProgress {
                ProgressView()
                    .scaleEffect(1.2)
            }
        }
        .padding()
    }
    
    private func startScraping() async {
        isScrapingInProgress = true
        scrapingStatus = "Initializing scraper..."
        scrapedCount = 0
        
        do {
            let scraper = await WebScraperAgent()
            scrapingStatus = "Crawling recipe sites..."
            
            let newRecipes = try await scraper.crawlRecipeSites()
            
            scrapingStatus = "Saving recipes to database..."
            
            // Save to SwiftData
            for recipe in newRecipes {
                // Check for duplicates by URL
                let existingRecipe = recipes.first { $0.sourceURL == recipe.sourceURL }
                if existingRecipe == nil {
                    modelContext.insert(recipe)
                    scrapedCount += 1
                }
            }
            
            try modelContext.save()
            scrapingStatus = "Scraping completed! Found \(newRecipes.count) pages"
            
        } catch {
            scrapingStatus = "Error: \(error.localizedDescription)"
        }
        
        isScrapingInProgress = false
    }
}

#Preview {
    ContentView()
        
}
