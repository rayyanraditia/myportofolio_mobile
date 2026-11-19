import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambahkan riwayat pendidikan (Edukasi).
///
/// Field-nya mengikuti model `Education` di proyek Django. Halaman ini
/// bersifat [StatefulWidget] karena menyimpan isian, tanggal yang dipilih,
/// dan status "Masih berlangsung" yang berubah selama pengguna mengisi form.
/// Data belum dikirim ke server; setelah lolos validasi, ringkasan isian
/// ditampilkan dalam [AlertDialog].
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  /// Kunci untuk mengakses [FormState]: validasi dan reset seluruh field.
  final _formKey = GlobalKey<FormState>();

  final _institutionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _logoUrlController = TextEditingController();

  /// Menampilkan tanggal terpilih di field tanggal (yang bersifat read-only).
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  EducationLevel _level = EducationLevel.university; // default seperti Django
  DateTime? _startedAt;
  DateTime? _endedAt;
  bool _isOngoing = false;

  /// Validasi otomatis baru diaktifkan setelah percobaan simpan pertama,
  /// sehingga pengguna tidak langsung melihat pesan error saat form kosong.
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  /// Dinaikkan setiap form direset agar dropdown dan switch dibuat ulang
  /// dengan nilai awalnya.
  int _resetCount = 0;

  static final DateTime _firstDate = DateTime(1990);
  static final DateTime _lastDate = DateTime(2100);

  @override
  void dispose() {
    _institutionController.dispose();
    _descriptionController.dispose();
    _logoUrlController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// Membuka [showDatePicker] untuk memilih tanggal mulai.
  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startedAt ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
      helpText: 'Pilih tanggal mulai',
    );
    if (picked == null) return;
    setState(() {
      _startedAt = picked;
      _startDateController.text = formatDate(picked);
    });
  }

  /// Membuka [showDatePicker] untuk memilih tanggal selesai.
  ///
  /// Tanggal paling awal yang dapat dipilih adalah tanggal mulai, sehingga
  /// urutan tanggal yang salah dicegah sejak di date picker. Validator tetap
  /// memeriksa urutan karena tanggal mulai bisa diubah setelahnya.
  Future<void> _pickEndDate() async {
    final firstDate = _startedAt ?? _firstDate;
    var initialDate = _endedAt ?? _startedAt ?? DateTime.now();
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: _lastDate,
      helpText: 'Pilih tanggal selesai',
    );
    if (picked == null) return;
    setState(() {
      _endedAt = picked;
      _endDateController.text = formatDate(picked);
    });
  }

  void _onOngoingChanged(bool value) {
    setState(() {
      _isOngoing = value;
      if (value) {
        // Pendidikan yang masih berlangsung tidak memiliki tanggal selesai,
        // sama seperti ended_at = null pada model Django.
        _endedAt = null;
        _endDateController.clear();
      }
    });
  }

  /// Dipanggil saat tombol Simpan ditekan.
  void _submit() {
    // Tutup papan ketik agar pesan error atau dialog terlihat utuh.
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final logoUrl = _logoUrlController.text.trim();
    final education = Education(
      institution: _institutionController.text.trim(),
      description: _descriptionController.text.trim(),
      level: _level,
      logoUrl: logoUrl.isEmpty ? null : logoUrl,
      startedAt: _startedAt!,
      endedAt: _isOngoing ? null : _endedAt,
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edukasi berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _SummaryRow('Nama Institusi', education.institution),
              _SummaryRow('Deskripsi', education.description),
              _SummaryRow('Jenjang', education.level.label),
              _SummaryRow('URL Logo', education.logoUrl ?? '-'),
              _SummaryRow('Tanggal Mulai', formatDate(education.startedAt)),
              _SummaryRow(
                'Tanggal Selesai',
                education.isOngoing
                    ? 'Masih berlangsung'
                    : formatDate(education.endedAt!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _resetForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Mengosongkan seluruh field dan mengembalikan nilai default.
  void _resetForm() {
    _formKey.currentState!.reset();
    _institutionController.clear();
    _descriptionController.clear();
    _logoUrlController.clear();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _level = EducationLevel.university;
      _startedAt = null;
      _endedAt = null;
      _isOngoing = false;
      _autovalidateMode = AutovalidateMode.disabled;
      _resetCount++;
    });
  }

  /// Dekorasi seragam untuk semua field agar tampilan form konsisten.
  InputDecoration _decoration(
    String label, {
    String? hint,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Education Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // Warna primer tema yang sama dengan AppBar halaman utama.
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        // SingleChildScrollView membuat seluruh field dan tombol Simpan tetap
        // dapat dijangkau pada layar sempit atau saat papan ketik tampil.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Lengkapi riwayat pendidikanmu. Kolom bertanda * wajib diisi.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),

              // === Nama Institusi (title, max_length=255) ===
              TextFormField(
                controller: _institutionController,
                maxLength: maxTitleLength,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: _decoration(
                  'Nama Institusi *',
                  hint: 'Contoh: Universitas Indonesia',
                  icon: Icons.account_balance,
                ),
                validator: (value) => validateRequiredWithMaxLength(
                  value,
                  'Nama institusi',
                  maxTitleLength,
                ),
              ),
              const SizedBox(height: 8.0),

              // === Deskripsi (description) ===
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoration(
                  'Deskripsi Pendidikan *',
                  hint: 'Contoh: S1 Ilmu Komputer, fokus pada AI',
                  icon: Icons.notes,
                ),
                validator: (value) =>
                    validateRequired(value, 'Deskripsi pendidikan'),
              ),
              const SizedBox(height: 16.0),

              // === Jenjang (category dengan pilihan tetap) ===
              DropdownButtonFormField<EducationLevel>(
                key: ValueKey('level-$_resetCount'),
                initialValue: _level,
                // isExpanded membuat teks pilihan menyesuaikan lebar field
                // sehingga tidak overflow di layar sempit.
                isExpanded: true,
                decoration: _decoration(
                  'Jenjang Pendidikan *',
                  icon: Icons.school,
                ),
                items: EducationLevel.values
                    .map(
                      (level) => DropdownMenuItem(
                        value: level,
                        child: Text(level.label),
                      ),
                    )
                    .toList(),
                onChanged: (level) {
                  if (level != null) setState(() => _level = level);
                },
              ),
              const SizedBox(height: 16.0),

              // === URL Logo (thumbnail, opsional) ===
              TextFormField(
                controller: _logoUrlController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                decoration: _decoration(
                  'URL Logo Institusi (opsional)',
                  hint: 'https://example.com/logo.png',
                  icon: Icons.link,
                ),
                validator: validateOptionalUrl,
              ),
              const SizedBox(height: 16.0),

              // === Tanggal Mulai (started_at) ===
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                onTap: _pickStartDate,
                decoration: _decoration(
                  'Tanggal Mulai *',
                  hint: 'Pilih tanggal',
                  icon: Icons.event,
                  suffixIcon: const Icon(Icons.calendar_month),
                ),
                validator: (_) => validateStartDate(_startedAt),
              ),
              const SizedBox(height: 8.0),

              // === Status "Masih berlangsung" (ended_at = null) ===
              SwitchListTile(
                key: ValueKey('ongoing-$_resetCount'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Masih berlangsung'),
                subtitle: const Text('Tanggal selesai tidak perlu diisi'),
                value: _isOngoing,
                onChanged: _onOngoingChanged,
              ),
              const SizedBox(height: 8.0),

              // === Tanggal Selesai (ended_at) ===
              TextFormField(
                controller: _endDateController,
                readOnly: true,
                enabled: !_isOngoing,
                onTap: _pickEndDate,
                decoration: _decoration(
                  'Tanggal Selesai${_isOngoing ? '' : ' *'}',
                  hint: _isOngoing ? 'Masih berlangsung' : 'Pilih tanggal',
                  icon: Icons.event_available,
                  suffixIcon: const Icon(Icons.calendar_month),
                ),
                validator: (_) => validateEndDate(
                  _endedAt,
                  startedAt: _startedAt,
                  isOngoing: _isOngoing,
                ),
              ),
              const SizedBox(height: 24.0),

              // === Tombol Simpan ===
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Satu baris ringkasan pada dialog: label tebal diikuti nilainya.
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
