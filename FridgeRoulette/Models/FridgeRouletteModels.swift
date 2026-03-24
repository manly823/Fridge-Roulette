import SwiftUI

// MARK: - Enums

enum MealType: String, Codable, CaseIterable, Identifiable {
    case breakfast, lunch, dinner, snack, dessert
    var id: String { rawValue }
    var name: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        case .dessert: return "Dessert"
        }
    }
    var emoji: String {
        switch self {
        case .breakfast: return "🌅"
        case .lunch: return "☀️"
        case .dinner: return "🌙"
        case .snack: return "🍿"
        case .dessert: return "🍰"
        }
    }
    var color: Color {
        switch self {
        case .breakfast: return Theme.warm
        case .lunch: return Theme.success
        case .dinner: return Theme.accent
        case .snack: return Theme.secondary
        case .dessert: return Theme.info
        }
    }
}

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case easy, medium, hard
    var id: String { rawValue }
    var name: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
    var color: Color {
        switch self {
        case .easy: return Theme.success
        case .medium: return Theme.warm
        case .hard: return Theme.accent
        }
    }
}

enum IngCategory: String, CaseIterable, Identifiable {
    case produce, dairy, meat, seafood, pantry, grains, spices
    var id: String { rawValue }
    var name: String {
        switch self {
        case .produce: return "Produce"
        case .dairy: return "Dairy & Eggs"
        case .meat: return "Meat"
        case .seafood: return "Seafood"
        case .pantry: return "Pantry"
        case .grains: return "Grains"
        case .spices: return "Spices"
        }
    }
    var emoji: String {
        switch self {
        case .produce: return "🥬"
        case .dairy: return "🥛"
        case .meat: return "🥩"
        case .seafood: return "🐟"
        case .pantry: return "🫙"
        case .grains: return "🌾"
        case .spices: return "🧂"
        }
    }
}

// MARK: - Fridge Item

struct FridgeItem: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let emoji: String
    init(name: String, emoji: String) { self.id = UUID(); self.name = name; self.emoji = emoji }
    static func == (lhs: FridgeItem, rhs: FridgeItem) -> Bool { lhs.name.lowercased() == rhs.name.lowercased() }
    func hash(into hasher: inout Hasher) { hasher.combine(name.lowercased()) }
}

// MARK: - Ingredient Catalog

struct IngInfo {
    let name: String; let emoji: String; let cat: IngCategory
}

