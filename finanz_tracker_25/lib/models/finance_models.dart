import 'package:intl/intl.dart';

class FinanzTransaktion {
  final String id;
  final double betrag;
  final String kategorie;
  final DateTime datum;
  final String? notiz;

  FinanzTransaktion({
    required this.id,
    required this.betrag,
    required this.kategorie,
    required this.datum,
    this.notiz,
  });

  String get formatierterBetrag {
    final formatter = NumberFormat.currency(locale: 'de_DE', symbol: '€');
    return formatter.format(betrag);
  }

  String get formatiertesDatum {
    return DateFormat('dd.MM.yyyy').format(datum);
  }
}

class Einnahme extends FinanzTransaktion {
  Einnahme({
    required String id,
    required double betrag,
    required String kategorie,
    required DateTime datum,
    String? notiz,
  }) : super(
          id: id,
          betrag: betrag,
          kategorie: kategorie,
          datum: datum,
          notiz: notiz,
        );

  factory Einnahme.fromJson(Map<String, dynamic> json) {
    return Einnahme(
      id: json['id'] as String,
      betrag: json['betrag'] as double,
      kategorie: json['kategorie'] as String,
      datum: DateTime.parse(json['datum'] as String),
      notiz: json['notiz'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'betrag': betrag,
      'kategorie': kategorie,
      'datum': datum.toIso8601String(),
      'notiz': notiz,
    };
  }
}

class Ausgabe extends FinanzTransaktion {
  final List<String> tags;

  Ausgabe({
    required String id,
    required double betrag,
    required String kategorie,
    required DateTime datum,
    String? notiz,
    List<String>? tags,
  }) : tags = tags ?? [],
       super(
          id: id,
          betrag: betrag,
          kategorie: kategorie,
          datum: datum,
          notiz: notiz,
        );

  factory Ausgabe.fromJson(Map<String, dynamic> json) {
    return Ausgabe(
      id: json['id'] as String,
      betrag: json['betrag'] as double,
      kategorie: json['kategorie'] as String,
      datum: DateTime.parse(json['datum'] as String),
      notiz: json['notiz'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'betrag': betrag,
      'kategorie': kategorie,
      'datum': datum.toIso8601String(),
      'notiz': notiz,
      'tags': tags,
    };
  }
}

class Schuld {
  final String id;
  final double hauptforderung;
  final double zinssatz;
  final double monatlicheRate;
  final DateTime startDatum;
  final int laufzeitMonate;
  final List<SchuldZahlung> zahlungsHistorie;

  Schuld({
    required this.id,
    required this.hauptforderung,
    required this.zinssatz,
    required this.monatlicheRate,
    required this.startDatum,
    required this.laufzeitMonate,
    List<SchuldZahlung>? zahlungsHistorie,
  }) : zahlungsHistorie = zahlungsHistorie ?? [];

  double get gesamtSumme {
    return hauptforderung * (1 + (zinssatz / 100));
  }

  double get aktuelleRestschuld {
    double gezahlt = zahlungsHistorie.fold(
      0,
      (sum, zahlung) => sum + zahlung.betrag,
    );
    return gesamtSumme - gezahlt;
  }

  factory Schuld.fromJson(Map<String, dynamic> json) {
    return Schuld(
      id: json['id'] as String,
      hauptforderung: json['hauptforderung'] as double,
      zinssatz: json['zinssatz'] as double,
      monatlicheRate: json['monatlicheRate'] as double,
      startDatum: DateTime.parse(json['startDatum'] as String),
      laufzeitMonate: json['laufzeitMonate'] as int,
      zahlungsHistorie: (json['zahlungsHistorie'] as List<dynamic>?)
          ?.map((e) => SchuldZahlung.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hauptforderung': hauptforderung,
      'zinssatz': zinssatz,
      'monatlicheRate': monatlicheRate,
      'startDatum': startDatum.toIso8601String(),
      'laufzeitMonate': laufzeitMonate,
      'zahlungsHistorie': zahlungsHistorie.map((z) => z.toJson()).toList(),
    };
  }
}

class SchuldZahlung {
  final DateTime datum;
  final double betrag;

  SchuldZahlung({
    required this.datum,
    required this.betrag,
  });

  factory SchuldZahlung.fromJson(Map<String, dynamic> json) {
    return SchuldZahlung(
      datum: DateTime.parse(json['datum'] as String),
      betrag: json['betrag'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'datum': datum.toIso8601String(),
      'betrag': betrag,
    };
  }
}
