import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';

class SchuldenScreen extends StatefulWidget {
  const SchuldenScreen({super.key});

  @override
  State<SchuldenScreen> createState() => _SchuldenScreenState();
}

class _SchuldenScreenState extends State<SchuldenScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hauptforderungController = TextEditingController();
  final _zinssatzController = TextEditingController();
  final _monatlicheRateController = TextEditingController();
  final _laufzeitController = TextEditingController();
  DateTime _startDatum = DateTime.now();

  @override
  void dispose() {
    _hauptforderungController.dispose();
    _zinssatzController.dispose();
    _monatlicheRateController.dispose();
    _laufzeitController.dispose();
    super.dispose();
  }

  Future<void> _startDatumAuswaehlen(BuildContext context) async {
    final DateTime? gewaehlt = await showDatePicker(
      context: context,
      initialDate: _startDatum,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('de', 'DE'),
    );
    if (gewaehlt != null && gewaehlt != _startDatum) {
      setState(() {
        _startDatum = gewaehlt;
      });
    }
  }

  void _schuldHinzufuegen() {
    if (_formKey.currentState!.validate()) {
      final schuld = Schuld(
        id: DateTime.now().toString(), // Temporäre ID
        hauptforderung: double.parse(_hauptforderungController.text.replaceAll(',', '.')),
        zinssatz: double.parse(_zinssatzController.text.replaceAll(',', '.')),
        monatlicheRate: double.parse(_monatlicheRateController.text.replaceAll(',', '.')),
        startDatum: _startDatum,
        laufzeitMonate: int.parse(_laufzeitController.text),
      );

      // TODO: Schuld zur Datenbank hinzufügen

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schuld wurde gespeichert'),
          backgroundColor: Colors.green,
        ),
      );

      // Formular zurücksetzen
      _formKey.currentState!.reset();
      _hauptforderungController.clear();
      _zinssatzController.clear();
      _monatlicheRateController.clear();
      _laufzeitController.clear();
      setState(() {
        _startDatum = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schulden verwalten'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isWideScreen ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Neue Schuld hinzufügen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _hauptforderungController,
                          decoration: const InputDecoration(
                            labelText: 'Hauptforderung (€)',
                            prefixIcon: Icon(Icons.euro),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie die Hauptforderung ein';
                            }
                            if (double.tryParse(value.replaceAll(',', '.')) == null) {
                              return 'Bitte geben Sie eine gültige Zahl ein';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _zinssatzController,
                          decoration: const InputDecoration(
                            labelText: 'Zinssatz (%)',
                            prefixIcon: Icon(Icons.percent),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie den Zinssatz ein';
                            }
                            if (double.tryParse(value.replaceAll(',', '.')) == null) {
                              return 'Bitte geben Sie eine gültige Zahl ein';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _monatlicheRateController,
                          decoration: const InputDecoration(
                            labelText: 'Monatliche Rate (€)',
                            prefixIcon: Icon(Icons.euro),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie die monatliche Rate ein';
                            }
                            if (double.tryParse(value.replaceAll(',', '.')) == null) {
                              return 'Bitte geben Sie eine gültige Zahl ein';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _laufzeitController,
                          decoration: const InputDecoration(
                            labelText: 'Laufzeit (Monate)',
                            prefixIcon: Icon(Icons.calendar_month),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte geben Sie die Laufzeit ein';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Bitte geben Sie eine ganze Zahl ein';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => _startDatumAuswaehlen(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Startdatum',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              DateFormat('dd.MM.yyyy').format(_startDatum),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _schuldHinzufuegen,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Schuld speichern'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            const Expanded(
              child: _SchuldenUebersicht(),
            ),
          ],
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SchuldenUebersicht(),
            const SizedBox(height: 24),
            const Text(
              'Neue Schuld hinzufügen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _hauptforderungController,
                    decoration: const InputDecoration(
                      labelText: 'Hauptforderung (€)',
                      prefixIcon: Icon(Icons.euro),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie die Hauptforderung ein';
                      }
                      if (double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Bitte geben Sie eine gültige Zahl ein';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _zinssatzController,
                    decoration: const InputDecoration(
                      labelText: 'Zinssatz (%)',
                      prefixIcon: Icon(Icons.percent),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie den Zinssatz ein';
                      }
                      if (double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Bitte geben Sie eine gültige Zahl ein';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _monatlicheRateController,
                    decoration: const InputDecoration(
                      labelText: 'Monatliche Rate (€)',
                      prefixIcon: Icon(Icons.euro),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie die monatliche Rate ein';
                      }
                      if (double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Bitte geben Sie eine gültige Zahl ein';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _laufzeitController,
                    decoration: const InputDecoration(
                      labelText: 'Laufzeit (Monate)',
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie die Laufzeit ein';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Bitte geben Sie eine ganze Zahl ein';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _startDatumAuswaehlen(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Startdatum',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('dd.MM.yyyy').format(_startDatum),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _schuldHinzufuegen,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Schuld speichern'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchuldenUebersicht extends StatelessWidget {
  const _SchuldenUebersicht();

  @override
  Widget build(BuildContext context) {
    // TODO: Schulden aus der Datenbank laden
    final List<Schuld> schulden = [
      Schuld(
        id: '1',
        hauptforderung: 10000,
        zinssatz: 5,
        monatlicheRate: 200,
        startDatum: DateTime(2023, 1, 1),
        laufzeitMonate: 60,
      ),
      // Weitere Beispiel-Schulden hier...
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aktuelle Schulden',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: schulden.length,
              itemBuilder: (context, index) {
                final schuld = schulden[index];
                return _SchuldListenEintrag(schuld: schuld);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SchuldListenEintrag extends StatelessWidget {
  final Schuld schuld;

  const _SchuldListenEintrag({required this.schuld});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'de_DE', symbol: '€');
    
    return Card(
      child: ListTile(
        title: Text('Kredit vom ${DateFormat('dd.MM.yyyy').format(schuld.startDatum)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hauptforderung: ${formatter.format(schuld.hauptforderung)}'),
            Text('Zinssatz: ${schuld.zinssatz}%'),
            Text('Monatliche Rate: ${formatter.format(schuld.monatlicheRate)}'),
            Text('Restschuld: ${formatter.format(schuld.aktuelleRestschuld)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Aktionen für die Schuld anzeigen (bearbeiten, löschen, etc.)
          },
        ),
      ),
    );
  }
}
