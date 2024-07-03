class Category {
  String categoryName;
  String categoryImage;
  Category({required this.categoryImage, required this.categoryName});
}

Category business =
    Category(categoryImage: "assets/business.avif", categoryName: "business");
Category entertainment = Category(
    categoryImage: "assets/entertainment.jpg", categoryName: "entertainment");
Category world =
    Category(categoryImage: "assets/general.avif", categoryName: "world");
Category health =
    Category(categoryImage: "assets/health.avif", categoryName: "health");
Category science =
    Category(categoryImage: "assets/science.avif", categoryName: "science");
Category sports =
    Category(categoryImage: "assets/sports.avif", categoryName: "sports");
Category technology = Category(
    categoryImage: "assets/technology.jpeg", categoryName: "technology");
Category education =
    Category(categoryImage: "assets/education.jpg", categoryName: "education");

List<Category> categoryTypes = [
  business,
  entertainment,
  world,
  health,
  science,
  sports,
  technology,
  education
];
