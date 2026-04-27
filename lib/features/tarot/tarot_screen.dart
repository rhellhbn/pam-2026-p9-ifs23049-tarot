import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/reading_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reading_provider.dart';
import 'reading_detail_screen.dart';
import 'tarot_helpers.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedSpread = 'three_card';

  final List<Map<String, String>> _spreadOptions = [
    {'value': 'single', 'label': 'Kartu Tunggal', 'emoji': '🃏', 'desc': '1 kartu'},
    {'value': 'three_card', 'label': '3 Kartu', 'emoji': '🔮', 'desc': 'Masa lalu · kini · depan'},
    {'value': 'celtic_cross', 'label': 'Celtic Cross', 'emoji': '✝', 'desc': '10 kartu'},
  ];

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    context.read<ReadingProvider>().fetchReadings(auth.token!);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        final auth = context.read<AuthProvider>();
        context.read<ReadingProvider>().fetchReadings(auth.token!);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return date;
    }
  }

  Future<void> _refreshReadings() async {
    final auth = context.read<AuthProvider>();
    final provider = context.read<ReadingProvider>();
    provider.reset();
    await provider.fetchReadings(auth.token!);
  }

  void _showGenerateDialog() {
    final questionController = TextEditingController();
    String selectedSpread = _selectedSpread;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Consumer<ReadingProvider>(
              builder: (context, provider, _) {
                return AlertDialog(
                  backgroundColor: AppColors.cosmicPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(
                      color: AppColors.astraMauve,
                      width: 1,
                    ),
                  ),
                  title: const Row(
                    children: [
                      Text("🔮 ", style: TextStyle(fontSize: 22)),
                      Text(
                        "Buka Tirai Takdir",
                        style: TextStyle(
                          color: AppColors.stardustPink,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Apa pertanyaan yang ingin kamu tanyakan kepada semesta?",
                          style: TextStyle(
                            color: AppColors.astraMauve,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: questionController,
                          maxLines: 3,
                          maxLength: 500,
                          style: const TextStyle(color: AppColors.moonGlow),
                          decoration: const InputDecoration(
                            hintText: 'Contoh: Apa yang menanti saya di masa depan?',
                            counterStyle: TextStyle(color: AppColors.astraMauve),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Pilih Spread",
                          style: TextStyle(
                            color: AppColors.astraMauve,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...(_spreadOptions.map((spread) {
                          final isSelected = selectedSpread == spread['value'];
                          return GestureDetector(
                            onTap: () => setDialogState(
                                () => selectedSpread = spread['value']!),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.mysticIndigo
                                    : AppColors.nebulaPurple.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.stardustPink
                                      : AppColors.astraMauve.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(spread['emoji']!,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        spread['label']!,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.moonGlow
                                              : AppColors.astraMauve,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        spread['desc']!,
                                        style: const TextStyle(
                                          color: AppColors.astraMauve,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isSelected) ...[
                                    const Spacer(),
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.stardustPink,
                                      size: 18,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        })),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: provider.isGenerating
                          ? null
                          : () => Navigator.pop(dialogContext),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: AppColors.astraMauve),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [AppColors.mysticIndigo, AppColors.nebulaPurple],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: provider.isGenerating
                            ? null
                            : () async {
                                final token =
                                    context.read<AuthProvider>().token!;
                                final reading = await provider.generateReading(
                                  token,
                                  questionController.text,
                                  selectedSpread,
                                );
                                if (!dialogContext.mounted) return;
                                Navigator.pop(dialogContext);

                                if (reading != null && context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ReadingDetailScreen(reading: reading),
                                    ),
                                  );
                                } else if (provider.errorMessage != null &&
                                    context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(provider.errorMessage!),
                                      backgroundColor: AppColors.challenging,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: provider.isGenerating
                            ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Membuka...'),
                                ],
                              )
                            : const Text(
                                '✦ Buka Tirai',
                                style: TextStyle(color: AppColors.moonGlow),
                              ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _confirmDelete(TarotReading reading) {
    final auth = context.read<AuthProvider>();
    final provider = context.read<ReadingProvider>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cosmicPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.astraMauve),
        ),
        title: const Text(
          'Hapus Ramalan',
          style: TextStyle(color: AppColors.stardustPink),
        ),
        content: Text(
          'Hapus ramalan ini?',
          style: const TextStyle(color: AppColors.moonGlow),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.astraMauve)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.challenging),
            onPressed: () {
              provider.deleteReading(auth.token!, reading.id);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<ReadingProvider>();
    final username = auth.user?.username ?? 'Penjelajah';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text(
          '✦ TarotAI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.stardustPink,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout, color: AppColors.astraMauve),
            onPressed: () {
              auth.logout();
              context.read<ReadingProvider>().reset();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showGenerateDialog,
        backgroundColor: AppColors.mysticIndigo,
        foregroundColor: AppColors.moonGlow,
        icon: const Text("🔮", style: TextStyle(fontSize: 18)),
        label: const Text(
          "Buka Tirai",
          style: TextStyle(letterSpacing: 1),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshReadings,
            color: AppColors.stardustPink,
            backgroundColor: AppColors.cosmicPurple,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 120, top: 8),
              itemCount: _listItemCount(provider),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      _buildWelcomeCard(username, provider.readings.length),
                      const SizedBox(height: 8),
                    ],
                  );
                }

                if (provider.readings.isEmpty && !provider.isLoading) {
                  return _buildEmptyState();
                }

                final readingIndex = index - 1;
                if (readingIndex < provider.readings.length) {
                  return _buildReadingCard(
                      provider.readings[readingIndex], readingIndex);
                }

                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.stardustPink,
                    ),
                  ),
                );
              },
            ),
          ),
          if (provider.isGenerating)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("🔮", style: TextStyle(fontSize: 60)),
                    SizedBox(height: 20),
                    CircularProgressIndicator(color: AppColors.stardustPink),
                    SizedBox(height: 16),
                    Text(
                      'Membuka tirai semesta...',
                      style: TextStyle(
                        color: AppColors.stardustPink,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kartu sedang dibaca...',
                      style: TextStyle(
                        color: AppColors.astraMauve,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  int _listItemCount(ReadingProvider provider) {
    if (provider.readings.isEmpty && !provider.isLoading) {
      return 2;
    }
    return 1 + provider.readings.length + (provider.isLoading ? 1 : 0);
  }

  Widget _buildWelcomeCard(String username, int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.nebulaPurple, AppColors.mysticIndigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.stardustPink.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.nebulaPurple.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text("🔮", style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, $username ✨',
                  style: const TextStyle(
                    color: AppColors.moonGlow,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count ramalan tersimpan • tarik untuk refresh',
                  style: const TextStyle(
                    color: AppColors.astraMauve,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.cosmicPurple,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.astraMauve.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("✨", style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'Belum ada ramalan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.stardustPink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tekan tombol "Buka Tirai" untuk\nmemulai perjalanan spiritualmu',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.astraMauve, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCard(TarotReading reading, int index) {
    final energyColor = getEnergyColor(reading.energy);
    final firstCard = reading.cardsDrawn.isNotEmpty ? reading.cardsDrawn[0] : null;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReadingDetailScreen(reading: reading),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cosmicPurple,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: energyColor.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: energyColor.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Spread icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    energyColor.withValues(alpha: 0.3),
                    AppColors.nebulaPurple,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: energyColor.withValues(alpha: 0.4),
                ),
              ),
              child: Center(
                child: Text(
                  getSpreadEmoji(reading.spreadType),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${reading.question}"',
                    style: const TextStyle(
                      color: AppColors.moonGlow,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: energyColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          getEnergyLabel(reading.energy),
                          style: TextStyle(
                            color: energyColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (firstCard != null)
                        Text(
                          firstCard.name,
                          style: TextStyle(
                            color: getCardColor(firstCard.name),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(reading.createdAt),
                    style: const TextStyle(
                      color: AppColors.astraMauve,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.challenging,
                size: 20,
              ),
              onPressed: () => _confirmDelete(reading),
            ),
          ],
        ),
      ),
    );
  }
}
