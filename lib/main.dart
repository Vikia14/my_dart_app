import 'dart:async';
import 'dart:math' as math;

import 'package:fin_assistant/budget_goals.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FinConsultantApp());
}

// ============================================================================
// Тема приложения (фирменный дизайн)
// ============================================================================

const Color kPrimaryColor = Color(0xFF4F46E5);
const Color kPrimaryDark = Color(0xFF4338CA);
const Color kSecondaryColor = Color(0xFF10B981);
const Color kSurfaceColor = Color(0xFFFFFFFF);
const Color kBackgroundColor = Color(0xFFF8FAFC);
const Color kErrorColor = Color(0xFFF43F5E);
const Color kSuccessColor = Color(0xFF10B981);
const Color kTextPrimary = Color(0xFF0F172A);
const Color kTextSecondary = Color(0xFF64748B);
const Color kTextMuted = Color(0xFF94A3B8);
const Color kBorderColor = Color(0xFFE2E8F0);
const Color kDividerColor = Color(0xFFE2E8F0);

ThemeData _buildTheme() {
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

  final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: kPrimaryColor,
    onPrimary: Colors.white,
    primaryContainer: kPrimaryColor.withValues(alpha: 0.1),
    onPrimaryContainer: kPrimaryDark,
    secondary: kSecondaryColor,
    onSecondary: Colors.white,
    secondaryContainer: kSecondaryColor.withValues(alpha: 0.1),
    onSecondaryContainer: Color(0xFF047857),
    surface: kSurfaceColor,
    onSurface: kTextPrimary,
    surfaceVariant: kBackgroundColor,
    onSurfaceVariant: kTextSecondary,
    background: kBackgroundColor,
    onBackground: kTextPrimary,
    error: kErrorColor,
    onError: Colors.white,
    errorContainer: kErrorColor.withValues(alpha: 0.1),
    onErrorContainer: Color(0xFFBE123C),
    inverseSurface: kTextPrimary,
    onInverseSurface: Colors.white,
    inversePrimary: kPrimaryColor,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: kBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: kTextPrimary),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kTextPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimaryColor,
        side: const BorderSide(color: kPrimaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurfaceColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kErrorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kErrorColor, width: 2),
      ),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: kTextSecondary,
      ),
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: kTextMuted,
      ),
    ),
  );
}

class FinConsultantApp extends StatelessWidget {
  final BudgetGoalsRepository repository;

  const FinConsultantApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ФинКонсультант',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: MainMenuScreen(repository: repository ?? SecureBudgetGoalsRepository()),
    );
  }
}

String fmtNum(double n) {
  final value = n.round();
  final text = value.abs().toString();
  final out = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) out.write(' ');
    out.write(text[i]);
  }
  return (value < 0 ? '-' : '') + out.toString();
}

double calculateCardInterest(
  double debt,
  double annualRate,
  int days, {
  DateTime? startDate,
}) {
  if (debt <= 0 || annualRate <= 0 || days <= 0) return 0;
  var date = startDate ?? DateTime.now();
  var remainingDays = days;
  var interest = 0.0;
  while (remainingDays > 0) {
    final daysInYear = DateTime(
      date.year + 1,
      1,
      1,
    ).difference(DateTime(date.year, 1, 1)).inDays;
    final daysToYearEnd = DateTime(
      date.year + 1,
      1,
      1,
    ).difference(DateTime(date.year, date.month, date.day)).inDays;
    final daysInSegment = math.min(remainingDays, daysToYearEnd);
    interest += debt * annualRate / 100 * daysInSegment / daysInYear;
    remainingDays -= daysInSegment;
    date = DateTime(date.year, date.month, date.day + daysInSegment);
  }
  return interest;
}

enum LoanPaymentType { annuity, differentiated }

double calculateLoanPayment(
  double principal,
  double annualRate,
  int term,
  LoanPaymentType type,
) {
  if (principal <= 0 || annualRate < 0 || term <= 0) return 0;
  final monthlyRate = annualRate / 1200;
  if (type == LoanPaymentType.differentiated) {
    return principal / term + principal * monthlyRate;
  }
  if (monthlyRate == 0) return principal / term;
  return principal *
      monthlyRate /
      (1 - math.pow(1 + monthlyRate, -term).toDouble());
}

double calculateLoanOverpayment(
  double principal,
  double annualRate,
  int term,
  LoanPaymentType type,
) {
  if (principal <= 0 || annualRate < 0 || term <= 0) return 0;
  if (type == LoanPaymentType.differentiated) {
    return principal * (annualRate / 1200) * (term + 1) / 2;
  }
  return calculateLoanPayment(
            principal,
            annualRate,
            term,
            LoanPaymentType.annuity,
          ) *
          term -
      principal;
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key, this.repository});

  final BudgetGoalsRepository? repository;

  Widget _menuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) => Card(
    key: ValueKey('menu-$title'),
    margin: const EdgeInsets.only(bottom: 16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: kTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: kTextMuted),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'ФинКонсультант',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: kTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Планируйте бюджет, считайте накопления и управляйте долгами',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: _menuCard(
                context: context,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Расчёт бюджета',
                subtitle:
                    'Накопления, доходы, расходы, кредиты и карты в одном расчёте',
                color: kPrimaryColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => HomeScreen(repository: repository),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _menuCard(
                context: context,
                icon: Icons.robot_2_outlined,
                title: 'Ассистент',
                subtitle: 'Раздел в разработке',
                color: kSecondaryColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AssistantScreen(),
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ],
      ),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository});

  final BudgetGoalsRepository? repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _GoalNameDialog extends StatefulWidget {
  const _GoalNameDialog();

  @override
  State<_GoalNameDialog> createState() => _GoalNameDialogState();
}

class _GoalNameDialogState extends State<_GoalNameDialog> {
  final _nameController = TextEditingController();

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) Navigator.pop(context, name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Новый расчёт'),
    content: TextField(
      key: const ValueKey('goalNameField'),
      controller: _nameController,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Название цели',
        hintText: 'Например, Ремонт',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (_) => _submit(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Отмена'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Создать')),
    ],
  );
}