let ingredientCatalog: [IngInfo] = [
    // Produce
    IngInfo(name: "tomato", emoji: "🍅", cat: .produce),
    IngInfo(name: "onion", emoji: "🧅", cat: .produce),
    IngInfo(name: "garlic", emoji: "🧄", cat: .produce),
    IngInfo(name: "lettuce", emoji: "🥬", cat: .produce),
    IngInfo(name: "avocado", emoji: "🥑", cat: .produce),
    IngInfo(name: "potato", emoji: "🥔", cat: .produce),
    IngInfo(name: "carrot", emoji: "🥕", cat: .produce),
    IngInfo(name: "cucumber", emoji: "🥒", cat: .produce),
    IngInfo(name: "banana", emoji: "🍌", cat: .produce),
    IngInfo(name: "apple", emoji: "🍎", cat: .produce),
    IngInfo(name: "lemon", emoji: "🍋", cat: .produce),
    IngInfo(name: "lime", emoji: "🟢", cat: .produce),
    IngInfo(name: "mushrooms", emoji: "🍄", cat: .produce),
    IngInfo(name: "bell pepper", emoji: "🫑", cat: .produce),
    IngInfo(name: "celery", emoji: "🥬", cat: .produce),
    IngInfo(name: "berries", emoji: "🫐", cat: .produce),
    IngInfo(name: "basil", emoji: "🌿", cat: .produce),
    IngInfo(name: "cilantro", emoji: "🌱", cat: .produce),
    IngInfo(name: "green onion", emoji: "🧅", cat: .produce),
    IngInfo(name: "spinach", emoji: "🥬", cat: .produce),
    IngInfo(name: "broccoli", emoji: "🥦", cat: .produce),
    IngInfo(name: "corn", emoji: "🌽", cat: .produce),
    IngInfo(name: "olives", emoji: "🫒", cat: .produce),
    IngInfo(name: "ginger", emoji: "🫚", cat: .produce),
    IngInfo(name: "jalapeño", emoji: "🌶️", cat: .produce),
    // Dairy & Eggs
    IngInfo(name: "eggs", emoji: "🥚", cat: .dairy),
    IngInfo(name: "milk", emoji: "🥛", cat: .dairy),
    IngInfo(name: "butter", emoji: "🧈", cat: .dairy),
    IngInfo(name: "cheese", emoji: "🧀", cat: .dairy),
    IngInfo(name: "cream", emoji: "🫙", cat: .dairy),
    IngInfo(name: "yogurt", emoji: "🥛", cat: .dairy),
    IngInfo(name: "mozzarella", emoji: "🧀", cat: .dairy),
    IngInfo(name: "parmesan", emoji: "🧀", cat: .dairy),
    IngInfo(name: "feta", emoji: "🧀", cat: .dairy),
    IngInfo(name: "sour cream", emoji: "🫙", cat: .dairy),
    // Meat
    IngInfo(name: "chicken", emoji: "🍗", cat: .meat),
    IngInfo(name: "ground beef", emoji: "🥩", cat: .meat),
    IngInfo(name: "bacon", emoji: "🥓", cat: .meat),
    IngInfo(name: "steak", emoji: "🥩", cat: .meat),
    IngInfo(name: "sausage", emoji: "🌭", cat: .meat),
    // Seafood
    IngInfo(name: "salmon", emoji: "🐟", cat: .seafood),
    IngInfo(name: "shrimp", emoji: "🦐", cat: .seafood),
    IngInfo(name: "tuna", emoji: "🐟", cat: .seafood),
    // Pantry
    IngInfo(name: "flour", emoji: "🫙", cat: .pantry),
    IngInfo(name: "sugar", emoji: "🫙", cat: .pantry),
    IngInfo(name: "salt", emoji: "🧂", cat: .pantry),
    IngInfo(name: "pepper", emoji: "🫙", cat: .pantry),
    IngInfo(name: "olive oil", emoji: "🫒", cat: .pantry),
    IngInfo(name: "soy sauce", emoji: "🫙", cat: .pantry),
    IngInfo(name: "honey", emoji: "🍯", cat: .pantry),
    IngInfo(name: "vinegar", emoji: "🫙", cat: .pantry),
    IngInfo(name: "mayo", emoji: "🫙", cat: .pantry),
    IngInfo(name: "peanut butter", emoji: "🥜", cat: .pantry),
    IngInfo(name: "chocolate", emoji: "🍫", cat: .pantry),
    IngInfo(name: "vanilla", emoji: "🫙", cat: .pantry),
    IngInfo(name: "coconut milk", emoji: "🥥", cat: .pantry),
    IngInfo(name: "chickpeas", emoji: "🫙", cat: .pantry),
    IngInfo(name: "tahini", emoji: "🫙", cat: .pantry),
    IngInfo(name: "salsa", emoji: "🫙", cat: .pantry),
    IngInfo(name: "nuts", emoji: "🥜", cat: .pantry),
    IngInfo(name: "peanuts", emoji: "🥜", cat: .pantry),
    IngInfo(name: "canned tomato", emoji: "🥫", cat: .pantry),
    IngInfo(name: "baking powder", emoji: "🫙", cat: .pantry),
    // Grains
    IngInfo(name: "rice", emoji: "🍚", cat: .grains),
    IngInfo(name: "pasta", emoji: "🍝", cat: .grains),
    IngInfo(name: "bread", emoji: "🍞", cat: .grains),
    IngInfo(name: "oats", emoji: "🥣", cat: .grains),
    IngInfo(name: "tortilla", emoji: "🫓", cat: .grains),
    IngInfo(name: "noodles", emoji: "🍜", cat: .grains),
    IngInfo(name: "tortilla chips", emoji: "🫓", cat: .grains),
    IngInfo(name: "granola", emoji: "🥣", cat: .grains),
    // Spices
    IngInfo(name: "cinnamon", emoji: "🫙", cat: .spices),
    IngInfo(name: "curry powder", emoji: "🫙", cat: .spices),
    IngInfo(name: "cumin", emoji: "🫙", cat: .spices),
    IngInfo(name: "paprika", emoji: "🫙", cat: .spices),
    IngInfo(name: "oregano", emoji: "🌿", cat: .spices),
    IngInfo(name: "rosemary", emoji: "🌿", cat: .spices),
    IngInfo(name: "thyme", emoji: "🌿", cat: .spices),
    IngInfo(name: "chili flakes", emoji: "🌶️", cat: .spices),
]

