import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class DokumenteScreen extends StatefulWidget {
  const DokumenteScreen({super.key});

  @override
  State<DokumenteScreen> createState() => _DokumenteScreenState();
}

class _DokumenteScreenState extends State<DokumenteScreen> {
  final List<DokumentInfo> _dokumente = [];
  bool _isLoading = false;

  Future<void> _dokumentHochladen() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx', 'csv'],
      );

      if (result != null) {
        // TODO: Implementiere den Upload zur Cloud Storage
        
        // Simuliere OCR-Verarbeitung
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _dokumente.add(
            DokumentInfo(
              name: result.files.first.name,
              typ: result.files.first.extension ?? 'unbekannt',
              datum: DateTime.now(),
              groesse: result.files.first.size,
              kategorie: 'Sonstiges',
              extrahierteDaten: {
                'betrag': '150,00 €',
                'datum': '15.10.2023',
                'kategorie': 'Rechnung',
              },
            ),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dokument wurde erfolgreich hochgeladen und verarbeitet'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Hochladen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dokumente'),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Dokument wird verarbeitet...'),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _dokumentHochladen,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Dokument hochladen'),
                        ),
                      ),
                    ],
                  ),
                ),
                const _DokumentFilterLeiste(),
                Expanded(
                  child: _dokumente.isEmpty
                      ? const Center(
                          child: Text('Keine Dokumente vorhanden'),
                        )
                      : isWideScreen
                          ? GridView.builder(
                              padding: const EdgeInsets.all(16.0),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: _dokumente.length,
                              itemBuilder: (context, index) {
                                return _DokumentGridEintrag(
                                  dokument: _dokumente[index],
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: _dokumente.length,
                              itemBuilder: (context, index) {
                                return _DokumentListenEintrag(
                                  dokument: _dokumente[index],
                                );
                              },
                            ),
                ),
              ],
            ),
    );
  }
}

class _DokumentFilterLeiste extends StatelessWidget {
  const _DokumentFilterLeiste();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Dokumente durchsuchen',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (String result) {
              // TODO: Implementiere Filter-Logik
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'alle',
                child: Text('Alle Dokumente'),
              ),
              const PopupMenuItem<String>(
                value: 'rechnungen',
                child: Text('Rechnungen'),
              ),
              const PopupMenuItem<String>(
                value: 'belege',
                child: Text('Belege'),
              ),
              const PopupMenuItem<String>(
                value: 'vertraege',
                child: Text('Verträge'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DokumentGridEintrag extends StatelessWidget {
  final DokumentInfo dokument;

  const _DokumentGridEintrag({required this.dokument});

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon() {
    switch (dokument.typ.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'csv':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Implementiere Detailansicht
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getFileIcon(), size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dokument.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${dokument.kategorie} • ${_formatFileSize(dokument.groesse)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      // TODO: Implementiere Download-Funktion
                    },
                    tooltip: 'Herunterladen',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Implementiere Bearbeiten-Funktion
                    },
                    tooltip: 'Bearbeiten',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // TODO: Implementiere Löschen-Funktion
                    },
                    tooltip: 'Löschen',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DokumentListenEintrag extends StatelessWidget {
  final DokumentInfo dokument;

  const _DokumentListenEintrag({required this.dokument});

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon() {
    switch (dokument.typ.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'csv':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: Icon(_getFileIcon()),
        title: Text(dokument.name),
        subtitle: Text(
          '${dokument.kategorie} • ${_formatFileSize(dokument.groesse)} • '
          '${DateFormat('dd.MM.yyyy').format(dokument.datum)}',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Extrahierte Daten:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...dokument.extrahierteDaten.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Text(
                          '${e.key}: ',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(e.value),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implementiere Download-Funktion
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Herunterladen'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implementiere Bearbeiten-Funktion
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Bearbeiten'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implementiere Löschen-Funktion
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Löschen'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DokumentInfo {
  final String name;
  final String typ;
  final DateTime datum;
  final int groesse;
  final String kategorie;
  final Map<String, String> extrahierteDaten;

  DokumentInfo({
    required this.name,
    required this.typ,
    required this.datum,
    required this.groesse,
    required this.kategorie,
    required this.extrahierteDaten,
  });
}
