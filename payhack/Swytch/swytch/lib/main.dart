import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
 
 //test5//
 
void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(), 
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOnline = true;

  // --- Shared State for Balance and Transactions ---
  double availableBalance = 4285.75;
  List<Map<String, dynamic>> recentTransactions = [
    {
      'icon': Icons.arrow_upward,
      'iconBg': const Color(0xFFFFE5D0),
      'title': 'Coffee Shop',
      'subtitle': 'Today, 9:45 AM',
      'amount': -9.50,
      'amountColor': Colors.brown,
    },
    {
      'icon': Icons.arrow_downward,
      'iconBg': const Color(0xFFD0FFE5),
      'title': 'Salary Deposit',
      'subtitle': 'Yesterday, 5:30 PM',
      'amount': 2450.00,
      'amountColor': Colors.green,
    },
    {
      'icon': Icons.arrow_upward,
      'iconBg': const Color(0xFFFFE5D0),
      'title': 'Grocery Store',
      'subtitle': '',
      'amount': -30.20,
      'amountColor': Colors.brown,
    },
  ];

  // --- S Points State ---
  int pointsBalance = 2450;
  List<Map<String, dynamic>> pointsHistory = [
    {
      'icon': Icons.restaurant,
      'title': 'Green Cafe',
      'date': 'Oct 15, 2023',
      'points': 350,
      'isEarn': true,
    },
    {
      'icon': Icons.shopping_bag,
      'title': 'Eco Market',
      'date': 'Oct 12, 2023',
      'points': 520,
      'isEarn': true,
    },
    {
      'icon': Icons.emoji_people,
      'title': 'Local Threads',
      'date': 'Oct 8, 2023',
      'points': 280,
      'isEarn': true,
    },
    {
      'icon': Icons.card_giftcard,
      'title': 'Points Redeemed',
      'date': 'Oct 5, 2023',
      'points': 500,
      'isEarn': false,
    },
  ];

  void toggleOnline(bool value) {
    setState(() {
      isOnline = value;
    });
  }

  void updateBalanceAndTransactions({required double amount, required String merchant, required bool isDebit, required String subtitle}) {
    setState(() {
      availableBalance += isDebit ? -amount : amount;
      recentTransactions.insert(0, {
        'icon': isDebit ? Icons.arrow_upward : Icons.arrow_downward,
        'iconBg': isDebit ? const Color(0xFFFFE5D0) : const Color(0xFFD0FFE5),
        'title': merchant,
        'subtitle': subtitle,
        'amount': isDebit ? -amount : amount,
        'amountColor': isDebit ? Colors.brown : Colors.green,
      });
      if (recentTransactions.length > 10) {
        recentTransactions = recentTransactions.sublist(0, 10);
      }
    });
  }

  void updatePoints({required int points, required String title, required bool isEarn}) {
    setState(() {
      pointsBalance += isEarn ? points : -points;
      pointsHistory.insert(0, {
        'icon': isEarn ? Icons.add_circle : Icons.remove_circle,
        'title': title,
        'date': _getTodayDateString(),
        'points': points,
        'isEarn': isEarn,
      });
      if (pointsHistory.length > 10) {
        pointsHistory = pointsHistory.sublist(0, 10);
      }
    });
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return '${_getMonthName(now.month)} ${now.day}, ${now.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      brightness: Brightness.light,
    );
    final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF181818),
      brightness: Brightness.dark,
      cardColor: const Color(0xFF232323),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF181818),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
    return MaterialApp(
      title: 'Swytch',
      theme: isOnline ? lightTheme : darkTheme,
      home: SwytchMainPage(
        isOnline: isOnline,
        onToggle: toggleOnline,
        availableBalance: availableBalance,
        recentTransactions: recentTransactions,
        onPayment: updateBalanceAndTransactions,
        pointsBalance: pointsBalance,
        pointsHistory: pointsHistory,
        onPointsUpdate: updatePoints,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SwytchMainPage extends StatefulWidget {
  final bool isOnline;
  final void Function(bool) onToggle;
  final double availableBalance;
  final List<Map<String, dynamic>> recentTransactions;
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle}) onPayment;
  final int pointsBalance;
  final List<Map<String, dynamic>> pointsHistory;
  final void Function({required int points, required String title, required bool isEarn}) onPointsUpdate;
  const SwytchMainPage({super.key, required this.isOnline, required this.onToggle, required this.availableBalance, required this.recentTransactions, required this.onPayment, required this.pointsBalance, required this.pointsHistory, required this.onPointsUpdate});

  @override
  State<SwytchMainPage> createState() => _SwytchMainPageState();
}

class _SwytchMainPageState extends State<SwytchMainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      SwytchHomePage(
        isOnline: widget.isOnline,
        onToggle: widget.onToggle,
        availableBalance: widget.availableBalance,
        recentTransactions: widget.recentTransactions,
        onPayment: widget.onPayment,
      ),
      TransferTypeSelectionPage(
        isOnline: widget.isOnline,
        onPayment: widget.onPayment,
        pointsBalance: widget.pointsBalance,
        pointsHistory: widget.pointsHistory,
        onPointsUpdate: widget.onPointsUpdate,
      ),
      ScanQrPage(
        isOnline: widget.isOnline, 
        pointsBalance: widget.pointsBalance, 
        pointsHistory: widget.pointsHistory,
        onPayment: widget.onPayment,
        onPointsUpdate: widget.onPointsUpdate,
      ),
      SPointsPage(
        isOnline: widget.isOnline,
        pointsBalance: widget.pointsBalance,
        pointsHistory: widget.pointsHistory,
        onPointsUpdate: widget.onPointsUpdate,
      ),
      ConnectionModePage(
        isOnline: widget.isOnline,
        onToggle: widget.onToggle,
      ),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: widget.isOnline ? Colors.white : const Color(0xFF232323),
        selectedItemColor: const Color(0xFFF68B00),
        unselectedItemColor: widget.isOnline ? Colors.grey : Colors.white54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Transfers',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF68B00),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_rounded),
            label: 'S Points',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.wifi),
            label: 'Connection',
          ),
        ],
      ),
    );
  }
}

