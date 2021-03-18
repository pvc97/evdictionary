class Word {
  final int id;
  final String word;
  final String html;
  final String description;
  final String pronounce;
  int favorite;

  Word({
    this.id,
    this.word,
    this.html,
    this.description,
    this.pronounce,
    this.favorite,
  });

  set setfavorite(int value) {
    favorite = value;
  }
}
