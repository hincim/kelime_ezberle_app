enum Lang { eng, tr }
// daha okunaklı olması için enum yapısını kullanırım.

Lang? chooseLang = Lang.eng;

enum Which { learned, unlearned, all } // words_cards_page
enum ForWhat {forList, forListMixed} // words_card_page deki değişkenler

List<Map<String, Object?>> lists = [];
List<bool> selectedListIndex = [];