class SwytchHomePage extends StatelessWidget {
  final bool isOnline;
  final void Function(bool) onToggle;
  final double availableBalance;
  final List<Map<String, dynamic>> recentTransactions;
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle}) onPayment;
  const SwytchHomePage({super.key, required this.isOnline, required this.onToggle, required this.availableBalance, required this.recentTransactions, required this.onPayment});

  @override
  Widget build(BuildContext context) {
    final isOnline = this.isOnline;
    final orange = const Color(0xFFF68B00);
    final darkBg = const Color(0xFF181818);
    final cardColor = isOnline ? Colors.white : const Color(0xFF232323);
    final textColor = isOnline ? Colors.black : Colors.white;
    final subTextColor = isOnline ? Colors.black54 : Colors.white70;
    final highlight = isOnline ? orange : Colors.orange;
    final navBg = isOnline ? Colors.white : const Color(0xFF232323);
    final navSelected = orange;
    final navUnselected = isOnline ? Colors.grey : Colors.white54;
    return Scaffold(
      backgroundColor: isOnline ? const Color(0xFFF7F7F7) : darkBg,
      appBar: AppBar(
        backgroundColor: isOnline ? Colors.white : darkBg,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.account_balance_wallet_rounded, color: orange, size: 32),
            ),
            Text(
              'Swytch',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => onToggle(true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isOnline ? orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Online',
                      style: TextStyle(
                        color: isOnline ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => onToggle(false),
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isOnline ? orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Offline',
                      style: TextStyle(
                        color: !isOnline ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isOnline ? orange : orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(20.0),
                // Removed margin to make it flush with the parent
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Balance', style: TextStyle(color: isOnline ? Colors.white : Colors.white, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Text(
                      'RM ${availableBalance.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Monthly Overview (Finance Buddy) - only show when online
              isOnline
                  ? Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Monthly Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              Row(
                                children: [
                                  Text('May 2025', style: TextStyle(color: orange, fontWeight: FontWeight.bold, fontSize: 15)),
                                  const Icon(Icons.arrow_drop_down, color: Colors.orange),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            child: CustomPaint(
                              painter: _MonthlyBarChartPainter(),
                              child: Container(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Income', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 2),
                                  Text('RM3,240.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Expenses', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 2),
                                  Text('RM2,184.75', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Savings', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 2),
                                  Text('RM1,055.25', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFF68B00))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: 0.18,
                              child: CustomPaint(
                                painter: _MonthlyBarChartPainter(),
                                child: Container(),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.wifi_off, color: Colors.red, size: 48),
                                SizedBox(height: 12),
                                Text(
                                  'This function requires an internet connection',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              // Recent Transaction
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Transaction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: highlight)),
                  Text('See all', style: TextStyle(color: highlight, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              // Transaction List
              Column(
                children: recentTransactions.map((tx) => TransactionTile(
                  icon: tx['icon'],
                  iconBg: tx['iconBg'],
                  title: tx['title'],
                  subtitle: tx['subtitle'],
                  amount: (tx['amount'] < 0 ? '-' : '+') + 'RM' + tx['amount'].abs().toStringAsFixed(2),
                  amountColor: tx['amountColor'],
                  isOnline: isOnline,
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final bool isOnline;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isOnline ? Colors.white : const Color(0xFF232323),
        borderRadius: BorderRadius.circular(12),
        border: !isOnline && title == 'Coffee Shop' ? Border.all(color: const Color(0xFFF68B00), width: 1.5) : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: isOnline ? Colors.orange : Colors.orange, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isOnline ? Colors.black : Colors.white)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: TextStyle(color: isOnline ? Colors.black54 : Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectionModePage extends StatefulWidget {
  final bool isOnline;
  final void Function(bool) onToggle;
  const ConnectionModePage({super.key, required this.isOnline, required this.onToggle});

  @override
  State<ConnectionModePage> createState() => _ConnectionModePageState();
}

class _ConnectionModePageState extends State<ConnectionModePage> {
  late bool isOnline;

  @override
  void initState() {
    super.initState();
    isOnline = widget.isOnline;
  }

  void _handleToggle(bool value) {
    setState(() {
      isOnline = value;
    });
    widget.onToggle(value);
  }

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final darkBg = const Color(0xFF181818);
    final cardColor = isOnline ? Colors.white : const Color(0xFF232323);
    final textColor = isOnline ? Colors.black : Colors.white;
    final subTextColor = isOnline ? Colors.black54 : Colors.white70;
    return Scaffold(
      backgroundColor: isOnline ? const Color(0xFFF7F7F7) : darkBg,
      appBar: AppBar(
        backgroundColor: isOnline ? Colors.white : darkBg,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isOnline ? Colors.black : Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.account_balance_wallet_rounded, color: orange, size: 32),
            ),
            Text(
              'Swytch',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _handleToggle(true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isOnline ? orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Online',
                      style: TextStyle(
                        color: isOnline ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _handleToggle(false),
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isOnline ? orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Offline',
                      style: TextStyle(
                        color: !isOnline ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Connection Mode',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: orange),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose how you want to use Swytch',
                style: TextStyle(color: subTextColor),
              ),
              const SizedBox(height: 16),
              // Current Mode Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
                      const SizedBox(height: 4),
                      Text('Select your preferred connection mode', style: TextStyle(color: subTextColor)),
                      const SizedBox(height: 16),
                      // Change from Row to Column for vertical stacking
                      Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isOnline ? const Color(0xFFFFE5D0) : const Color(0xFF3A2A1A),
                              child: Icon(Icons.wifi, color: orange),
                            ),
                            title: Text('Online Mode', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            subtitle: Text('Internet connection required', style: TextStyle(color: subTextColor)),
                            trailing: isOnline
                                ? Icon(Icons.check_circle, color: orange)
                                : Icon(Icons.radio_button_unchecked, color: subTextColor),
                            onTap: () => _handleToggle(true),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: !isOnline ? const Color(0xFFFFE5D0) : const Color(0xFFD0D0D0),
                              child: Icon(Icons.signal_cellular_off, color: !isOnline ? orange : Colors.grey),
                            ),
                            title: Text('Offline Mode', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            subtitle: Text('Works without internet', style: TextStyle(color: subTextColor)),
                            trailing: !isOnline
                                ? Icon(Icons.check_circle, color: orange)
                                : Icon(Icons.radio_button_unchecked, color: subTextColor),
                            onTap: () => _handleToggle(false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Mode Features
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mode Features', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
                      const SizedBox(height: 12),
                      Text('Online Mode', style: TextStyle(fontWeight: FontWeight.bold, color: orange)),
                      const SizedBox(height: 4),
                      FeatureItem(text: 'Full e-wallet functionality', isOnline: isOnline),
                      FeatureItem(text: 'International transfers', isOnline: isOnline),
                      FeatureItem(text: 'Real-time transaction tracking', isOnline: isOnline),
                      FeatureItem(text: 'Access to all payment methods', isOnline: isOnline),
                      const SizedBox(height: 12),
                      Text('Offline Mode', style: TextStyle(fontWeight: FontWeight.bold, color: orange)),
                      const SizedBox(height: 4),
                      FeatureItem(text: 'SMS-based transactions', isOnline: isOnline),
                      FeatureItem(text: 'Works in areas with poor connectivity', isOnline: isOnline),
                      FeatureItem(text: 'Basic payment functionality', isOnline: isOnline),
                    ],
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

class FeatureItem extends StatelessWidget {
  final String text;
  final bool isOnline;
  const FeatureItem({super.key, required this.text, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 18),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: TextStyle(fontSize: 15, color: isOnline ? Colors.black : Colors.white))),
        ],
      ),
    );
  }
}

// --- New: TransferTypeSelectionPage ---
class TransferTypeSelectionPage extends StatelessWidget {
  final bool isOnline;
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle}) onPayment;
  final int pointsBalance;
  final List<Map<String, dynamic>> pointsHistory;
  final void Function({required int points, required String title, required bool isEarn}) onPointsUpdate;
  const TransferTypeSelectionPage({super.key, required this.isOnline, required this.onPayment, required this.pointsBalance, required this.pointsHistory, required this.onPointsUpdate});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    return Scaffold(
      backgroundColor: isOnline ? const Color(0xFFF7F7F7) : const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: isOnline ? Colors.white : const Color(0xFF181818),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.account_balance_wallet_rounded, color: orange, size: 32),
            ),
            Text(
              'Swytch',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Is your transaction local or international?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: isOnline ? Colors.black : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LocalTransferPage(isOnline: isOnline, transferType: 'local', onPayment: onPayment, pointsBalance: pointsBalance, pointsHistory: pointsHistory, onPointsUpdate: onPointsUpdate),
                    ),
                  );
                },
                icon: const Icon(Icons.store),
                label: const Text('Local'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOnline ? orange : Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: isOnline
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LocalTransferPage(
                              isOnline: isOnline, 
                              transferType: 'international', 
                              onPayment: onPayment, 
                              pointsBalance: pointsBalance, 
                              pointsHistory: pointsHistory,
                              onPointsUpdate: onPointsUpdate
                            ),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.public),
                label: const Text('International'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- New: ExchangeRateSelectionPage ---
class ExchangeRateSelectionPage extends StatefulWidget {
  final double sendAmount;
  final String sendCurrency;
  final String receiveCurrency;
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle})? onPayment;
  const ExchangeRateSelectionPage({super.key, required this.sendAmount, required this.sendCurrency, required this.receiveCurrency, this.onPayment});

  @override
  State<ExchangeRateSelectionPage> createState() => _ExchangeRateSelectionPageState();
}

class _ExchangeRateSelectionPageState extends State<ExchangeRateSelectionPage> {
  int selectedProvider = 0;

  List<Map<String, dynamic>> get providers {
    final sendAmount = widget.sendAmount;
    final exchangeRate = 0.21; // 1 RM = 0.21 EUR
    
    return [
      {
        'name': 'Wise',
        'logo': 'https://seeklogo.com/images/T/transferwise-logo-6B2B2B6B2C-seeklogo.com.png',
        'amount': sendAmount * exchangeRate,
        'currency': 'EUR',
        'fee': 0.0,
        'note': 'Best rate',
        'noteColor': Colors.green,
      },
      {
        'name': 'Remitly',
        'logo': 'https://seeklogo.com/images/R/remitly-logo-6B2B2B6B2C-seeklogo.com.png',
        'amount': sendAmount * (exchangeRate - 0.001), // Slightly worse rate
        'currency': 'EUR',
        'fee': 4.99,
        'note': null,
        'noteColor': null,
      },
      {
        'name': 'PayPal',
        'logo': 'https://seeklogo.com/images/P/paypal-logo-6B2B2B6B2C-seeklogo.com.png',
        'amount': sendAmount * (exchangeRate - 0.005), // Worse rate
        'currency': 'EUR',
        'fee': 7.50,
        'note': null,
        'noteColor': null,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final sendAmount = widget.sendAmount;
    final sendCurrency = widget.sendCurrency;
    final receiveCurrency = widget.receiveCurrency;
    final selected = providers[selectedProvider];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.account_balance_wallet_rounded, color: orange, size: 32),
            ),
            Text(
              'Swytch',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        // Remove online/offline toggle for international transfers
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('International Transfer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFBE3CF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('You send', style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 4),
                            Text(
                              '${sendAmount.toStringAsFixed(2)} $sendCurrency',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.black54),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Recipient gets', style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 4),
                            Text(
                              '${selected['amount'].toStringAsFixed(2)} ${selected['currency']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 4,
                    color: orange,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Exchange rate', style: TextStyle(color: Colors.black54)),
                      Text('1 RM = ${(selected['amount'] / widget.sendAmount).toStringAsFixed(5)} EUR', style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Available providers', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...List.generate(providers.length, (i) {
              final p = providers[i];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedProvider = i;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: i == selectedProvider ? orange : Colors.transparent,
                      width: i == selectedProvider ? 2 : 1,
                    ),
                    boxShadow: i == selectedProvider
                        ? [BoxShadow(color: orange.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))]
                        : [],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(p['logo'], width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.account_balance_wallet_rounded, color: orange)),
                    ),
                    title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: p['fee'] > 0
                        ? Text('Fee: €${p['fee'].toStringAsFixed(2)}', style: const TextStyle(color: Colors.black54, fontSize: 13))
                        : (p['note'] != null ? Text(p['note'], style: TextStyle(color: p['noteColor'], fontSize: 13)) : null),
                    trailing: Text('€${p['amount'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
              );
            }),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PinVerificationPage(
                            isOnline: true,
                            isOfflineLocal: false,
                            amount: widget.sendAmount,
                            merchant: 'International Transfer',
                            onPayment: widget.onPayment,
                          ),
                        ),
                      );
                    },
                    child: const Text('Pay Now'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: orange,
                      side: BorderSide(color: orange, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Update: LocalTransferPage ---
class LocalTransferPage extends StatefulWidget {
  final bool isOnline;
  final String transferType; // 'local' or 'international'
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle}) onPayment;
  final int pointsBalance;
  final List<Map<String, dynamic>> pointsHistory;
  final void Function({required int points, required String title, required bool isEarn}) onPointsUpdate;
  const LocalTransferPage({super.key, required this.isOnline, required this.transferType, required this.onPayment, required this.pointsBalance, required this.pointsHistory, required this.onPointsUpdate});

  @override
  State<LocalTransferPage> createState() => _LocalTransferPageState();
}

class _LocalTransferPageState extends State<LocalTransferPage> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';
  late String _selectedTab;

  // Local merchants
  final List<Map<String, String>> localFavourites = [
    {
      'logo': 'https://seeklogo.com/images/F/family-mart-logo-7B5B2B6B2C-seeklogo.com.png',
      'name': 'Family Mart',
      'code': 'FMB829103720',
    },
  ];
  final List<Map<String, String>> localRecents = [
    {
      'logo': 'https://seeklogo.com/images/P/popular-bookstore-logo-6B2B2B6B2C-seeklogo.com.png',
      'name': 'Popular Book Store',
      'code': 'PBS829103720',
    },
    {
      'logo': 'https://seeklogo.com/images/Z/zus-coffee-logo-7B5B2B6B2C-seeklogo.com.png',
      'name': 'Zus Coffee',
      'code': 'ZC829103720',
    },
    {
      'logo': 'https://seeklogo.com/images/M/mcdonald-s-logo-7B5B2B6B2C-seeklogo.com.png',
      'name': "McDonald's",
      'code': 'MCD829103720',
    },
    {
      'logo': 'https://seeklogo.com/images/T/tealive-logo-7B5B2B6B2C-seeklogo.com.png',
      'name': 'Tealive',
      'code': 'TL829103720',
    },
    {
      'logo': 'https://seeklogo.com/images/M/mr-diy-logo-7B5B2B6B2C-seeklogo.com.png',
      'name': 'Mr. DIY',
      'code': 'MRDIY829103720',
    },
  ];

  // International merchants
  final List<Map<String, String>> intlFavourites = [
    {
      'logo': 'https://seeklogo.com/images/A/alibaba-group-logo-6B2B2B6B2C-seeklogo.com.png',
      'name': 'Alibaba',
      'code': 'ALBB829103720',
    },
  ];
  final List<Map<String, String>> intlRecents = [
    {
      'logo': 'https://seeklogo.com/images/A/amazon-logo-86547BFB54-seeklogo.com.png',
      'name': 'Amazon',
      'code': 'AMZB29103720',
    },
    {
      'logo': 'https://seeklogo.com/images/T/taobao-logo-6B2B2B6B2C-seeklogo.com.png',
      'name': 'Tao Bao',
      'code': 'TB829103720',
    },
    {
      'logo': 'https://seeklogo.com/images/N/netflix-logo-6B2B2B6B2C-seeklogo.com.png',
      'name': 'Netflix',
      'code': 'NF829103720',
    },
    {
      'logo': 'https://seeklogo.com/images/U/uber-logo-6B2B2B6B2C-seeklogo.com.png',
      'name': 'Uber',
      'code': 'UB829103720',
    },
    {
      'logo': 'https://seeklogo.com/images/A/applecare-logo-6B2B2B6B2C-seeklogo.com.png',
      'name': 'AppleCare+',
      'code': 'AC829103720',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.transferType;
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = widget.isOnline;
    final orange = const Color(0xFFF68B00);
    final bgColor = isOnline ? const Color(0xFFF7F7F7) : const Color(0xFF181818);
    // ignore: unused_local_variable
    final cardColor = isOnline ? Colors.white : const Color(0xFF232323);
    final searchColor = isOnline ? Colors.white : const Color(0xFFF68B00).withOpacity(0.2);
    final textColor = isOnline ? Colors.black : Colors.white;
    // ignore: unused_local_variable
    final subTextColor = isOnline ? Colors.black54 : Colors.white70;
    final sectionColor = orange;
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );

    // Choose merchant lists based on selected tab
    final favourites = _selectedTab == 'local' ? localFavourites : intlFavourites;
    final recents = _selectedTab == 'local' ? localRecents : intlRecents;
    final filteredFavourites = favourites.where((m) => m['name']!.toLowerCase().contains(_search)).toList();
    final filteredRecents = recents.where((m) => m['name']!.toLowerCase().contains(_search)).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isOnline ? Colors.white : const Color(0xFF181818),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.account_balance_wallet_rounded, color: orange, size: 32),
            ),
            Text(
              'Swytch',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: isOnline ? Colors.white : const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: _selectedTab == 'local' ? orange : (isOnline ? Colors.white : const Color(0xFF232323)),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedTab = 'local';
                          });
                        },
                        child: Text('Local Transfer', style: TextStyle(color: _selectedTab == 'local' ? Colors.white : (isOnline ? Colors.black : Colors.white))),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: _selectedTab == 'international' ? orange : (isOnline ? Colors.white : const Color(0xFF232323)),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: isOnline
                            ? () {
                                setState(() {
                                  _selectedTab = 'international';
                                });
                              }
                            : null,
                        child: Text('International Transfer', style: TextStyle(color: _selectedTab == 'international' ? Colors.white : (isOnline ? Colors.black : Colors.white))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Vendor Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: sectionColor)),
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search vendor name',
                  filled: true,
                  fillColor: searchColor,
                  border: inputBorder,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Favourites', style: TextStyle(fontWeight: FontWeight.bold, color: sectionColor)),
                  Text('View all', style: TextStyle(color: sectionColor, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              ...filteredFavourites.map((m) => MerchantTile(
                logo: m['logo']!,
                name: m['name']!,
                code: m['code']!,
                isOnline: isOnline,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MerchantDetailsPage(
                        isOffline: !isOnline,
                        pointsBalance: widget.pointsBalance,
                        pointsHistory: widget.pointsHistory,
                        onProceedToPayment: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentDetailsPage(
                                isOnline: isOnline,
                                isOfflineLocal: _selectedTab == 'local',
                                merchant: m['name']!,
                                wallet: m['code']!,
                                amount: '',
                                onPayment: widget.onPayment,
                                pointsBalance: widget.pointsBalance,
                                pointsHistory: widget.pointsHistory,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent', style: TextStyle(fontWeight: FontWeight.bold, color: sectionColor)),
                  Text('View all', style: TextStyle(color: sectionColor, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              ...filteredRecents.map((m) => MerchantTile(
                logo: m['logo']!,
                name: m['name']!,
                code: m['code']!,
                isOnline: isOnline,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MerchantDetailsPage(
                        isOffline: !isOnline,
                        pointsBalance: widget.pointsBalance,
                        pointsHistory: widget.pointsHistory,
                        onProceedToPayment: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentDetailsPage(
                                isOnline: isOnline,
                                isOfflineLocal: _selectedTab == 'local',
                                merchant: m['name']!,
                                wallet: m['code']!,
                                amount: '',
                                onPayment: widget.onPayment,
                                pointsBalance: widget.pointsBalance,
                                pointsHistory: widget.pointsHistory,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class MerchantTile extends StatelessWidget {
  final String logo;
  final String name;
  final String code;
  final bool isOnline;
  final VoidCallback? onTap;
  const MerchantTile({super.key, required this.logo, required this.name, required this.code, required this.isOnline, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardColor = isOnline ? Colors.white : const Color(0xFFF68B00).withOpacity(0.2);
    final textColor = isOnline ? Colors.black : Colors.white;
    final subTextColor = isOnline ? Colors.black54 : Colors.white70;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isOnline ? const Color(0xFFE0E0E0) : Colors.transparent),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                logo,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300],
                  child: Icon(Icons.store, color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                  Text(code, style: TextStyle(color: subTextColor, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
// --- New: MerchantDetailsPage ---
class MerchantDetailsPage extends StatelessWidget {
  final bool isOffline;
  final int pointsBalance;
  final List<Map<String, dynamic>> pointsHistory;
  final VoidCallback? onProceedToPayment;
  const MerchantDetailsPage({super.key, this.isOffline = false, required this.pointsBalance, required this.pointsHistory, this.onProceedToPayment});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final bgColor = isOffline ? const Color(0xFF181818) : const Color(0xFFF7F7F7);
    final cardColor = isOffline ? const Color(0xFFFAD7B6) : Colors.white;
    final textColor = isOffline ? Colors.white : Colors.black;
    final subTextColor = isOffline ? Colors.white70 : Colors.black54;
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isOffline ? const Color(0xFF181818) : Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.account_balance_wallet_rounded, color: orange, size: 32),
            ),
            Text(
              'Swytch',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: isOffline ? null : [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: const Text(
                    'Online',
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: const Text(
                    'Offline',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isOffline 
                    ? // For offline mode, show only Local Transfer tab
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Local Transfer', style: TextStyle(color: Colors.white)),
                      )
                    : // For online mode, show both tabs
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: orange,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Local Transfer', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: cardColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text('International Transfer', style: TextStyle(color: textColor)),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              // FamilyMart Banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE3CF),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // FamilyMart Logo (simplified)
                    Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'FamilyMart',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // About FamilyMart Section
              Text(
                'About FamilyMart',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: orange),
              ),
              const SizedBox(height: 12),
              Text(
                'FamilyMart is one of the largest convenience store chains in Japan and Asia. Founded in 1973, it has expanded to multiple countries including Taiwan, Thailand, China, Philippines, and Indonesia, offering a wide range of products from food and beverages to daily necessities.',
                style: TextStyle(color: subTextColor, height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                'FamilyMart is renowned for its high-quality ready-to-eat meals, fresh coffee, and exclusive products like Famichiki (fried chicken) that have gained a cult following among customers.',
                style: TextStyle(color: subTextColor, height: 1.5),
              ),
              const SizedBox(height: 24),
              // Contact Information Section
              Text(
                'Contact Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: orange),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE3CF),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildContactItem(Icons.phone, '+81-3-3989-7301', textColor),
                    const SizedBox(height: 12),
                    _buildContactItem(Icons.email, 'contact@family.co.jp', textColor),
                    const SizedBox(height: 12),
                    _buildContactItem(Icons.language, 'www.family.co.jp', textColor),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.location_on, size: 32, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Proceed to Payment Button
              if (onProceedToPayment != null)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: onProceedToPayment,
                    child: const Text('Proceed to Payment'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, Color textColor) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFF68B00), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }
}

// --- Update: ScanQrPage to navigate based on online/offline state ---
class ScanQrPage extends StatelessWidget {
  final bool isOnline;
  final int pointsBalance;
  final List<Map<String, dynamic>> pointsHistory;
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle})? onPayment;
  final void Function({required int points, required String title, required bool isEarn})? onPointsUpdate;
  const ScanQrPage({super.key, this.isOnline = true, required this.pointsBalance, required this.pointsHistory, this.onPayment, this.onPointsUpdate});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    return Scaffold(
      backgroundColor: const Color(0xFFFAD7B6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAD7B6),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Scan Code', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: orange, width: 6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: _QrFramePainter(orange),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Position the code within the frame',
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Simulate QR scan - navigate to PaymentDetailsPage for Family Mart (local transfer)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => PaymentDetailsPage(
                        isOnline: isOnline,
                        isOfflineLocal: true,
                        merchant: 'FamilyMart',
                        wallet: 'FMB829103720',
                        amount: '',
                        onPayment: onPayment,
                        onPointsUpdate: onPointsUpdate,
                        pointsBalance: pointsBalance,
                        pointsHistory: pointsHistory,
                      ),
                    ),
                  );
                },
                child: const Text('Scan from gallery'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrFramePainter extends CustomPainter {
  final Color borderColor;

  _QrFramePainter(this.borderColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final borderRadius = 12.0;
    final borderLength = 32.0;
    final borderWidth = 8.0;
    final cutOutSize = 180.0;

    // Draw the outer border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ),
      paint,
    );

    // Draw the inner cutout
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (size.width - cutOutSize) / 2,
          (size.height - cutOutSize) / 2,
          cutOutSize,
          cutOutSize,
        ),
        Radius.circular(borderRadius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _QrFramePainter && oldDelegate.borderColor != borderColor;
  }
}

// --- New: PaymentDetailsPage ---
class PaymentDetailsPage extends StatefulWidget {
  final bool isOnline;
  final bool isOfflineLocal;
  final String merchant;
  final String wallet;
  final String amount;
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle})? onPayment;
  final void Function({required int points, required String title, required bool isEarn})? onPointsUpdate;
  final int pointsBalance;
  final List<Map<String, dynamic>> pointsHistory;
  const PaymentDetailsPage({super.key, required this.isOnline, required this.isOfflineLocal, required this.merchant, required this.wallet, required this.amount, this.onPayment, this.onPointsUpdate, required this.pointsBalance, required this.pointsHistory});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  late TextEditingController merchantController;
  late TextEditingController walletController;
  late TextEditingController amountController;
  late TextEditingController referenceController;
  late TextEditingController dateController;
  String country = 'Malaysia';
  double? calculatedAmount;

  // --- Points System State ---
  bool usePoints = false;
  TextEditingController pointsToUseController = TextEditingController();
  double pointsValue = 0.0;
  double finalTotal = 0.0;
  static const int pointsPerRM = 100;

  @override
  void initState() {
    super.initState();
    merchantController = TextEditingController(text: widget.merchant);
    walletController = TextEditingController(text: widget.wallet);
    amountController = TextEditingController(text: widget.amount);
    referenceController = TextEditingController(text: 'TXN-20231105-87654');
    dateController = TextEditingController(text: 'Nov 5, 2023 - 10:45 AM');
    pointsToUseController.text = '0';
    amountController.addListener(_calculateExchangeRate);
    pointsToUseController.addListener(_updatePointsValue);
  }

  void _calculateExchangeRate() {
    final amountText = amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (amountText.isNotEmpty) {
      final amount = double.tryParse(amountText);
      if (amount != null) {
        setState(() {
          calculatedAmount = amount;
        });
      }
    } else {
      setState(() {
        calculatedAmount = null;
      });
    }
    _updatePointsValue();
  }

  void _updatePointsValue() {
    String raw = pointsToUseController.text;
    int enteredPoints = int.tryParse(raw) ?? 0;
    bool needsUpdate = false;
    if (enteredPoints > widget.pointsBalance) {
      enteredPoints = widget.pointsBalance;
      needsUpdate = true;
    }
    if (enteredPoints < 0) {
      enteredPoints = 0;
      needsUpdate = true;
    }
    double deduction = enteredPoints / pointsPerRM;
    double baseAmount = calculatedAmount ?? 0.0;
    if (deduction > baseAmount) {
      deduction = baseAmount;
      enteredPoints = (baseAmount * pointsPerRM).floor();
      needsUpdate = true;
    }
    setState(() {
      pointsValue = usePoints ? deduction : 0.0;
      finalTotal = baseAmount - pointsValue;
    });
    if (needsUpdate && raw != enteredPoints.toString()) {
      // Only update the controller if clamping was needed
      pointsToUseController.text = enteredPoints.toString();
      pointsToUseController.selection = TextSelection.fromPosition(TextPosition(offset: pointsToUseController.text.length));
    }
  }

  @override
  void dispose() {
    amountController.removeListener(_calculateExchangeRate);
    merchantController.dispose();
    walletController.dispose();
    amountController.dispose();
    referenceController.dispose();
    dateController.dispose();
    pointsToUseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final isOnline = widget.isOnline;
    final bgColor = isOnline ? const Color(0xFFF7F7F7) : const Color(0xFF181818);
    final cardColor = isOnline ? Colors.white : const Color(0xFFFAD7B6);
    final textColor = isOnline ? Colors.black : Colors.black;
    final subTextColor = isOnline ? Colors.black54 : Colors.black87;
    final baseAmount = calculatedAmount ?? 0.0;
    final canUsePoints = widget.pointsBalance > 0 && baseAmount > 0;
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isOnline ? Colors.black : Colors.white),
        title: Text('Payment Details', style: TextStyle(color: isOnline ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: orange)),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField('Merchant Name', merchantController, textColor, subTextColor),
                    const SizedBox(height: 12),
                    _buildField('Wallet ID', walletController, textColor, subTextColor),
                    const SizedBox(height: 12),
                    _buildDropdownField('Country', country, (val) => setState(() => country = val!), textColor, subTextColor),
                    const SizedBox(height: 12),
                    _buildField('Amount', amountController, textColor, subTextColor),
                    // --- Use Points Section ---
                    if (canUsePoints && isOnline) ...[
                      const SizedBox(height: 24),
                      Text('Use Points', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: orange)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE3CF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Your Points Balance', style: TextStyle(color: subTextColor)),
                                    Text(
                                      '${widget.pointsBalance.toString()} points',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Equivalent to', style: TextStyle(color: subTextColor)),
                                    Text(
                                      'RM ${(widget.pointsBalance / pointsPerRM).toStringAsFixed(2)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Text('Exchange Rate:', style: TextStyle(color: Colors.black54)),
                                  const SizedBox(width: 8),
                                  Text('RM 1 = $pointsPerRM points', style: const TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Checkbox(
                                  value: usePoints,
                                  onChanged: (val) {
                                    setState(() {
                                      usePoints = val ?? false;
                                    });
                                    _updatePointsValue();
                                  },
                                ),
                                const Text('Apply points to this payment', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            if (usePoints) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Points to use:'),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller: pointsToUseController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      ),
                                      inputFormatters: [],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('of ${widget.pointsBalance}', style: TextStyle(color: subTextColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Points Value', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('- RM ${pointsValue.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Final Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('RM ${(baseAmount - (usePoints ? pointsValue : 0.0)).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    // --- End Use Points Section ---
                    const SizedBox(height: 12),
                    _buildField('Reference ID', referenceController, textColor, subTextColor),
                    const SizedBox(height: 12),
                    _buildField('Date & Time', dateController, textColor, subTextColor),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: calculatedAmount != null && calculatedAmount! > 0
                          ? () {
                              final payAmount = baseAmount - (usePoints ? pointsValue : 0.0);
                              final now = DateTime.now();
                              final subtitle = formatTransactionSubtitle(context, now);
                              
                              // Update points if used
                              if (usePoints && (pointsToUseController.text != '0')) {
                                final usedPoints = int.tryParse(pointsToUseController.text) ?? 0;
                                if (widget.onPointsUpdate != null && usedPoints > 0) {
                                  widget.onPointsUpdate!(points: usedPoints, title: 'Points Redeemed for ${widget.merchant}', isEarn: false);
                                }
                              }
                              
                              if (widget.isOfflineLocal) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PinVerificationPage(
                                      isOnline: isOnline,
                                      isOfflineLocal: widget.isOfflineLocal,
                                      amount: payAmount,
                                      merchant: widget.merchant,
                                      onPayment: widget.onPayment != null
                                        ? ({required double amount, required String merchant, required bool isDebit, required String subtitle}) {
                                            widget.onPayment!(amount: amount, merchant: merchant, isDebit: isDebit, subtitle: subtitle);
                                          }
                                        : null,
                                      onPointsUpdate: widget.onPointsUpdate,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ExchangeRateSelectionPage(
                                      sendAmount: payAmount,
                                      sendCurrency: 'RM',
                                      receiveCurrency: 'EUR',
                                      onPayment: widget.onPayment,
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Text(widget.isOfflineLocal ? 'Pay Now' : 'Continue'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: orange,
                        side: BorderSide(color: orange, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, Color textColor, Color subTextColor) {
    final isOnline = widget.isOnline;
    final inputBgColor = isOnline ? Colors.white : Colors.white;
    final inputTextColor = isOnline ? Colors.black : Colors.black;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          readOnly: label == 'Country' || label == 'Reference ID' || label == 'Date & Time',
          style: TextStyle(color: inputTextColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            hintText: label == 'Amount' ? 'Enter amount (e.g., 24.99)' : null,
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, ValueChanged<String?> onChanged, Color textColor, Color subTextColor) {
    final isOnline = widget.isOnline;
    final inputBgColor = isOnline ? Colors.white : Colors.white;
    final inputTextColor = isOnline ? Colors.black : Colors.black;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: const [
            DropdownMenuItem(value: 'Malaysia', child: Text('Malaysia')),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
          style: TextStyle(color: inputTextColor),
          dropdownColor: inputBgColor,
        ),
      ],
    );
  }
}
 
// --- New: PinVerificationPage ---
class PinVerificationPage extends StatefulWidget {
  final bool isOnline;
  final bool isOfflineLocal;
  final double amount;
  final String merchant;
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle})? onPayment;
  final void Function({required int points, required String title, required bool isEarn})? onPointsUpdate;
  const PinVerificationPage({
    super.key, 
    required this.isOnline, 
    required this.isOfflineLocal, 
    required this.amount, 
    required this.merchant,
    this.onPayment,
    this.onPointsUpdate,
  });

  @override
  State<PinVerificationPage> createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  final List<TextEditingController> pinControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  String enteredPin = '';
  int remainingAttempts = 3;
  bool isIncorrectPin = false;
  static const String correctPin = '123456';

  @override
  void initState() {
    super.initState();
    // Add listeners to handle PIN input
    for (int i = 0; i < 6; i++) {
      pinControllers[i].addListener(() {
        _handlePinInput(i);
      });
    }
  }

  void _handlePinInput(int index) {
    final text = pinControllers[index].text;
    if (text.length == 1) {
      // Move to next field
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      }
    } else if (text.isEmpty && index > 0) {
      // Move to previous field on backspace
      focusNodes[index - 1].requestFocus();
    }
    
    // Update entered PIN
    setState(() {
      enteredPin = pinControllers.map((controller) => controller.text).join();
    });
  }

  void _verifyPin() {
    if (enteredPin == correctPin) {
      // Correct PIN - navigate to success page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PinVerifiedPage(
            isOnline: widget.isOnline,
            isOfflineLocal: widget.isOfflineLocal,
            amount: widget.amount,
            merchant: widget.merchant,
            onPayment: widget.onPayment,
            onPointsUpdate: widget.onPointsUpdate,
          ),
        ),
      );
    } else {
      // Incorrect PIN
      setState(() {
        remainingAttempts--;
        isIncorrectPin = true;
        // Clear all PIN fields
        for (var controller in pinControllers) {
          controller.clear();
        }
        enteredPin = '';
        // Focus on first field
        focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 6; i++) {
      pinControllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final isOnline = widget.isOnline;
    final bgColor = isOnline ? const Color(0xFFF7F7F7) : const Color(0xFF181818);
    final textColor = isOnline ? Colors.black : Colors.white;
    final subTextColor = isOnline ? Colors.black54 : Colors.white70;
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isOnline ? Colors.black : Colors.white),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.account_balance_wallet_rounded, color: orange, size: 32),
            ),
            Text(
              'Swytch',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {}, // No action needed for PIN page
                  child: Container(
                    decoration: BoxDecoration(
                      color: isOnline ? orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Online',
                      style: TextStyle(
                        color: isOnline ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {}, // No action needed for PIN page
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isOnline ? orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Offline',
                      style: TextStyle(
                        color: !isOnline ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon (if incorrect PIN) or Shield Icon (if first attempt)
              if (isIncorrectPin) ...[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAD7B6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.warning,
                      size: 60,
                      color: orange,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Error Title
                Text(
                  'Incorrect PIN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Error Message
                Text(
                  'The PIN you entered is invalid.\nPlease check and try again.',
                  style: TextStyle(
                    fontSize: 16,
                    color: subTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Warning Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAD7B6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: orange, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: orange, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You have $remainingAttempts attempts remaining before your account is temporarily locked.',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ] else ...[
                // Shield Icon
                Icon(
                  Icons.shield,
                  size: 80,
                  color: orange,
                ),
                const SizedBox(height: 24),
                
                // Title
                Text(
                  'PIN Verification',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: orange,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  'Please enter your security PIN to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: subTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
              
              // PIN Label
              Text(
                isIncorrectPin ? 'Enter your PIN again' : 'Enter PIN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: orange,
                ),
              ),
              const SizedBox(height: 16),
              
              // PIN Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.white : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: focusNodes[index].hasFocus ? orange : Colors.grey[300]!,
                        width: focusNodes[index].hasFocus ? 2 : 1,
                      ),
                    ),
                    child: TextField(
                      controller: pinControllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              
              // Verify PIN Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: enteredPin.length == 6
                      ? () {
                          _verifyPin();
                        }
                      : null,
                  child: const Text(
                    'Verify PIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
 
// --- New: PinVerifiedPage ---
class PinVerifiedPage extends StatelessWidget {
  final bool isOnline;
  final bool isOfflineLocal;
  final double amount;
  final String merchant;
  final void Function({required double amount, required String merchant, required bool isDebit, required String subtitle})? onPayment;
  final void Function({required int points, required String title, required bool isEarn})? onPointsUpdate;
  const PinVerifiedPage({
    super.key, 
    required this.isOnline, 
    required this.isOfflineLocal, 
    required this.amount, 
    required this.merchant,
    this.onPayment,
    this.onPointsUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final isOnline = this.isOnline;
    final bgColor = isOnline ? const Color(0xFFF7F7F7) : const Color(0xFF181818);
    final cardColor = isOnline ? Colors.white : const Color(0xFFFAD7B6);
    final textColor = isOnline ? Colors.black : Colors.white;
    final subTextColor = isOnline ? Colors.black54 : Colors.white70;
    // Generate transaction ID
    final transactionId = 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final currentDate = DateTime.now();
    final formattedDate = '${_getMonthName(currentDate.month)} ${currentDate.day}, ${currentDate.year}';
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.account_balance_wallet_rounded, color: orange, size: 32),
            ),
            Text(
              'Swytch',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        // Remove actions (online/offline toggle)
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAD7B6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Success Title
              Text(
                'PIN Verified Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: orange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Processing Message
              Text(
                'Your payment is being processed securely.\nYou will receive a confirmation shortly.',
                style: TextStyle(
                  fontSize: 16,
                  color: subTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Separator Line
              Container(
                height: 2,
                color: orange,
              ),
              const SizedBox(height: 16),
              // Security Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield, color: orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Transaction secured with SecurePIN',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Transaction Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildTransactionRow('Transaction ID:', transactionId, (!isOnline && isOfflineLocal) ? Colors.black : textColor),
                    const SizedBox(height: 12),
                    _buildTransactionRow('Amount:', 'RM ${amount.toStringAsFixed(2)}', (!isOnline && isOfflineLocal) ? Colors.black : textColor),
                    const SizedBox(height: 12),
                    _buildTransactionRow('Date:', formattedDate, (!isOnline && isOfflineLocal) ? Colors.black : textColor),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (onPayment != null) {
                      final now = DateTime.now();
                      final subtitle = formatTransactionSubtitle(context, now);
                      onPayment!(amount: amount, merchant: merchant, isDebit: true, subtitle: subtitle);
                    }
                    // Navigate back to home page and clear the navigation stack
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    'Return to Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionRow(String label, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

String formatTransactionSubtitle(BuildContext context, DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final txDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final timeStr = TimeOfDay.fromDateTime(dateTime).format(context);
  if (txDay == today) {
    return 'Today, $timeStr';
  } else if (txDay == yesterday) {
    return 'Yesterday, $timeStr';
  } else {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}, $timeStr';
  }
}

// --- New: SPointsPage ---
class SPointsPage extends StatelessWidget {
  final bool isOnline;
  final int pointsBalance;
  final List<Map<String, dynamic>> pointsHistory;
  final void Function({required int points, required String title, required bool isEarn}) onPointsUpdate;
  const SPointsPage({super.key, required this.isOnline, required this.pointsBalance, required this.pointsHistory, required this.onPointsUpdate});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final bgColor = isOnline ? const Color(0xFFF7F7F7) : const Color(0xFF181818);
    final cardColor = isOnline ? Colors.white : const Color(0xFF232323);
    final textColor = isOnline ? Colors.black : Colors.white;
    final subTextColor = isOnline ? Colors.black54 : Colors.white70;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text('Your Rewards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: textColor)),
                const SizedBox(height: 4),
                Text('Earn and redeem points at local businesses', style: TextStyle(color: subTextColor, fontSize: 15)),
                const SizedBox(height: 20),
                // Points Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Available Points', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const HowPointsWorkPage()),
                              );
                            },
                            child: Icon(Icons.info_outline, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(pointsBalance.toString(), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(width: 6),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text('points', style: TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Points value: RM${(pointsBalance / 100).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Redeem Points Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Redeem Points', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
                    Text('See all', style: TextStyle(color: orange, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.monetization_on_rounded, color: orange, size: 32),
                            const SizedBox(height: 6),
                            Text('Points', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            Text('Points balance', style: TextStyle(color: subTextColor, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const VendorPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.storefront_rounded, color: orange, size: 32),
                              const SizedBox(height: 6),
                              Text('Local Shops', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                              Text('Earn & Spend Points Here', style: TextStyle(color: subTextColor, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // Points History
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Points History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
                    Text('This Month', style: TextStyle(color: orange, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pointsHistory.length,
                  itemBuilder: (context, i) {
                    final tx = pointsHistory[i];
                    final iconBg = tx['isEarn']
                        ? const Color(0xFFD0FFE5)
                        : const Color(0xFFFFE5D0);
                    final iconColor = tx['isEarn'] ? Colors.green : orange;
                    IconData iconData;
                    switch (tx['title']) {
                      case 'Green Cafe':
                        iconData = Icons.restaurant;
                        break;
                      case 'Eco Market':
                        iconData = Icons.shopping_bag;
                        break;
                      case 'Local Threads':
                        iconData = Icons.emoji_people;
                        break;
                      case 'Points Redeemed':
                        iconData = Icons.card_giftcard;
                        break;
                      default:
                        iconData = tx['icon'] ?? Icons.monetization_on_rounded;
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(iconData, color: iconColor, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tx['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                                Text(tx['date'], style: TextStyle(color: subTextColor, fontSize: 13)),
                              ],
                            ),
                          ),
                          Text(
                            (tx['isEarn'] ? '+' : '-') + tx['points'].toString() + ' pts',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: tx['isEarn'] ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // No redeem button at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- New: VendorPage ---
class VendorPage extends StatelessWidget {
  const VendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final cardColor = Colors.white;
    final subTextColor = Colors.black54;
    final vendorsNearby = [
      {
        'name': 'Burger JI Legend Puchong',
        'img': '',
        'address': 'Jalan Bandar Puchong, Selangor',
        'percentage': 7,
        'reviews': 120,
        'rating': 4.7,
        'distance': 0.3,
        'category': 'Burger Stall',
      },
      {
        'name': 'Yau Soya 【堯豆浆】',
        'img': '',
        'address': 'Taman Muda, Cheras, Kuala Lumpur',
        'percentage': 5,
        'reviews': 98,
        'rating': 4.8,
        'distance': 0.5,
        'category': 'Soya Milk Stall',
      },
      {
        'name': 'ABC Cendol Klasik',
        'img': '',
        'address': 'Seksyen 7, Shah Alam, Selangor',
        'percentage': 4,
        'reviews': 75,
        'rating': 4.0,
        'distance': 0.8,
        'category': 'Dessert Stall',
      },
    ];
    final vendorsPopular = [
      {
        'name': 'Ayam Goreng Berhantu',
        'img': '',
        'address': 'Jalan Pandan Medan Kampung Pandan Dalam 55100 Kuala Lumpur, Selangor',
        'percentage': 3,
        'reviews': 89,
        'rating': 4.6,
        'distance': 0.7,
        'category': 'Street Food',
      },
      {
        'img': '',
        'name': 'Delicious Cucur Udang Fried Hot Hot!',
        'address': 'Restoran Mak Kimbong, 13, Jalan 4/1a, Seksyen 4 Tambahan Bandar Baru Bangi, Bandar Baru Bangi, Selangor',
        'percentage': 3,
        'reviews': 62,
        'rating': 4.1,
        'distance': 1.2,
        'category': 'Street Food',
      },
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Local Vendors', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: orange, size: 20),
                  const SizedBox(width: 6),
                  Text('Showing vendors near: Downtown Seattle', style: TextStyle(color: subTextColor, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search vendors...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
              const SizedBox(height: 24),
              Text('Nearby Vendors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              ...vendorsNearby.map((v) => VendorCardWidget(v, orange, cardColor, subTextColor)),
              const SizedBox(height: 24),
              Text('Popular Vendors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              ...vendorsPopular.map((v) => VendorCardWidget(v, orange, cardColor, subTextColor)),
            ],
          ),
        ),
      ),
    );
  }
}

// --- New: VendorDetailsPage ---
class VendorDetailsPage extends StatelessWidget {
  final Map vendor;
  const VendorDetailsPage({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    final cardColor = Colors.white;
    final subTextColor = Colors.black54;
    final isYauSoya = vendor['name'] == 'Yau Soya 【堯豆浆】';
    final isBurgerJI = vendor['name'] == 'Burger JI Legend Puchong';
    final isCendol = vendor['name'] == 'ABC Cendol Klasik';
    final isAyamGoreng = vendor['name'] == 'Ayam Goreng Berhantu';
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Vendor Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            vendor['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        if (vendor['percentage'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              '${vendor['percentage']}%',
                              style: TextStyle(
                                color: orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Removed rating Container here
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(isBurgerJI ? 'Open: 7AM - 12PM' : isYauSoya ? 'Open: 7AM - 12PM' : isCendol ? 'Open: 7AM - 12PM' : isAyamGoreng ? 'Open: 7AM - 12PM' : 'Open: 8AM - 9PM', style: const TextStyle(color: Colors.black87)),
                  const SizedBox(width: 16),
                  const Icon(Icons.phone, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(isBurgerJI ? '-' : isYauSoya ? '-' : isCendol ? '-' : isAyamGoreng ? '-' : '+60 123-4567', style: const TextStyle(color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                isAyamGoreng
                  ? 'Ayam Goreng Berhantu is a famous street food stall in Kampung Pandan Dalam, serving crispy, spicy fried chicken, nasi lemak, and local favorites. Known for its secret marinade and addictive sambal, this spot is a must-try for fried chicken lovers!'
                  : isCendol
                    ? 'ABC Cendol Klasik is a famous dessert stall in Shah Alam, serving traditional Malaysian cendol, ABC (Ais Batu Campur), and other refreshing treats. Popular for its creamy coconut milk, gula Melaka, and generous toppings. A perfect stop for a sweet, cooling dessert on a hot day!'
                    : isBurgerJI
                      ? 'Burger JI Legend Puchong is a legendary Malaysian burger stall famous for its juicy Ramly burgers, crispy fries, and late-night vibes. Locals love the signature "Burger Special" with double patties, egg, and homemade sauce. Friendly service and affordable prices make this a must-visit for burger lovers!'
                      : isYauSoya
                        ? 'Yau Soya is a beloved street vendor in Taman Muda, serving fresh soya bean drinks and traditional snacks every morning. Locals flock here for their signature soya milk, tau fu fa, and friendly service.'
                        : 'Green Harvest is a family-owned organic cafe and grocery store committed to sustainable practices. We source all our ingredients locally and offer a variety of healthy, delicious options for breakfast, lunch, and dinner.',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: isAyamGoreng
                  ? const [
                      Chip(label: Text('Fried Chicken'), backgroundColor: Color(0xFFFBE3CF)),
                      Chip(label: Text('Nasi Lemak'), backgroundColor: Color(0xFFFBE3CF)),
                      Chip(label: Text('Sambal'), backgroundColor: Color(0xFFFBE3CF)),
                      Chip(label: Text('Street Food'), backgroundColor: Color(0xFFFBE3CF)),
                      Chip(label: Text('Crispy'), backgroundColor: Color(0xFFFBE3CF)),
                    ]
                  : isCendol
                    ? const [
                        Chip(label: Text('Cendol'), backgroundColor: Color(0xFFFBE3CF)),
                        Chip(label: Text('ABC'), backgroundColor: Color(0xFFFBE3CF)),
                        Chip(label: Text('Dessert'), backgroundColor: Color(0xFFFBE3CF)),
                        Chip(label: Text('Shaved Ice'), backgroundColor: Color(0xFFFBE3CF)),
                        Chip(label: Text('Gula Melaka'), backgroundColor: Color(0xFFFBE3CF)),
                      ]
                    : isBurgerJI
                      ? const [
                          Chip(label: Text('Ramly Burger'), backgroundColor: Color(0xFFFBE3CF)),
                          Chip(label: Text('Double Special'), backgroundColor: Color(0xFFFBE3CF)),
                          Chip(label: Text('Crispy Fries'), backgroundColor: Color(0xFFFBE3CF)),
                          Chip(label: Text('Late Night'), backgroundColor: Color(0xFFFBE3CF)),
                          Chip(label: Text('Street Food'), backgroundColor: Color(0xFFFBE3CF)),
                        ]
                      : isYauSoya
                        ? const [
                            Chip(label: Text('Soya Milk'), backgroundColor: Color(0xFFFBE3CF)),
                            Chip(label: Text('Tau Fu Fa'), backgroundColor: Color(0xFFFBE3CF)),
                            Chip(label: Text('Street Food'), backgroundColor: Color(0xFFFBE3CF)),
                            Chip(label: Text('Breakfast'), backgroundColor: Color(0xFFFBE3CF)),
                          ]
                        : const [
                            Chip(label: Text('Organic'), backgroundColor: Color(0xFFFBE3CF)),
                            Chip(label: Text('Sustainable'), backgroundColor: Color(0xFFFBE3CF)),
                            Chip(label: Text('Vegan Options'), backgroundColor: Color(0xFFFBE3CF)),
                            Chip(label: Text('Gluten-Free'), backgroundColor: Color(0xFFFBE3CF)),
                          ],
              ),
              const SizedBox(height: 16),
              const Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(isAyamGoreng ? vendor['address'] ?? '' : isCendol ? vendor['address'] ?? '' : isBurgerJI ? vendor['address'] ?? '' : isYauSoya ? vendor['address'] ?? '' : '123 Eco Street, Green Valley, CA 94123', style: const TextStyle(color: Colors.black87))),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: orange, side: BorderSide(color: orange)),
                      onPressed: () {},
                      child: const Text('Directions'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: orange, side: BorderSide(color: orange)),
                      onPressed: () {},
                      child: const Text('Share'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Menu Highlights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              if (isBurgerJI) ...[
                _MenuItemTile(
                  img: '',
                  name: 'Burger Double Special',
                  desc: 'Double Ramly beef patties, egg, cheese, homemade sauce',
                  price: 'RM7.00',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Chicken Burger Cheese',
                  desc: 'Crispy chicken, cheese, lettuce, mayo',
                  price: 'RM5.50',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Hot Dog Jumbo',
                  desc: 'Grilled jumbo sausage, onions, chili sauce',
                  price: 'RM4.00',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Crispy Fries',
                  desc: 'Golden fries, cheese sauce or spicy powder',
                  price: 'RM3.00',
                ),
              ] else if (isYauSoya) ...[
                _MenuItemTile(
                  img: '',
                  name: 'Soya Bean Milk',
                  desc: 'Freshly made, served hot or cold',
                  price: 'RM2.00',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Tau Fu Fa',
                  desc: 'Silky tofu pudding with syrup',
                  price: 'RM2.50',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'You Tiao',
                  desc: 'Chinese fried dough stick',
                  price: 'RM1.50',
                ),
              ] else if (isCendol) ...[
                _MenuItemTile(
                  img: '',
                  name: 'Cendol Klasik',
                  desc: 'Shaved ice, coconut milk, gula Melaka, green jelly',
                  price: 'RM3.50',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'ABC (Ais Batu Campur)',
                  desc: 'Shaved ice, red beans, sweet corn, jelly, syrup',
                  price: 'RM4.00',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Cendol Pulut',
                  desc: 'Cendol with glutinous rice',
                  price: 'RM4.50',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Cendol Durian',
                  desc: 'Cendol with durian topping (seasonal)',
                  price: 'RM7.00',
                ),
              ] else if (isAyamGoreng) ...[
                _MenuItemTile(
                  img: '',
                  name: 'Ayam Goreng Berempah',
                  desc: 'Spiced fried chicken, crispy and juicy',
                  price: 'RM4.00',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Nasi Lemak Ayam',
                  desc: 'Coconut rice, fried chicken, sambal, egg',
                  price: 'RM6.50',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Sambal Sotong',
                  desc: 'Spicy squid sambal, served with rice',
                  price: 'RM5.50',
                ),
                _MenuItemTile(
                  img: '',
                  name: 'Teh Ais',
                  desc: 'Iced milk tea, Malaysian style',
                  price: 'RM2.00',
                ),
              ] else ... [
                // existing Green Earth Cafe menu
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: const Text('View Full Menu'),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Rewards Available', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _RewardTile(
                icon: Icons.local_offer,
                label: isAyamGoreng ? 'Free Teh Ais with 3 Nasi Lemak' : isCendol ? 'Free ABC with 5 Cendol Purchases' : isBurgerJI ? 'Buy 2 Burgers, Get 1 Fries Free' : isYauSoya ? 'Free Soya Milk with 10 Purchases' : '10% Off First Order',
                onPressed: () {},
              ),
              _RewardTile(
                icon: Icons.coffee,
                label: isAyamGoreng ? 'RM1 Off Ayam Goreng Berempah (with points)' : isCendol ? 'RM1 Off Cendol Durian (with points)' : isBurgerJI ? 'RM2 Off Double Special (with points)' : isYauSoya ? 'RM1 Off Tau Fu Fa (with points)' : 'Free Coffee with RM20 Purchase',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final String img;
  final String name;
  final String desc;
  final String price;
  const _MenuItemTile({required this.img, required this.name, required this.desc, required this.price});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Removed image
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _RewardTile({required this.icon, required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: onPressed,
          child: const Text('Redeem'),
        ),
      ),
    );
  }
}

// Add this widget:
class VendorCardWidget extends StatelessWidget {
  final Map v;
  final Color orange;
  final Color cardColor;
  final Color subTextColor;
  const VendorCardWidget(this.v, this.orange, this.cardColor, this.subTextColor, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isOnline = true;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VendorDetailsPage(vendor: v),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isOnline ? const Color(0xFFE0E0E0) : Colors.transparent),
        ),
        child: Row(
          children: [
            // Removed vendor image
            // const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          v['name'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        ),
                      ),
                      if (v['percentage'] != null)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.monetization_on_rounded, color: orange, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                '${v['percentage']}%',
                                style: TextStyle(color: orange, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (v['code'] != null)
                    Text(v['code'], style: TextStyle(color: subTextColor, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
// Add HowPointsWorkPage widget:
class HowPointsWorkPage extends StatelessWidget {
  const HowPointsWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFF68B00);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('How Swytch Rewards Work', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('How Swytch Rewards Work', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 6),
              const Text('Earn points and redeem rewards while supporting local businesses in your community.', style: TextStyle(color: Colors.black87)),
              const SizedBox(height: 24),
              // Step 1
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Shop Local', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          const Text('Make a purchase at any participating local business in the Swytch network.', style: TextStyle(color: Colors.black87)),
                          const SizedBox(height: 10),
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.store, size: 60, color: Colors.black26),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Step 2
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Earn Points Instantly', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          const Text('Points are automatically credited to your account based on your purchase amount.', style: TextStyle(color: Colors.black87)),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Purchase Amount', style: TextStyle(color: Colors.black54)),
                                Text('RM25.00', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Points Earned', style: TextStyle(color: Colors.black54)),
                                Text('+2500pts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Step 3
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Redeem Rewards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          const Text('Use your points for discounts on necessities or special items from local vendors.', style: TextStyle(color: Colors.black87)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _RewardExample(icon: Icons.shopping_basket, label: 'Groceries', points: '500 pts'),
                              const SizedBox(width: 12),
                              _RewardExample(icon: Icons.directions_transit, label: 'Transit Pass', points: '750 pts'),
                              const SizedBox(width: 12),
                              _RewardExample(icon: Icons.receipt_long, label: 'Utility Bill', points: '1000 pts'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Points System Info
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Points System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Every RM1 spent = 100 points earned', style: TextStyle(color: Colors.black87))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Points valid for 12 months from date earned', style: TextStyle(color: Colors.black87))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Bonus points for frequent shoppers', style: TextStyle(color: Colors.black87))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back to Dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardExample extends StatelessWidget {
  final IconData icon;
  final String label;
  final String points;
  const _RewardExample({required this.icon, required this.label, required this.points});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.orange, size: 28),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(points, style: const TextStyle(color: Colors.orange, fontSize: 12)),
      ],
    );
  }
}
 
// Add this custom painter at the end of the file:

class _MonthlyBarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Example bar data (height as a fraction of max)
    final barHeights = [0.35, 0.55, 0.8, 0.7, 1.0, 0.6, 0.7, 0.7, 0.6, 0.4, 0.55, 0.2];
    final barColors = [
      Color(0xFF7C4A03), Color(0xFFB86B1F), Color(0xFFF6C16B), Color(0xFFF6A44B),
      Color(0xFFFFE08C), Color(0xFFB86B1F), Color(0xFFF6A44B), Color(0xFFF6A44B),
      Color(0xFFB86B1F), Color(0xFF7C4A03), Color(0xFFB86B1F), Color(0xFF7C4A03),
    ];
    final barWidth = size.width / (barHeights.length * 1.5);
    final barSpacing = barWidth * 0.5;
    final maxBarHeight = size.height * 0.8;
    final baseY = size.height * 0.95;
    for (int i = 0; i < barHeights.length; i++) {
      final left = i * (barWidth + barSpacing);
      final top = baseY - barHeights[i] * maxBarHeight;
      final rect = Rect.fromLTWH(left, top, barWidth, barHeights[i] * maxBarHeight);
      final paint = Paint()..color = barColors[i % barColors.length];
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(4)), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
 