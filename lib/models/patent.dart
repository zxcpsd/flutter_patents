import 'inventor.dart';

class Patent {
  int id;
  String patentId;
  String date;
  String title;
  String description;
  Patent(this.id, this.patentId, this.date, this.title, this.description);
  Map<String, dynamic> toMap() => {
        'id': (id == 0) ? null : id,
        'pid': patentId,
        'title': title,
        'date': date,
        'description': description
      };
}

class PatentWithAuthors extends Patent {
  List<Inventor> authors;
  PatentWithAuthors(Patent patent, this.authors)
      : super(patent.id, patent.patentId, patent.date, patent.title,
            patent.description);
}
