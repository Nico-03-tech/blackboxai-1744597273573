import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';

class EinnahmenScreen extends StatefulWidget {
  const EinnahmenScreen({super.key});

  @override
  State<EinnahmenScreen> createState() => _EinnahmenScreenState();
}

class _EinnahmenScreenState extends State<EinnahmenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _betragController = TextEditingController();
  final _notizController = TextEditingController();
  String _ausgewaehlteKategorie = 'Gehalt';
  DateTime _ausgewaehltesDatum = DateTime.now();

  final List<String> _einnahmenKategorien = [
    'Gehalt',
    'Nebeneinkünfte',
    'Investments',
    'Geschenke',
    'Sonstiges',
  ];

  @override
  void dispose() {
    _betragController.dispose();
    _notizController.dispose();
    super.dispose();
  }

  Future<void> _datumAuswaehlen(BuildContext context) async {
    final DateTime? gewaehlt = await showDatePicker(
      context: context,
      initialDate: _ausgewaehltesDatum,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('de', 'DE'),
    );
    if (gewaehlt != null && gewaehlt != _ausgewaehltesDatum) {
      setState(() {
        _ausgewaehltesDatum = gewaehlt;
      });
    }
  }

  void _einnahmeHinzufuegen() {
    if (_formKey.currentState!.validate()) {
      // TODO: Einnahme zur Datenbank hinzufügen
      final einnahme = Einnahme(
        id: DateTime.now().toString(), // Temporäre ID
        betrag: double.parse(_betragController.text.replaceAll(',', '.')),
        kategorie: _ausgewaehlteKategorie,
        datum: _ausgewaehltesDatum,
        notiz: _notizController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Einnahme wurde gespeichert'),
          backgroundColor: Colors.green,
        ),
      );

      // Formular zurücksetzen
      _formKey.currentState!.reset();
      _betragController.clear();
      _notizController.clear();
      setState(() {
        _ausgewaehltesDatum = DateTime.now();
        _ausgewaehlteKategorie = 'Gehalt';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einnahme hinzufügen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isWideScreen ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _betragController,
                      decoration: const InputDecoration(
                        labelText: 'Betrag (€)',
                        prefixIcon: Icon(Icons.euro),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie einen Betrag ein';
                        }
                        if (double.tryParse(value.replaceAll(',', '.')) == null) {
                          return 'Bitte geben Sie eine gültige Zahl ein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _ausgewaehlteKategorie,
                      decoration: const InputDecoration(
                        labelText: 'Kategorie',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _einnahmenKategorien.map((String kategorie) {
                        return DropdownMenuItem<String>(
                          value: kategorie,
                          child: Text(kategorie),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _ausgewaehlteKategorie = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _datumAuswaehlen(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Datum',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('dd.MM.yyyy').format(_ausgewaehltesDatum),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notizController,
                      decoration: const InputDecoration(
                        labelText: 'Notiz',
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _einnahmeHinzufuegen,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Einnahme speichern'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Letzte Einnahmen',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // TODO: Hier die letzten Einnahmen anzeigen
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.arrow_upward, color: Colors.green),
                            title: Text('Einnahme ${index + 1}'),
                            subtitle: Text('Kategorie • ${DateFormat('dd.MM.yyyy').format(DateTime.now())}'),
                            trailing: const Text('€1,000.00'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ) : Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _betragController,
                decoration: const InputDecoration(
                  labelText: 'Betrag (€)',
                  prefixIcon: Icon(Icons.euro),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie einen Betrag ein';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Bitte geben Sie eine gültige Zahl ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _ausgewaehlteKategorie,
                decoration: const InputDecoration(
                  labelText: 'Kategorie',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _einnahmenKategorien.map((String kategorie) {
                  return DropdownMenuItem<String>(
                    value: kategorie,
                    child: Text(kategorie),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _ausgewaehlteKategorie = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _datumAuswaehlen(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Datum',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(_ausgewaehltesDatum),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notizController,
                decoration: const InputDecoration(
                  labelText: 'Notiz',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _einnahmeHinzufuegen,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Einnahme speichern'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AusgabenScreen extends StatefulWidget {
  const AusgabenScreen({super.key});

  @override
  State<AusgabenScreen> createState() => _AusgabenScreenState();
}

class _AusgabenScreenState extends State<AusgabenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _betragController = TextEditingController();
  final _notizController = TextEditingController();
  String _ausgewaehlteKategorie = 'Lebensmittel';
  DateTime _ausgewaehltesDatum = DateTime.now();
  final List<String> _ausgewaehlteTags = [];

  final List<String> _ausgabenKategorien = [
    'Lebensmittel',
    'Miete',
    'Transport',
    'Unterhaltung',
    'Gesundheit',
    'Shopping',
    'Sonstiges',
  ];

  final List<String> _verfuegbareTags = [
    'Wichtig',
    'Regelmäßig',
    'Einmalig',
    'Sparen',
    'Luxus',
  ];

  @override
  void dispose() {
    _betragController.dispose();
    _notizController.dispose();
    super.dispose();
  }

  Future<void> _datumAuswaehlen(BuildContext context) async {
    final DateTime? gewaehlt = await showDatePicker(
      context: context,
      initialDate: _ausgewaehltesDatum,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('de', 'DE'),
    );
    if (gewaehlt != null && gewaehlt != _ausgewaehltesDatum) {
      setState(() {
        _ausgewaehltesDatum = gewaehlt;
      });
    }
  }

  void _ausgabeHinzufuegen() {
    if (_formKey.currentState!.validate()) {
      // TODO: Ausgabe zur Datenbank hinzufügen
      final ausgabe = Ausgabe(
        id: DateTime.now().toString(), // Temporäre ID
        betrag: double.parse(_betragController.text.replaceAll(',', '.')),
        kategorie: _ausgewaehlteKategorie,
        datum: _ausgewaehltesDatum,
        notiz: _notizController.text,
        tags: _ausgewaehlteTags,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ausgabe wurde gespeichert'),
          backgroundColor: Colors.green,
        ),
      );

      // Formular zurücksetzen
      _formKey.currentState!.reset();
      _betragController.clear();
      _notizController.clear();
      setState(() {
        _ausgewaehltesDatum = DateTime.now();
        _ausgewaehlteKategorie = 'Lebensmittel';
        _ausgewaehlteTags.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ausgabe hinzufügen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _betragController,
                decoration: const InputDecoration(
                  labelText: 'Betrag (€)',
                  prefixIcon: Icon(Icons.euro),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie einen Betrag ein';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Bitte geben Sie eine gültige Zahl ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _ausgewaehlteKategorie,
                decoration: const InputDecoration(
                  labelText: 'Kategorie',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _ausgabenKategorien.map((String kategorie) {
                  return DropdownMenuItem<String>(
                    value: kategorie,
                    child: Text(kategorie),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _ausgewaehlteKategorie = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _datumAuswaehlen(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Datum',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(_ausgewaehltesDatum),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tags',
                style: TextStyle(fontSize: 16),
              ),
              Wrap(
                spacing: 8.0,
                children: _verfuegbareTags.map((String tag) {
                  final isSelected = _ausgewaehlteTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _ausgewaehlteTags.add(tag);
                        } else {
                          _ausgewaehlteTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notizController,
                decoration: const InputDecoration(
                  labelText: 'Notiz',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _ausgabeHinzufuegen,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Ausgabe speichern'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