class _HomeScreenState extends State<HomeScreen> {
  late final BudgetGoalsRepository _repository;
  List<BudgetGoal> _goals = [];
  bool _isLoading = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? SecureBudgetGoalsRepository();
    unawaited(_loadGoals());
  }

  Future<void> _loadGoals() async {
    try {
      final goals = await _repository.load();
      if (mounted) {
        setState(() {
          _goals = goals..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createGoal() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _GoalNameDialog(),
    );
    if (!mounted || name == null) return;

    final now = DateTime.now();
    final goal = BudgetGoal(
      id: now.microsecondsSinceEpoch.toString(),
      name: name,
      draft: const {},
      updatedAt: now,
    );
    try {
      await _repository.save(goal);
      if (!mounted) return;
      setState(() => _goals.insert(0, goal));
      await _openGoal(goal);
    } catch (_) {
      if (mounted) _showStorageError();
    }
  }

  Future<void> _openGoal(BudgetGoal goal) async {
    final savedGoals = await _repository.load();
    final savedGoal =
        savedGoals.where((item) => item.id == goal.id).firstOrNull ?? goal;
    if (!mounted) {
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BudgetFlowScreen(repository: _repository, goal: savedGoal),
      ),
    );
    await _loadGoals();
  }

  Future<void> _deleteGoal(BudgetGoal goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить расчёт?'),
        content: Text(
          '«${goal.name}» будет удалён без возможности восстановления.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _repository.delete(goal.id);
      if (mounted) {
        setState(() => _goals.removeWhere((item) => item.id == goal.id));
      }
    } catch (_) {
      if (mounted) {
        _showStorageError();
      }
    }
  }

  void _showStorageError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Не удалось сохранить расчёт на устройстве.'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day.$month.${local.year}';
  }

  Widget _goalTile(BudgetGoal goal) {
    final target = double.tryParse('${goal.draft['target'] ?? ''}') ?? 0;
    final totalKey = goal.draft['selectedScenario'] == 'optimized'
        ? 'finalTotal'
        : 'baselineTotal';
    final total = double.tryParse('${goal.draft[totalKey] ?? ''}') ?? 0;
    final progress = target > 0
        ? (total / target).clamp(0.0, 1.0).toDouble()
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openGoal(goal),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_wallet_outlined, color: kPrimaryColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: kTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Изменён ${_formatDate(goal.updatedAt)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: kTextSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Удалить расчёт ${goal.name}',
                    onPressed: () => _deleteGoal(goal),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: kErrorColor,
                  ),
                ],
              ),
              if (progress != null) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: kBorderColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                if (total >= target)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kSecondaryColor.withValues(alpha: 0.3)),
                      ),
                      child: const Text(
                        'Цель достигается',
                        style: TextStyle(
                          color: Color(0xFF047857),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _calculationsTab() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ваши средства\nработают на Вас',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 9),
        Text(
          'Ваши расчёты бюджета',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _createGoal,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Новый расчёт'),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _goals.isEmpty
              ? const Center(child: Text('Сохранённых расчётов пока нет.'))
              : ListView.builder(
                  itemCount: _goals.length,
                  itemBuilder: (context, index) => _goalTile(_goals[index]),
                ),
        ),
      ],
    ),
  );

  Widget _placeholderPanel({
    required IconData icon,
    required String title,
    required String description,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: kSurfaceColor,
      border: Border.all(color: kBorderColor),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kPrimaryColor),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _otherTab({
    required String title,
    required String description,
    required IconData icon,
  }) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 9),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        _placeholderPanel(
          icon: icon,
          title: title == 'Ассистент'
              ? 'Скоро здесь появится ассистент'
              : 'Данные на устройстве',
          description: title == 'Ассистент'
              ? 'Раздел пока в разработке.'
              : 'Черновики расчётов хранятся на этом устройстве.',
        ),
      ],
    ),
  );

  Widget _navigationItem(int index, String label, IconData icon) {
    final selected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? kPrimaryColor : kTextMuted, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? kPrimaryColor : kTextMuted,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: _selectedTab == 0
            ? KeyedSubtree(
                key: const ValueKey('calculations'),
                child: _calculationsTab(),
              )
            : _selectedTab == 1
            ? KeyedSubtree(
                key: const ValueKey('assistant'),
                child: _otherTab(
                  title: 'Ассистент',
                  description: 'Помощник по финансовым вопросам',
                  icon: Icons.chat_bubble_outline_rounded,
                ),
              )
            : KeyedSubtree(
                key: const ValueKey('settings'),
                child: _otherTab(
                  title: 'Настройки',
                  description: 'Личные параметры приложения',
                  icon: Icons.tune_rounded,
                ),
              ),
      ),
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _line),
            boxShadow: [
              BoxShadow(
                color: _brand.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _navigationItem(0, 'Расчёты', Icons.receipt_long_outlined),
              _navigationItem(
                1,
                'Ассистент',
                Icons.chat_bubble_outline_rounded,
              ),
              _navigationItem(2, 'Настройки', Icons.tune_rounded),
            ],
          ),
        ),
      ),
    ),
  );
}

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ассистент')),
    body: const Center(
      child: Text(
        'Скоро здесь появится финансовый ассистент.\n\nРаздел подключится к отдельному API-сервису.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54),
      ),
    ),
  );
}

class ExpenseRow {
  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final monthCtrls = <TextEditingController>[];
  final reductionCtrl = TextEditingController();
  double get amount =>
      double.tryParse(amountCtrl.text.replaceAll(',', '.')) ?? 0;
  double get periodTotal => monthCtrls.fold(
    0,
    (total, controller) =>
        total + (double.tryParse(controller.text.replaceAll(',', '.')) ?? 0),
  );
  double get reductionValue =>
      double.tryParse(reductionCtrl.text.replaceAll(',', '.')) ?? 0;
  String get name => nameCtrl.text;

  void ensureMonths(int count) {
    while (monthCtrls.length < count) {
      monthCtrls.add(TextEditingController());
    }
  }

  void dispose() {
    nameCtrl.dispose();
    amountCtrl.dispose();
    reductionCtrl.dispose();
    for (final controller in monthCtrls) {
      controller.dispose();
    }
  }
}

enum WizStep {
  goal,
  fixedExpenses,
  optionalExpenses,
  baseline,
  optionalIntro,
  optionalEdit,
  finalStep,
  recommendations,
  financing,
  creditCard,
  loan,
}

enum ResultScenario { initial, optimized }

class BudgetFlowScreen extends StatefulWidget {
  const BudgetFlowScreen({
    super.key,
    required this.repository,
    required this.goal,
  });

  final BudgetGoalsRepository repository;
  final BudgetGoal goal;

  @override
  State<BudgetFlowScreen> createState() => _BudgetFlowScreenState();
}

