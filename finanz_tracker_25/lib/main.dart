import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/einnahmen_ausgaben_screen.dart';
import 'screens/schulden_screen.dart';
import 'screens/dokumente_screen.dart';
import 'services/navigation_service.dart';
import 'services/theme_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const FinanzTrackerApp(),
    ),
  );
}

class FinanzTrackerApp extends StatelessWidget {
  const FinanzTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    
    return MaterialApp(
      title: 'Finanz-Tracker 25',
      navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      theme: themeService.getLightTheme(),
      darkTheme: themeService.getDarkTheme(),
      themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.dashboard,
      routes: {
        AppRoutes.dashboard: (context) => const AppLayout(child: DashboardScreen()),
        AppRoutes.einnahmen: (context) => const AppLayout(child: EinnahmenScreen()),
        AppRoutes.ausgaben: (context) => const AppLayout(child: AusgabenScreen()),
        AppRoutes.schulden: (context) => const AppLayout(child: SchuldenScreen()),
        AppRoutes.dokumente: (context) => const AppLayout(child: DokumenteScreen()),
      },
    );
  }
}

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 800;

    if (isWideScreen) {
      return Scaffold(
        body: Row(
          children: [
            const SizedBox(
              width: 250,
              child: AppNavigationDrawer(),
            ),
            Expanded(
              child: child,
            ),
            SizedBox(
              width: 300,
              child: Drawer(
                elevation: 0,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const Text(
                      'Schnellübersicht',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildQuickStats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (isMediumScreen) {
      return Scaffold(
        body: Row(
          children: [
            const SizedBox(
              width: 250,
              child: AppNavigationDrawer(),
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: child,
        drawer: const AppNavigationDrawer(),
      );
    }
  }

  Widget _buildQuickStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aktueller Kontostand'),
            const Text('€5,000.00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Divider(),
            const Text('Letzte Transaktionen'),
            ListTile(
              leading: const Icon(Icons.arrow_upward, color: Colors.green),
              title: const Text('Gehalt'),
              subtitle: const Text('15.10.2023'),
              trailing: const Text('€2,500.00'),
            ),
            ListTile(
              leading: const Icon(Icons.arrow_downward, color: Colors.red),
              title: const Text('Miete'),
              subtitle: const Text('01.10.2023'),
              trailing: const Text('-€800.00'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Finanz-Tracker 25',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ihre persönliche Finanzverwaltung',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          NavigationListTile(
            icon: Icons.dashboard,
            title: 'Dashboard',
            route: AppRoutes.dashboard,
          ),
          const Divider(),
          NavigationListTile(
            icon: Icons.attach_money,
            title: 'Einnahmen',
            route: AppRoutes.einnahmen,
          ),
          NavigationListTile(
            icon: Icons.money_off,
            title: 'Ausgaben',
            route: AppRoutes.ausgaben,
          ),
          NavigationListTile(
            icon: Icons.account_balance,
            title: 'Schulden',
            route: AppRoutes.schulden,
          ),
          const Divider(),
          NavigationListTile(
            icon: Icons.upload_file,
            title: 'Dokumente',
            route: AppRoutes.dokumente,
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            title: Text(
              themeService.isDarkMode ? 'Heller Modus' : 'Dunkler Modus',
            ),
            onTap: () {
              themeService.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}

class NavigationListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const NavigationListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      onTap: () {
        if (currentRoute != route) {
          Navigator.pop(context); // Schließe Drawer
          NavigationService.navigateToReplacement(route);
        }
      },
    );
  }
}