// MARK: - Recipe

struct Recipe: Codable, Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let ingredients: [String]
    let steps: [String]
    let cookTime: Int
    let servings: Int
    let difficulty: Difficulty
    let meal: MealType
    var isFavorite: Bool

    init(_ name: String, _ emoji: String, _ ingredients: [String], _ steps: [String], _ time: Int, _ servings: Int, _ diff: Difficulty, _ meal: MealType) {
        self.id = UUID(); self.name = name; self.emoji = emoji; self.ingredients = ingredients
        self.steps = steps; self.cookTime = time; self.servings = servings; self.difficulty = diff
        self.meal = meal; self.isFavorite = false
    }

    func matchPercent(fridge: Set<String>) -> Double {
        let needed = Set(ingredients.map { $0.lowercased() })
        guard !needed.isEmpty else { return 0 }
        return Double(needed.intersection(fridge).count) / Double(needed.count)
    }

    func missingIngredients(fridge: Set<String>) -> [String] {
        ingredients.filter { !fridge.contains($0.lowercased()) }
    }

    // MARK: - 50 Recipes
    static let catalog: [Recipe] = [
        // BREAKFAST (10)
        Recipe("Scrambled Eggs", "🍳", ["eggs", "butter", "salt", "pepper"],
               ["Beat eggs with salt and pepper", "Melt butter in pan over medium heat", "Pour eggs, stir gently until just set"], 5, 2, .easy, .breakfast),
        Recipe("Classic Pancakes", "🥞", ["flour", "eggs", "milk", "butter", "sugar", "baking powder"],
               ["Mix flour, sugar, baking powder", "Whisk eggs and milk, combine with dry mix", "Ladle batter onto buttered pan, flip when bubbles form"], 15, 4, .easy, .breakfast),
        Recipe("French Toast", "🍞", ["bread", "eggs", "milk", "cinnamon", "sugar", "butter"],
               ["Whisk eggs, milk, cinnamon, sugar", "Dip bread slices in mixture", "Fry in butter until golden on both sides"], 10, 2, .easy, .breakfast),
        Recipe("Oatmeal Bowl", "🥣", ["oats", "milk", "honey", "banana"],
               ["Cook oats in milk until creamy", "Slice banana on top", "Drizzle with honey, serve warm"], 8, 1, .easy, .breakfast),
        Recipe("Avocado Toast", "🥑", ["bread", "avocado", "salt", "lemon", "chili flakes"],
               ["Toast bread until crispy", "Mash avocado with salt and lemon", "Spread on toast, sprinkle chili flakes"], 5, 1, .easy, .breakfast),
        Recipe("Smoothie Bowl", "🫐", ["banana", "berries", "yogurt", "honey", "granola"],
               ["Blend frozen banana and berries with yogurt", "Pour into bowl", "Top with granola and drizzle honey"], 5, 1, .easy, .breakfast),
        Recipe("Egg Sandwich", "🥪", ["bread", "eggs", "cheese", "butter"],
               ["Fry eggs in butter to desired doneness", "Toast bread, place cheese on warm bread", "Top with egg, close sandwich"], 8, 1, .easy, .breakfast),
        Recipe("Shakshuka", "🍳", ["eggs", "tomato", "onion", "garlic", "bell pepper", "cumin", "paprika", "olive oil"],
               ["Sauté onion, garlic, peppers in olive oil", "Add diced tomato, cumin, paprika, simmer 10 min", "Make wells, crack eggs in, cover until set"], 25, 2, .medium, .breakfast),
        Recipe("Banana Oat Pancakes", "🍌", ["banana", "oats", "eggs", "cinnamon"],
               ["Blend banana, oats, eggs, cinnamon", "Pour small circles onto hot pan", "Flip when edges set, cook until golden"], 10, 2, .easy, .breakfast),
        Recipe("Yogurt Parfait", "🥛", ["yogurt", "granola", "berries", "honey"],
               ["Layer yogurt in a glass", "Add granola and berries", "Repeat layers, top with honey"], 3, 1, .easy, .breakfast),

        // LUNCH (10)
        Recipe("Caesar Salad", "🥗", ["lettuce", "chicken", "parmesan", "bread", "lemon", "garlic", "olive oil"],
               ["Grill chicken, slice thin", "Tear lettuce, cube and toast bread for croutons", "Toss with lemon-garlic olive oil dressing, top with parmesan"], 20, 2, .medium, .lunch),
        Recipe("Grilled Cheese", "🧀", ["bread", "cheese", "butter"],
               ["Butter outside of bread slices", "Place cheese between slices", "Grill in pan until golden and melted"], 8, 1, .easy, .lunch),
        Recipe("Chicken Wrap", "🌯", ["tortilla", "chicken", "lettuce", "tomato", "mayo"],
               ["Cook and slice chicken", "Spread mayo on tortilla", "Layer chicken, lettuce, tomato, roll tight"], 15, 2, .easy, .lunch),
        Recipe("Tomato Soup", "🍅", ["tomato", "onion", "garlic", "cream", "basil", "butter"],
               ["Sauté onion and garlic in butter", "Add chopped tomatoes, simmer 20 min", "Blend smooth, stir in cream and basil"], 30, 4, .easy, .lunch),
        Recipe("Tuna Salad", "🐟", ["tuna", "mayo", "celery", "onion", "lettuce", "lemon"],
               ["Drain tuna, flake into bowl", "Mix with diced celery, onion, mayo, lemon", "Serve on lettuce leaves"], 10, 2, .easy, .lunch),
        Recipe("BLT Sandwich", "🥓", ["bacon", "lettuce", "tomato", "bread", "mayo"],
               ["Cook bacon until crispy", "Toast bread, spread mayo", "Stack bacon, lettuce, tomato"], 12, 1, .easy, .lunch),
        Recipe("Quesadilla", "🫓", ["tortilla", "cheese", "chicken", "bell pepper"],
               ["Dice chicken and peppers, sauté briefly", "Place tortilla in pan, add cheese and filling on half", "Fold, cook until golden on both sides"], 12, 2, .easy, .lunch),
        Recipe("Greek Salad", "🥗", ["cucumber", "tomato", "feta", "olives", "onion", "olive oil"],
               ["Dice cucumber, tomato, onion", "Add crumbled feta and olives", "Drizzle olive oil, toss gently"], 10, 2, .easy, .lunch),
        Recipe("Egg Fried Rice", "🍳", ["rice", "eggs", "soy sauce", "green onion", "garlic"],
               ["Cook rice ahead and cool", "Scramble eggs, set aside", "Stir-fry rice with garlic and soy sauce, fold in eggs and green onion"], 15, 2, .easy, .lunch),
        Recipe("Veggie Stir Fry", "🥦", ["broccoli", "bell pepper", "carrot", "soy sauce", "garlic", "rice", "olive oil"],
               ["Cut vegetables into bite-size pieces", "Stir-fry in olive oil with garlic on high heat", "Add soy sauce, toss, serve over rice"], 15, 2, .easy, .lunch),

        // DINNER (15)
        Recipe("Spaghetti Bolognese", "🍝", ["pasta", "ground beef", "tomato", "onion", "garlic", "olive oil"],
               ["Brown ground beef with onion and garlic", "Add diced tomatoes, simmer 20 min", "Cook pasta, serve with sauce on top"], 35, 4, .medium, .dinner),
        Recipe("Chicken Alfredo", "🍝", ["pasta", "chicken", "cream", "parmesan", "garlic", "butter"],
               ["Cook pasta al dente", "Sauté chicken in butter with garlic until done", "Add cream and parmesan, simmer, toss with pasta"], 25, 3, .medium, .dinner),
        Recipe("Beef Tacos", "🌮", ["tortilla", "ground beef", "lettuce", "tomato", "cheese", "sour cream"],
               ["Brown ground beef with spices", "Warm tortillas", "Assemble with beef, lettuce, tomato, cheese, sour cream"], 20, 4, .easy, .dinner),
        Recipe("Salmon & Rice", "🐟", ["salmon", "rice", "lemon", "garlic", "butter"],
               ["Cook rice", "Season salmon with lemon, garlic, salt", "Pan-sear in butter 4 min each side"], 25, 2, .medium, .dinner),
        Recipe("Chicken Curry", "🍛", ["chicken", "curry powder", "coconut milk", "onion", "garlic", "rice"],
               ["Sauté onion and garlic, add curry powder", "Add chicken pieces, cook until browned", "Pour coconut milk, simmer 20 min, serve over rice"], 35, 4, .medium, .dinner),
        Recipe("Mushroom Risotto", "🍄", ["rice", "mushrooms", "onion", "parmesan", "butter"],
               ["Sauté mushrooms and onion in butter", "Add rice, stir to coat", "Gradually add hot water while stirring, fold in parmesan"], 35, 3, .hard, .dinner),
        Recipe("Steak & Potatoes", "🥩", ["steak", "potato", "butter", "garlic", "rosemary"],
               ["Season steak generously with salt and pepper", "Sear in hot pan with butter, garlic, rosemary", "Roast potatoes at 400F until crispy, serve together"], 30, 2, .medium, .dinner),
        Recipe("Shrimp Pasta", "🦐", ["pasta", "shrimp", "garlic", "butter", "lemon", "chili flakes"],
               ["Cook pasta al dente", "Sauté shrimp in garlic butter until pink", "Add lemon juice, chili flakes, toss with pasta"], 20, 2, .medium, .dinner),
        Recipe("Chicken Fajitas", "🌯", ["chicken", "bell pepper", "onion", "tortilla", "lime", "cumin"],
               ["Slice chicken and vegetables", "Sear on high heat with cumin", "Squeeze lime, serve in warm tortillas"], 20, 4, .easy, .dinner),
        Recipe("Beef Stew", "🍲", ["ground beef", "potato", "carrot", "onion", "garlic", "canned tomato"],
               ["Brown beef in pot", "Add diced vegetables and canned tomato", "Simmer on low for 45 min until tender"], 60, 4, .medium, .dinner),
        Recipe("Carbonara", "🍝", ["pasta", "bacon", "eggs", "parmesan", "pepper"],
               ["Cook pasta, reserve pasta water", "Fry bacon until crispy", "Toss hot pasta with beaten eggs, parmesan, bacon, add pasta water for silk"], 20, 2, .medium, .dinner),
        Recipe("Teriyaki Chicken", "🍗", ["chicken", "soy sauce", "honey", "garlic", "ginger", "rice"],
               ["Mix soy sauce, honey, garlic, ginger for sauce", "Cook chicken, pour sauce over, simmer until glazed", "Serve over steamed rice"], 25, 3, .medium, .dinner),
        Recipe("Mac and Cheese", "🧀", ["pasta", "cheese", "milk", "butter", "flour"],
               ["Cook pasta, drain", "Melt butter, whisk in flour, add milk for sauce", "Stir in cheese until melted, combine with pasta"], 20, 4, .easy, .dinner),
        Recipe("Lemon Herb Chicken", "🍋", ["chicken", "lemon", "garlic", "oregano", "olive oil", "potato"],
               ["Marinate chicken with lemon, garlic, oregano, olive oil", "Arrange with potato wedges on baking sheet", "Roast at 400F for 35 minutes"], 45, 3, .medium, .dinner),
        Recipe("Pad Thai", "🍜", ["noodles", "shrimp", "peanuts", "lime", "soy sauce", "eggs", "green onion"],
               ["Cook noodles, drain", "Stir-fry shrimp and scrambled eggs", "Toss noodles with soy sauce, lime, top with peanuts and green onion"], 20, 2, .medium, .dinner),

        // SNACKS (8)
        Recipe("Guacamole", "🥑", ["avocado", "lime", "onion", "tomato", "cilantro", "salt"],
               ["Mash avocado with fork", "Mix in diced onion, tomato, cilantro", "Add lime juice and salt to taste"], 8, 4, .easy, .snack),
        Recipe("Hummus", "🫘", ["chickpeas", "tahini", "garlic", "lemon", "olive oil", "salt"],
               ["Blend chickpeas with tahini, garlic, lemon", "Stream in olive oil while blending", "Season with salt, serve with drizzle of oil"], 10, 6, .easy, .snack),
        Recipe("Bruschetta", "🍅", ["bread", "tomato", "basil", "garlic", "olive oil"],
               ["Dice tomatoes, mix with chopped basil and garlic", "Toast bread slices", "Top with tomato mixture, drizzle olive oil"], 10, 4, .easy, .snack),
        Recipe("Caprese", "🧀", ["mozzarella", "tomato", "basil", "olive oil", "salt"],
               ["Slice mozzarella and tomatoes", "Alternate on plate with basil leaves", "Drizzle olive oil, sprinkle salt"], 5, 2, .easy, .snack),
        Recipe("Nachos Supreme", "🫓", ["tortilla chips", "cheese", "jalapeño", "salsa", "sour cream"],
               ["Spread tortilla chips on baking sheet", "Top with cheese and jalapeño slices", "Bake at 375F until melted, serve with salsa and sour cream"], 12, 4, .easy, .snack),
        Recipe("PB Banana Bites", "🍌", ["banana", "peanut butter", "chocolate"],
               ["Slice banana into rounds", "Spread peanut butter between two slices", "Drizzle melted chocolate, freeze 30 min"], 35, 2, .easy, .snack),
        Recipe("Garlic Bread", "🍞", ["bread", "butter", "garlic", "parmesan"],
               ["Mix softened butter with minced garlic", "Spread on bread halves, sprinkle parmesan", "Broil until golden and bubbly"], 8, 4, .easy, .snack),
        Recipe("Veggie Sticks & Dip", "🥕", ["carrot", "cucumber", "celery", "yogurt", "garlic", "lemon"],
               ["Cut vegetables into sticks", "Mix yogurt with garlic, lemon, salt for dip", "Arrange and serve"], 10, 2, .easy, .snack),

        // DESSERTS (7)
        Recipe("Banana Bread", "🍌", ["banana", "flour", "eggs", "sugar", "butter", "baking powder"],
               ["Mash ripe bananas", "Mix with melted butter, sugar, eggs", "Fold in flour and baking powder, bake at 350F for 50 min"], 60, 8, .medium, .dessert),
        Recipe("Chocolate Mousse", "🍫", ["chocolate", "cream", "eggs", "sugar"],
               ["Melt chocolate, cool slightly", "Whip cream to soft peaks", "Beat eggs with sugar, fold all together, chill 2 hours"], 140, 4, .hard, .dessert),
        Recipe("Apple Crumble", "🍎", ["apple", "flour", "butter", "sugar", "cinnamon", "oats"],
               ["Slice apples, toss with cinnamon and sugar", "Mix flour, oats, butter, sugar for crumble", "Top apples with crumble, bake at 375F for 35 min"], 45, 6, .medium, .dessert),
        Recipe("Rice Pudding", "🍚", ["rice", "milk", "sugar", "cinnamon", "vanilla"],
               ["Simmer rice in milk on low heat", "Stir frequently for 30 min until creamy", "Add sugar, vanilla, top with cinnamon"], 35, 4, .easy, .dessert),
        Recipe("Berry Smoothie", "🫐", ["berries", "banana", "yogurt", "honey", "milk"],
               ["Add all ingredients to blender", "Blend until smooth", "Pour into glass, enjoy cold"], 3, 1, .easy, .dessert),
        Recipe("Peanut Butter Cookies", "🍪", ["peanut butter", "sugar", "eggs"],
               ["Mix peanut butter, sugar, and egg", "Roll into balls, press with fork", "Bake at 350F for 10 minutes"], 15, 12, .easy, .dessert),
        Recipe("Cinnamon Rolls", "🍩", ["flour", "milk", "butter", "sugar", "cinnamon", "eggs"],
               ["Make dough with flour, milk, butter, eggs, let rise 1 hour", "Roll out, spread butter-cinnamon-sugar filling", "Roll up, slice, bake at 375F for 20 min"], 90, 8, .hard, .dessert),
    ]
}

// MARK: - Cook Log

struct CookLog: Codable, Identifiable {
    let id: UUID
    let recipeName: String
    let recipeEmoji: String
    let date: Date
    let rating: Int

    init(recipeName: String, recipeEmoji: String, rating: Int) {
        self.id = UUID(); self.recipeName = recipeName; self.recipeEmoji = recipeEmoji
        self.date = Date(); self.rating = rating
    }
}

// MARK: - Chart

struct ChartPoint: Identifiable {
    let id: String; let label: String; let value: Double
}