class _BudgetFlowScreenState extends State<BudgetFlowScreen>
    with WidgetsBindingObserver {
  static const monthNames = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];

  static const expenseCategories = [
    'Жилье',
    'Питание',
    'Транспорт',
    'Здравоохранение',
    'Налоги',
    'Долги',
    'Страховки',
    'Связь',
    'Образование',
  ];

  static const optionalExpenseCategories = [
    'Маркетплейсы',
    'Театры',
    'Кафе и рестораны',
  ];

  static const cashbackCategories = [
    'Жилье',
    'Питание',
    'Транспорт',
    'Здравоохранение',
  ];

  WizStep step = WizStep.goal;
  final monthsCtrl = TextEditingController();
  final targetCtrl = TextEditingController();
  final incomeCtrl = TextEditingController();
  final reductionCtrl = TextEditingController();
  final depositRateCtrl = TextEditingController(text: '8');
  final cashbackRateCtrl = TextEditingController(text: '5');
  final loanAmountCtrl = TextEditingController();
  final loanTermCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final cardRateCtrl = TextEditingController();
  List<ExpenseRow> fixed = [ExpenseRow()];
  List<ExpenseRow> optional = [ExpenseRow()];
  final Map<ExpenseRow, double> reductions = {};
  int startMonth = DateTime.now().month;
  int startYear = DateTime.now().year;
  int optionalIndex = 0;
  bool loanCalculated = false;
  LoanPaymentType loanPaymentType = LoanPaymentType.annuity;
  bool cardCalculated = false;
  bool depositCalculated = false;
  double calculatedDepositInterest = 0;
  double calculatedCashbackSavings = 0;
  ResultScenario? financingScenarioChoice;
  bool financingResultShown = false;
  bool? cardHas120DayGrace;
  ResultScenario selectedScenario = ResultScenario.initial;
  double baselineMonthly = 0;
  double baselineTotal = 0;
  double finalMonthly = 0;
  double finalTotal = 0;
  Timer? _saveTimer;
  Future<void> _pendingSave = Future<void>.value();
  bool _isRestoring = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restoreDraft(widget.goal.draft);
    _isRestoring = false;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _scheduleSave();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(_saveNow());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveTimer?.cancel();
    unawaited(_saveNow());
    for (final controller in [
      monthsCtrl,
      targetCtrl,
      incomeCtrl,
      reductionCtrl,
      depositRateCtrl,
      cashbackRateCtrl,
      loanAmountCtrl,
      loanTermCtrl,
      rateCtrl,
      cardRateCtrl,
    ]) {
      controller.dispose();
    }
    for (final row in [...fixed, ...optional]) {
      row.dispose();
    }
    super.dispose();
  }

  void _disposeRowsAfterFrame(Iterable<ExpenseRow> rows) {
    final removedRows = List<ExpenseRow>.of(rows);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final row in removedRows) {
        row.dispose();
      }
    });
  }

  void _restoreDraft(Map<String, dynamic> draft) {
    if (draft.isEmpty) return;
    step = _readEnum(draft['step'], WizStep.values, WizStep.goal);
    monthsCtrl.text = _readString(draft['months']);
    targetCtrl.text = _readString(draft['target']);
    incomeCtrl.text = _readString(draft['income']);
    reductionCtrl.text = _readString(draft['reduction']);
    depositRateCtrl.text = _readString(draft['depositRate'], '8');
    cashbackRateCtrl.text = _readString(draft['cashbackRate'], '5');
    loanAmountCtrl.text = _readString(draft['loanAmount']);
    loanTermCtrl.text = _readString(draft['loanTerm']);
    rateCtrl.text = _readString(draft['loanRate']);
    cardRateCtrl.text = _readString(draft['cardRate']);
    startMonth = _readInt(draft['startMonth'], startMonth).clamp(1, 12);
    startYear = _readInt(draft['startYear'], startYear);
    optionalIndex = _readInt(draft['optionalIndex'], 0);
    loanCalculated = _readBool(draft['loanCalculated']);
    loanPaymentType = _readEnum(
      draft['loanPaymentType'],
      LoanPaymentType.values,
      LoanPaymentType.annuity,
    );
    cardCalculated = _readBool(draft['cardCalculated']);
    depositCalculated = _readBool(draft['depositCalculated']);
    calculatedDepositInterest = _readDouble(draft['calculatedDepositInterest']);
    calculatedCashbackSavings = _readDouble(draft['calculatedCashbackSavings']);
    financingScenarioChoice = draft['financingScenarioChoice'] == null
        ? null
        : _readEnum(
            draft['financingScenarioChoice'],
            ResultScenario.values,
            ResultScenario.initial,
          );
    financingResultShown = _readBool(draft['financingResultShown']);
    cardHas120DayGrace = draft['cardHas120DayGrace'] as bool?;
    selectedScenario = _readEnum(
      draft['selectedScenario'],
      ResultScenario.values,
      ResultScenario.initial,
    );
    baselineMonthly = _readDouble(draft['baselineMonthly']);
    baselineTotal = _readDouble(draft['baselineTotal']);
    finalMonthly = _readDouble(draft['finalMonthly']);
    finalTotal = _readDouble(draft['finalTotal']);
    fixed = _restoreRows(draft['fixed']);
    optional = _restoreRows(draft['optional'], restoreMonths: true);
    reductions
      ..clear()
      ..addEntries(
        optional
            .where((row) => row.reductionValue > 0)
            .map((row) => MapEntry(row, row.reductionValue)),
      );
  }

  List<ExpenseRow> _restoreRows(dynamic value, {bool restoreMonths = false}) {
    if (value is! List) return [ExpenseRow()];
    final rows = <ExpenseRow>[];
    for (final entry in value) {
      if (entry is! Map) continue;
      final row = ExpenseRow()
        ..nameCtrl.text = _readString(entry['name'])
        ..amountCtrl.text = _readString(entry['amount'])
        ..reductionCtrl.text = _readString(entry['reduction']);
      final savedMonths = entry['months'];
      if (restoreMonths && savedMonths is List) {
        for (final month in savedMonths) {
          row.monthCtrls.add(TextEditingController(text: _readString(month)));
        }
      }
      rows.add(row);
    }
    return rows.isEmpty ? [ExpenseRow()] : rows;
  }

  Map<String, dynamic> _draftSnapshot() => {
    'step': step.name,
    'months': monthsCtrl.text,
    'target': targetCtrl.text,
    'income': incomeCtrl.text,
    'reduction': reductionCtrl.text,
    'depositRate': depositRateCtrl.text,
    'cashbackRate': cashbackRateCtrl.text,
    'loanAmount': loanAmountCtrl.text,
    'loanTerm': loanTermCtrl.text,
    'loanRate': rateCtrl.text,
    'cardRate': cardRateCtrl.text,
    'startMonth': startMonth,
    'startYear': startYear,
    'optionalIndex': optionalIndex,
    'loanCalculated': loanCalculated,
    'loanPaymentType': loanPaymentType.name,
    'cardCalculated': cardCalculated,
    'depositCalculated': depositCalculated,
    'calculatedDepositInterest': calculatedDepositInterest,
    'calculatedCashbackSavings': calculatedCashbackSavings,
    'financingScenarioChoice': financingScenarioChoice?.name,
    'financingResultShown': financingResultShown,
    'cardHas120DayGrace': cardHas120DayGrace,
    'selectedScenario': selectedScenario.name,
    'baselineMonthly': baselineMonthly,
    'baselineTotal': baselineTotal,
    'finalMonthly': finalMonthly,
    'finalTotal': finalTotal,
    'fixed': fixed.map(_rowSnapshot).toList(),
    'optional': optional.map(_rowSnapshot).toList(),
  };

  Map<String, dynamic> _rowSnapshot(ExpenseRow row) => {
    'name': row.nameCtrl.text,
    'amount': row.amountCtrl.text,
    'reduction': row.reductionCtrl.text,
    'months': row.monthCtrls.map((controller) => controller.text).toList(),
  };

  String _readString(dynamic value, [String fallback = '']) =>
      value is String ? value : fallback;

  int _readInt(dynamic value, int fallback) =>
      value is num ? value.toInt() : fallback;

  double _readDouble(dynamic value) => value is num ? value.toDouble() : 0;

  bool _readBool(dynamic value) => value is bool && value;

  T _readEnum<T extends Enum>(dynamic name, List<T> values, T fallback) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return fallback;
  }

  void _scheduleSave() {
    if (_isRestoring) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 350), () {
      unawaited(_saveNow());
    });
  }

  Future<void> _saveNow() async {
    _saveTimer?.cancel();
    if (_isRestoring) return;
    final updatedGoal = widget.goal.copyWith(
      draft: _draftSnapshot(),
      updatedAt: DateTime.now(),
    );
    _pendingSave = _pendingSave
        .then((_) => widget.repository.save(updatedGoal))
        .catchError((Object _) {});
    await _pendingSave;
  }

  double get months =>
      double.tryParse(monthsCtrl.text.replaceAll(',', '.')) ?? 0;
  double get target =>
      double.tryParse(targetCtrl.text.replaceAll(',', '.')) ?? 0;
  double get activeMonthly => selectedScenario == ResultScenario.optimized
      ? finalMonthly
      : baselineMonthly;
  double get activeTotal =>
      selectedScenario == ResultScenario.optimized ? finalTotal : baselineTotal;
  double get shortfall => target - activeTotal;
  double get totalReduction =>
      reductions.values.fold(0, (total, amount) => total + amount);
  double get depositRate =>
      double.tryParse(depositRateCtrl.text.replaceAll(',', '.')) ?? 8;
  double get cashbackRate =>
      (double.tryParse(cashbackRateCtrl.text.replaceAll(',', '.')) ?? 5).clamp(
        0,
        100,
      );
  double get depositProjection {
    if (activeMonthly <= 0 || months <= 0 || depositRate <= 0) return 0;
    var balance = 0.0;
    final monthlyRate = depositRate / 100 / 12;
    for (var index = 0; index < months.ceil(); index++) {
      balance += activeMonthly;
      balance *= 1 + monthlyRate;
    }
    return balance - activeMonthly * months.ceil();
  }

  double get cashbackSavings {
    final monthlyTotal = fixed.fold(0.0, (sum, row) {
      final name = row.name.trim();
      if (!cashbackCategories.contains(name)) return sum;
      return sum + row.amount;
    });
    return monthlyTotal * cashbackRate / 100;
  }

  double get cardThreshold => (activeMonthly > 0 ? activeMonthly : 0) * 3;
  double get cardInterestPrincipal => cardHas120DayGrace == true
      ? math.max(shortfall - cardThreshold, 0)
      : shortfall;
  int get cardRepaymentDays => activeMonthly > 0 && cardInterestPrincipal > 0
      ? (cardInterestPrincipal / activeMonthly).ceil() * 30
      : 0;
  double get cardInterest => calculateCardInterest(
    cardInterestPrincipal,
    double.tryParse(cardRateCtrl.text.replaceAll(',', '.')) ?? 0,
    cardRepaymentDays,
  );
  double get cardTotalRepayment => shortfall + cardInterest;
  int get loanTerm =>
      (double.tryParse(loanTermCtrl.text.replaceAll(',', '.')) ?? 0).round();
  double get loanAmount =>
      double.tryParse(loanAmountCtrl.text.replaceAll(',', '.')) ?? 0;
  double get annualLoanRate =>
      double.tryParse(rateCtrl.text.replaceAll(',', '.')) ?? 0;
  int get savingMonths => months.ceil();
  double get loanPayment => calculateLoanPayment(
    loanAmount,
    annualLoanRate,
    loanTerm,
    loanPaymentType,
  );
  double get loanOverpayment => calculateLoanOverpayment(
    loanAmount,
    annualLoanRate,
    loanTerm,
    loanPaymentType,
  );
  int? get shortestAffordableLoanTerm {
    if (activeMonthly <= 0 || loanTerm <= 1) return null;
    for (var term = 1; term < loanTerm; term++) {
      if (calculateLoanPayment(
            loanAmount,
            annualLoanRate,
            term,
            loanPaymentType,
          ) <=
          activeMonthly) {
        return term;
      }
    }
    return null;
  }

  List<ExpenseRow> get optionalWithAmounts =>
      optional.where((row) => row.periodTotal > 0).toList();

  double sum(List<ExpenseRow> rows) =>
      rows.fold(0, (total, row) => total + row.amount);

  double get totalPeriodExpenses =>
      optional.fold(0.0, (total, row) => total + row.periodTotal);

  double get totalSavings =>
      (double.tryParse(incomeCtrl.text.replaceAll(',', '.')) ?? 0) * months -
      sum(fixed) * months -
      totalPeriodExpenses;

  double monthly() => months > 0 ? totalSavings / months : 0;

  void _finishOptimization() {
    finalTotal = baselineTotal + totalReduction;
    finalMonthly = months > 0 ? finalTotal / months : 0;
    selectedScenario = ResultScenario.optimized;
    step = WizStep.finalStep;
  }

  void _startOptimization() {
    reductions.clear();
    optionalIndex = 0;
    reductionCtrl.clear();
    if (optionalWithAmounts.isEmpty) {
      _finishOptimization();
    } else {
      for (final row in optionalWithAmounts) {
        row.reductionCtrl.clear();
      }
      step = WizStep.optionalEdit;
    }
  }

  void _applyOptionalReductions() {
    final expenses = optionalWithAmounts;
    final invalid = expenses.where(
      (row) => row.reductionValue < 0 || row.reductionValue > row.periodTotal,
    );
    if (invalid.isNotEmpty) {
      final first = invalid.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Укажите сумму от 0 до ${fmtNum(first.periodTotal)} ₽ за весь срок.',
          ),
        ),
      );
      return;
    }

    setState(() {
      reductions.clear();
      for (final expense in expenses) {
        if (expense.reductionValue > 0) {
          reductions[expense] = expense.reductionValue;
        }
      }
      _finishOptimization();
    });
  }

  int get _journeyStep {
    if (step == WizStep.goal) return 1;
    if (step == WizStep.fixedExpenses ||
        step == WizStep.optionalExpenses ||
        step == WizStep.baseline ||
        step == WizStep.optionalIntro ||
        step == WizStep.optionalEdit) {
      return 2;
    }
    if (step == WizStep.recommendations) return 3;
    return 4;
  }

  Widget _journeyProgress() => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Шаг $_journeyStep из 4',
          style: const TextStyle(
            color: _brand,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _journeyStep / 4,
            minHeight: 6,
            backgroundColor: _line,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.goal.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_journeyProgress(), _screen()],
        ),
      ),
    ),
  );

  Widget _screen() {
    switch (step) {
      case WizStep.goal:
        return _goal();
      case WizStep.fixedExpenses:
        return _fixedExpenses();
      case WizStep.optionalExpenses:
        return _optionalExpenses();
      case WizStep.baseline:
        return _baseline();
      case WizStep.optionalIntro:
        return _optionalIntro();
      case WizStep.optionalEdit:
        return _optionalEdit();
      case WizStep.finalStep:
        return _result();
      case WizStep.recommendations:
        return _recommendations();
      case WizStep.financing:
        return _financing();
      case WizStep.creditCard:
        return _creditCard();
      case WizStep.loan:
        return _loan();
    }
  }

  InputDecoration decoration(String label) => InputDecoration(
    labelText: label,
    isDense: true,
    filled: true,
    fillColor: _surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _brand, width: 1.5),
    ),
  );

  Widget field(
    TextEditingController controller,
    String label, {
    ValueChanged<String>? onChanged,
  }) => TextField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: decoration(label),
    onChanged: (value) {
      onChanged?.call(value);
      _scheduleSave();
    },
  );

  Widget card(String title, String hint, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 7),
      Text(hint, style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 18),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _surface,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _brand.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    ],
  );

  Widget _goal() => card(
    'Какая цель?',
    'Укажите срок, целевую сумму и ежемесячный доход.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field(monthsCtrl, 'Срок накопления, месяцев'),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: startMonth,
          decoration: decoration('Первый месяц накоплений'),
          items: [
            for (var month = 1; month <= 12; month++)
              DropdownMenuItem(
                value: month,
                child: Text(monthNames[month - 1]),
              ),
          ],
          onChanged: (value) =>
              setState(() => startMonth = value ?? startMonth),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: startYear,
          decoration: decoration('Год начала'),
          items: [
            for (
              var year = DateTime.now().year;
              year <= DateTime.now().year + 10;
              year++
            )
              DropdownMenuItem(value: year, child: Text('$year')),
          ],
          onChanged: (value) => setState(() => startYear = value ?? startYear),
        ),
        const SizedBox(height: 12),
        field(targetCtrl, 'Целевая сумма, ₽ (необязательно)'),
        const SizedBox(height: 12),
        field(incomeCtrl, 'Ежемесячный доход, ₽'),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            if (months <= 0 ||
                months != months.roundToDouble() ||
                (double.tryParse(incomeCtrl.text.replaceAll(',', '.')) ?? 0) <=
                    0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Укажите целое число месяцев и доход.'),
                ),
              );
              return;
            }
            setState(() => step = WizStep.fixedExpenses);
          },
          child: const Text('Далее'),
        ),
      ],
    ),
  );

  Widget _fixedExpenses() => card(
    'Обязательные ежемесячные расходы',
    'Укажите только те расходы, которые есть каждый месяц.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rows('Постоянные расходы', fixed),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = WizStep.goal),
              child: const Text('Назад'),
            ),
            ElevatedButton(
              onPressed: () => setState(() => step = WizStep.optionalExpenses),
              child: const Text('Далее'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _optionalExpenses() => card(
    'Необязательные расходы',
    'Укажите необязательные траты по месяцам.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        monthlyRows('Необязательные расходы', optional),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = WizStep.fixedExpenses),
              child: const Text('Назад'),
            ),
            ElevatedButton(
              onPressed: () {
                final names = <String>{};
                for (final row in optional) {
                  final name = row.name.trim().toLowerCase();
                  if (name.isNotEmpty && !names.add(name)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Один и тот же расход нельзя указать дважды.',
                        ),
                      ),
                    );
                    return;
                  }
                }
                baselineMonthly = monthly();
                baselineTotal = totalSavings;
                finalMonthly = baselineMonthly;
                finalTotal = baselineTotal;
                setState(() {
                  step = WizStep.baseline;
                  if (optionalWithAmounts.isEmpty) {
                    selectedScenario = ResultScenario.initial;
                    step = WizStep.finalStep;
                  }
                });
              },
              child: const Text('Рассчитать'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _expenseCategorySelector(
    ExpenseRow row,
    List<String> categories, {
    List<ExpenseRow> siblingRows = const [],
  }) => Autocomplete<String>(
    key: ObjectKey(row),
    initialValue: TextEditingValue(text: row.name),
    optionsBuilder: (value) {
      final query = value.text.trim().toLowerCase();
      final existingNames = siblingRows
          .where((other) => !identical(other, row))
          .map((other) => other.name.trim().toLowerCase())
          .where((name) => name.isNotEmpty)
          .toSet();
      return categories.where((category) {
        final normalized = category.toLowerCase();
        return normalized.contains(query) &&
            !existingNames.contains(normalized);
      });
    },
    onSelected: (category) {
      row.nameCtrl.text = category;
      _scheduleSave();
    },
    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: decoration('Категория или свой расход'),
          onChanged: (value) {
            row.nameCtrl.text = value;
            _scheduleSave();
          },
          onSubmitted: (_) => onFieldSubmitted(),
        ),
  );

  Widget rows(String title, List<ExpenseRow> list) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      ...list.map(
        (row) => Row(
          children: [
            Expanded(
              flex: 2,
              child: _expenseCategorySelector(row, expenseCategories),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: row.amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: decoration('₽/мес.'),
                onChanged: (_) => _scheduleSave(),
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                list.remove(row);
                _disposeRowsAfterFrame([row]);
                if (list.isEmpty) list.add(ExpenseRow());
              }),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
      OutlinedButton(
        onPressed: () => setState(() => list.add(ExpenseRow())),
        child: const Text('+ Добавить строку'),
      ),
    ],
  );

  Widget monthlyRows(String title, List<ExpenseRow> list) {
    for (final row in list) {
      row.ensureMonths(savingMonths);
    }
    final tables = <Widget>[];
    var firstMonthIndex = 0;
    while (firstMonthIndex < savingMonths) {
      final firstDate = DateTime(startYear, startMonth + firstMonthIndex);
      var endMonthIndex = firstMonthIndex + 1;
      while (endMonthIndex < savingMonths &&
          DateTime(startYear, startMonth + endMonthIndex).year ==
              firstDate.year) {
        endMonthIndex++;
      }
      final monthIndexes = [
        for (var index = firstMonthIndex; index < endMonthIndex; index++) index,
      ];
      tables.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${firstDate.year}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 12,
                  horizontalMargin: 8,
                  columns: [
                    const DataColumn(label: Text('Расход')),
                    for (final index in monthIndexes)
                      DataColumn(
                        label: Text(
                          monthNames[DateTime(
                                startYear,
                                startMonth + index,
                              ).month -
                              1],
                        ),
                      ),
                  ],
                  rows: [
                    for (final row in list)
                      DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 280,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: firstMonthIndex == 0
                                        ? _expenseCategorySelector(
                                            row,
                                            optionalExpenseCategories,
                                            siblingRows: list,
                                          )
                                        : Text(
                                            row.name.trim().isEmpty
                                                ? 'Расход'
                                                : row.name,
                                          ),
                                  ),
                                  if (firstMonthIndex == 0) ...[
                                    IconButton(
                                      tooltip: 'Растянуть сумму на все месяцы',
                                      onPressed: () => setState(() {
                                        final source = row.monthCtrls
                                            .map(
                                              (controller) => controller.text,
                                            )
                                            .firstWhere(
                                              (value) =>
                                                  value.trim().isNotEmpty,
                                              orElse: () => '',
                                            );
                                        if (source.isNotEmpty) {
                                          for (final controller
                                              in row.monthCtrls) {
                                            controller.text = source;
                                          }
                                        }
                                      }),
                                      icon: const Icon(
                                        Icons.keyboard_double_arrow_right,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Удалить расход',
                                      onPressed: () => setState(() {
                                        list.remove(row);
                                        _disposeRowsAfterFrame([row]);
                                        if (list.isEmpty) {
                                          list.add(ExpenseRow());
                                        }
                                      }),
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          for (final index in monthIndexes)
                            DataCell(
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: row.monthCtrls[index],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: decoration('₽'),
                                  onChanged: (_) => _scheduleSave(),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      firstMonthIndex = endMonthIndex;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...tables,
        OutlinedButton.icon(
          onPressed: () => setState(() => list.add(ExpenseRow())),
          icon: const Icon(Icons.add),
          label: const Text('Добавить расход'),
        ),
      ],
    );
  }

  Widget stat(String label, double value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.black54)),
      Text(
        '${fmtNum(value)} ₽',
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
      ),
    ],
  );

  Widget _baseline() => card(
    'Что получается сейчас',
    'Расчёт без изменения расходов.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        stat('Свободно в месяц', baselineMonthly),
        const SizedBox(height: 16),
        stat('Накопится за ${months.toStringAsFixed(0)} мес.', baselineTotal),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = WizStep.optionalExpenses),
              child: const Text('Назад'),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                if (optionalWithAmounts.isEmpty) {
                  finalMonthly = baselineMonthly;
                  finalTotal = baselineTotal;
                  selectedScenario = ResultScenario.initial;
                  step = WizStep.finalStep;
                } else {
                  step = WizStep.optionalIntro;
                }
              }),
              child: const Text('Далее'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _optionalIntro() => card(
    'Необязательные расходы',
    'Хотите посмотреть, сколько получится накопить, если сократить некоторые траты?',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (optionalWithAmounts.isEmpty)
          const Text('Необязательные расходы не указаны.')
        else
          ...optionalWithAmounts.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${row.name.trim().isEmpty ? 'Расход' : row.name}: ${fmtNum(row.periodTotal)} ₽ за срок.',
              ),
            ),
          ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => setState(() {
                finalMonthly = baselineMonthly;
                finalTotal = baselineTotal;
                step = WizStep.finalStep;
              }),
              child: const Text('Оставить как есть'),
            ),
            ElevatedButton(
              onPressed: () => setState(_startOptimization),
              child: const Text('Изменить расходы'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _optionalEdit() {
    final expenses = optionalWithAmounts;
    return card(
      'Корректировка расходов',
      'Укажите, сколько можно уменьшить по каждой статье за весь срок.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Статья')),
                  DataColumn(label: Text('Текущий расход')),
                  DataColumn(label: Text('Сократить, ₽')),
                ],
                rows: expenses.map((expense) {
                  final name = expense.name.trim().isEmpty
                      ? 'Расход'
                      : expense.name;
                  return DataRow(
                    cells: [
                      DataCell(Text(name)),
                      DataCell(Text('${fmtNum(expense.periodTotal)} ₽')),
                      DataCell(
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: expense.reductionCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: decoration('₽'),
                            onChanged: (_) => _scheduleSave(),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () {
                  for (final row in expenses) {
                    row.reductionCtrl.clear();
                  }
                  _applyOptionalReductions();
                },
                child: const Text('Не менять'),
              ),
              OutlinedButton(
                onPressed: () {
                  for (final row in expenses) {
                    row.reductionCtrl.text = row.periodTotal.toStringAsFixed(0);
                  }
                },
                child: const Text('Отказаться полностью'),
              ),
              ElevatedButton(
                onPressed: _applyOptionalReductions,
                child: const Text('Далее'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _result() {
    final isOptimized = selectedScenario == ResultScenario.optimized;
    final displayMonthly = isOptimized ? finalMonthly : baselineMonthly;
    final displayTotal = isOptimized ? finalTotal : baselineTotal;
    final goalProgress = target > 0
        ? (displayTotal / target).clamp(0.0, 1.0)
        : null;
    final goalPercent = target > 0 ? (displayTotal / target * 100).round() : 0;

    return card(
      'Итог',
      isOptimized
          ? 'Оптимизированный план накоплений.'
          : 'Базовый план накоплений без оптимизации.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (goalProgress != null) ...[
            Center(
              child: SizedBox(
                width: 118,
                height: 118,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: goalProgress,
                      strokeWidth: 10,
                      backgroundColor: _brandLight,
                      strokeCap: StrokeCap.round,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$goalPercent%',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Text(
                          'от цели',
                          style: TextStyle(fontSize: 11, color: _muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'Накопится за ${months.toStringAsFixed(0)} мес.',
            style: const TextStyle(color: _muted, fontSize: 13),
          ),
          Text(
            '${fmtNum(displayTotal)} ₽',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontFamily: 'Roboto',
              fontSize: 28,
            ),
          ),
          if (target > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Цель: ${fmtNum(target)} ₽',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ),
          if (target > 0 && displayTotal >= target)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _mint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    'Цель достигается',
                    style: TextStyle(
                      color: Color(0xFF28746D),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Свободно в месяц', style: TextStyle(color: _muted)),
              Text(
                '${fmtNum(displayMonthly)} ₽',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (isOptimized) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Экономия', style: TextStyle(color: _muted)),
                Text(
                  '${fmtNum(totalReduction)} ₽',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => step = WizStep.recommendations),
                child: const Text('Показать рекомендации'),
              ),
              ElevatedButton(
                onPressed: () {
                  selectedScenario = ResultScenario.initial;
                  loanAmountCtrl.text = shortfall.toStringAsFixed(0);
                  loanTermCtrl.clear();
                  rateCtrl.clear();
                  cardRateCtrl.clear();
                  loanCalculated = false;
                  cardCalculated = false;
                  cardHas120DayGrace = null;
                  financingScenarioChoice = null;
                  financingResultShown = false;
                  setState(() => step = WizStep.financing);
                },
                child: const Text('Рассчитать варианты финансирования'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: _reset, child: const Text('Начать заново')),
        ],
      ),
    );
  }

  Widget _recommendations() => card(
    'Рекомендации по оптимизации',
    'Расчёт вклада и примерная оценка кешбэка по выбранным категориям.',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field(
          depositRateCtrl,
          'Процент по вкладу, %',
          onChanged: (_) => setState(() => depositCalculated = false),
        ),
        const SizedBox(height: 16),
        field(
          cashbackRateCtrl,
          'Примерный кешбэк, %',
          onChanged: (_) => setState(() => depositCalculated = false),
        ),
        const SizedBox(height: 8),
        const Text(
          'Это условная оценка: реальные категории, ставки и лимиты зависят от условий банка.',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        if (cashbackSavings > 0)
          Text(
            'Оценка кешбэка: ${fmtNum(cashbackSavings)} ₽ в месяц. За весь период вы сэкономите ${fmtNum(cashbackSavings * months)} ₽.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          )
        else
          const Text(
            'Оценка кешбэка: 0 ₽ в месяц. За весь период вы сэкономите 0 ₽.',
          ),
        const SizedBox(height: 16),
        Text(
          'При ставке ${depositRate.toStringAsFixed(1)}% годовых начислится ${fmtNum(depositProjection)} ₽ процентов.',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => setState(() {
            calculatedDepositInterest = depositProjection;
            calculatedCashbackSavings = cashbackSavings;
            depositCalculated = true;
          }),
          icon: const Icon(Icons.calculate_outlined),
          label: const Text('Рассчитать рекомендации'),
        ),
        const SizedBox(height: 8),
        const Text(
          'Согласны следовать рекомендациям по оптимизации расходов?',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: depositCalculated
                  ? () => setState(() {
                      selectedScenario = ResultScenario.initial;
                      step = WizStep.finalStep;
                    })
                  : null,
              child: const Text('Нет, оставить базовый вариант'),
            ),
            ElevatedButton(
              onPressed: depositCalculated
                  ? () {
                      setState(() {
                        selectedScenario = ResultScenario.optimized;
                        finalTotal =
                            baselineTotal +
                            totalReduction +
                            calculatedCashbackSavings * months +
                            (depositCalculated ? calculatedDepositInterest : 0);
                        finalMonthly = months > 0 ? finalTotal / months : 0;
                        step = WizStep.finalStep;
                      });
                    }
                  : null,
              child: const Text('Да, применить рекомендации'),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _financing() {
    return card(
      'Сравнение сценариев',
      'Выберите итог для расчёта. Оценка не учитывает индивидуальные условия банков.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<ResultScenario>(
            initialValue: financingScenarioChoice,
            decoration: decoration('Какой итог считать'),
            hint: const Text('Выберите сценарий'),
            items: const [
              DropdownMenuItem(
                value: ResultScenario.initial,
                child: Text('Базовый итог'),
              ),
              DropdownMenuItem(
                value: ResultScenario.optimized,
                child: Text('Оптимизированный итог'),
              ),
            ],
            onChanged: (value) => setState(() {
              financingScenarioChoice = value;
              financingResultShown = false;
            }),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: financingScenarioChoice == null
                ? null
                : () => setState(() {
                    selectedScenario = financingScenarioChoice!;
                    financingResultShown = true;
                    loanAmountCtrl.text = shortfall.toStringAsFixed(0);
                    loanCalculated = false;
                    cardCalculated = false;
                    cardHas120DayGrace = null;
                  }),
            child: const Text('Показать итог'),
          ),
          if (financingResultShown) ...[
            const SizedBox(height: 16),
            Text(
              selectedScenario == ResultScenario.initial
                  ? 'Базовый итог: ${fmtNum(activeMonthly)} ₽ в месяц, ${fmtNum(activeTotal)} ₽ за срок.'
                  : 'Оптимизированный итог: ${fmtNum(activeMonthly)} ₽ в месяц, ${fmtNum(activeTotal)} ₽ за срок.',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
          if (financingResultShown &&
              selectedScenario == ResultScenario.optimized &&
              totalReduction > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Экономия на расходах: ${fmtNum(totalReduction)} ₽ за срок.',
                style: const TextStyle(height: 1.45),
              ),
            ),
          if (financingResultShown &&
              selectedScenario == ResultScenario.optimized &&
              calculatedCashbackSavings > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Кешбэк: ${fmtNum(calculatedCashbackSavings)} ₽ в месяц, ${fmtNum(calculatedCashbackSavings * months)} ₽ за срок.',
                style: const TextStyle(height: 1.45),
              ),
            ),
          if (financingResultShown &&
              selectedScenario == ResultScenario.optimized &&
              depositCalculated &&
              calculatedDepositInterest > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Проценты по вкладу: ${fmtNum(calculatedDepositInterest)} ₽ за срок.',
                style: const TextStyle(height: 1.45),
              ),
            ),
          if (financingResultShown)
            Text(
              shortfall <= 0
                  ? 'По выбранному сценарию дефицита нет.'
                  : shortfall < cardThreshold
                  ? 'По упрощённой оценке дефицит меньше трёх месяцев свободных накоплений. Сравните полную стоимость кредита и карты, комиссии и сроки погашения.'
                  : 'По упрощённой оценке дефицит больше трёх месяцев свободных накоплений. Это не рекомендация: сравните полную стоимость кредита и карты, комиссии и сроки погашения.',
              style: const TextStyle(height: 1.45),
            ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => step = WizStep.finalStep),
                child: const Text('Назад'),
              ),
              if (financingResultShown) ...[
                OutlinedButton(
                  onPressed: () => setState(() {
                    cardRateCtrl.clear();
                    cardHas120DayGrace = null;
                    cardCalculated = false;
                    step = WizStep.creditCard;
                  }),
                  child: const Text('Кредитная карта'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    rateCtrl.clear();
                    loanTermCtrl.clear();
                    loanCalculated = false;
                    step = WizStep.loan;
                  }),
                  child: const Text('Рассчитать кредит'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _creditCard() {
    final cardRate =
        double.tryParse(cardRateCtrl.text.replaceAll(',', '.')) ?? 0;
    final interestPrincipal = cardInterestPrincipal;
    final interest = cardInterest;

    return card(
      'Кредитная карта',
      'Укажите параметры карты для ориентировочного расчёта. Сверьте ставку, комиссии, даты и условия льготного периода с договором банка.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          stat('Нужно покрыть', shortfall),
          const SizedBox(height: 12),
          field(
            cardRateCtrl,
            'Годовая ставка по карте, %',
            onChanged: (_) => setState(() => cardCalculated = false),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<bool>(
            initialValue: cardHas120DayGrace,
            decoration: decoration('Карта с периодом 120 дней без процентов?'),
            items: const [
              DropdownMenuItem(value: true, child: Text('Да')),
              DropdownMenuItem(value: false, child: Text('Нет')),
            ],
            onChanged: (value) => setState(() {
              cardHas120DayGrace = value;
              cardCalculated = false;
            }),
          ),
          if (cardCalculated) ...[
            const SizedBox(height: 20),
            stat('Сумма, на которую начисляются проценты', interestPrincipal),
            const SizedBox(height: 16),
            stat('Оценка процентов за $cardRepaymentDays дней', interest),
            const SizedBox(height: 8),
            Text(
              'Оценка срока рассчитана по свободным накоплениям ${fmtNum(activeMonthly)} ₽ в месяц. При льготном периоде первые 3 месяца накоплений уменьшают долг без начисления процентов; далее проценты считаются за фактическое число дней по ставке ${cardRate.toStringAsFixed(2)}% годовых и календарному году 365/366 дней. Общая сумма к возврату: ${fmtNum(cardTotalRepayment)} ₽.',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => step = WizStep.financing),
                child: const Text('Назад'),
              ),
              OutlinedButton(onPressed: _reset, child: const Text('В начало')),
              ElevatedButton(
                onPressed: () {
                  if (cardRateCtrl.text.isEmpty ||
                      cardRate < 0 ||
                      cardHas120DayGrace == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Укажите ставку и выберите ответ про льготный период.',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => cardCalculated = true);
                },
                child: const Text('Рассчитать проценты'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loan() {
    final payment = loanPayment;
    final overpayment = loanOverpayment;
    final shorterTerm = loanCalculated ? shortestAffordableLoanTerm : null;
    return card(
      'Расчёт кредита',
      'Укажите сумму, ставку и срок, на который планируете взять кредит.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          field(
            loanAmountCtrl,
            'Сумма кредита, ₽',
            onChanged: (_) => setState(() => loanCalculated = false),
          ),
          const SizedBox(height: 12),
          field(
            rateCtrl,
            'Годовая ставка, %',
            onChanged: (_) => setState(() => loanCalculated = false),
          ),
          const SizedBox(height: 12),
          field(
            loanTermCtrl,
            'Срок кредита, месяцев',
            onChanged: (_) => setState(() => loanCalculated = false),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<LoanPaymentType>(
            initialValue: loanPaymentType,
            decoration: decoration('Вид платежа'),
            items: const [
              DropdownMenuItem(
                value: LoanPaymentType.annuity,
                child: Text('Аннуитетные платежи'),
              ),
              DropdownMenuItem(
                value: LoanPaymentType.differentiated,
                child: Text('Дифференцированные платежи'),
              ),
            ],
            onChanged: (value) => setState(() {
              loanPaymentType = value ?? LoanPaymentType.annuity;
            }),
          ),
          const SizedBox(height: 20),
          if (loanCalculated) ...[
            stat(
              loanPaymentType == LoanPaymentType.annuity
                  ? 'Ежемесячный платёж'
                  : 'Первый ежемесячный платёж',
              payment,
            ),
            const SizedBox(height: 16),
            stat('Переплата по процентам', overpayment),
            if (payment < activeMonthly && shorterTerm != null) ...[
              const SizedBox(height: 16),
              Text(
                'Платёж меньше свободных накоплений (${fmtNum(activeMonthly)} ₽/мес.). Срок можно сократить до $shorterTerm мес.${shorterTerm > 1 ? '; ещё на месяц короче платёж превысит доступную сумму' : '. Это минимальный срок кредита'}.',
                style: const TextStyle(height: 1.4),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => setState(() {
                  loanTermCtrl.text = shorterTerm.toString();
                  loanCalculated = true;
                }),
                child: Text('Сократить срок до $shorterTerm мес.'),
              ),
            ],
            const SizedBox(height: 20),
          ],
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => step = WizStep.financing),
                child: const Text('Назад'),
              ),
              OutlinedButton(onPressed: _reset, child: const Text('В начало')),
              ElevatedButton(
                onPressed: () {
                  if (loanAmount <= 0 ||
                      annualLoanRate < 0 ||
                      rateCtrl.text.isEmpty ||
                      loanTerm <= 0 ||
                      loanTermCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Укажите сумму, ставку не ниже 0% и срок кредита.',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => loanCalculated = true);
                },
                child: const Text('Рассчитать'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _reset() {
    final oldRows = [...fixed, ...optional];
    setState(() {
      step = WizStep.goal;
      monthsCtrl.clear();
      targetCtrl.clear();
      incomeCtrl.clear();
      reductionCtrl.clear();
      depositRateCtrl.text = '8';
      cashbackRateCtrl.text = '5';
      loanAmountCtrl.clear();
      loanTermCtrl.clear();
      rateCtrl.clear();
      cardRateCtrl.clear();
      startMonth = DateTime.now().month;
      startYear = DateTime.now().year;
      optionalIndex = 0;
      loanCalculated = false;
      loanPaymentType = LoanPaymentType.annuity;
      cardCalculated = false;
      depositCalculated = false;
      calculatedDepositInterest = 0;
      calculatedCashbackSavings = 0;
      financingScenarioChoice = null;
      financingResultShown = false;
      cardHas120DayGrace = null;
      selectedScenario = ResultScenario.initial;
      baselineMonthly = 0;
      baselineTotal = 0;
      finalMonthly = 0;
      finalTotal = 0;
      fixed = [ExpenseRow()];
      optional = [ExpenseRow()];
      reductions.clear();
    });
    _disposeRowsAfterFrame(oldRows);
  }
}
