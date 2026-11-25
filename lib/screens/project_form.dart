import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Halaman form untuk menambahkan proyek baru ke backend Django.
///
/// Field-nya mengikuti `ProjectSerializer` dari Tutorial 07. Saat disimpan,
/// form divalidasi, pengguna dipastikan sudah login, lalu data dikirim ke
/// `POST /api/v1/projects/` dengan header `Authorization: Token <key>`.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  /// Kunci untuk mengakses [FormState], misalnya untuk validasi dan reset.
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techStackController = TextEditingController();
  final _projectUrlController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _projectUrlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Dipanggil saat tombol Save ditekan.
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // Pastikan pengguna sudah login; jika belum, buka LoginScreen.
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    final newProject = Project(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      techStack: _techStackController.text.trim(),
      projectUrl: _projectUrlController.text.trim(),
      projectImageUrl: _imageUrlController.text.trim(),
    );

    setState(() => _isSubmitting = true);
    try {
      final created = await context.read<ApiClient>().createProject(
        newProject,
        token: token,
      );
      if (!mounted) return;
      // Matikan indikator loading sebelum dialog tampil.
      setState(() => _isSubmitting = false);
      _showCreatedDialog(created);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        // Token tidak valid lagi: hapus sesi lalu minta login ulang.
        await context.read<AuthState>().logout();
        if (!mounted) return;
        _showSnackBar(
          'Sesi berakhir, silakan login kembali lalu simpan ulang.',
        );
        await ensureLoggedIn(context);
      } else {
        _showSnackBar('Gagal menyimpan proyek: ${error.userMessage}');
      }
    } on http.ClientException {
      if (mounted) _showSnackBar('Tidak dapat terhubung ke server.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  /// Menampilkan konfirmasi setelah server membalas 201 Created.
  Future<void> _showCreatedDialog(Project project) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: ${project.title}'),
              Text('Description: ${project.description}'),
              Text('Tech Stack: ${project.techStack}'),
              Text('Project URL: ${project.projectUrl}'),
              Text(
                'Project Image URL: '
                '${project.projectImageUrl.isEmpty ? '-' : project.projectImageUrl}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(dialogContext);
              _formKey.currentState!.reset();
              _titleController.clear();
              _descriptionController.clear();
              _techStackController.clear();
              _projectUrlController.clear();
              _imageUrlController.clear();
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _titleController,
                  maxLength: maxTitleLength,
                  decoration: _decoration('Title', hint: 'Portfolio Website'),
                  validator: (value) => validateRequiredWithMaxLength(
                    value,
                    'Title',
                    maxTitleLength,
                  ),
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: _decoration(
                    'Description',
                    hint: 'Ceritakan proyekmu',
                  ),
                  validator: (value) => validateRequired(value, 'Description'),
                ),
              ),

              // === Tech Stack ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _techStackController,
                  maxLength: maxTitleLength,
                  decoration: _decoration(
                    'Tech Stack',
                    hint: 'Contoh: Flutter, Django, Figma',
                  ),
                  validator: (value) => validateRequiredWithMaxLength(
                    value,
                    'Tech stack',
                    maxTitleLength,
                  ),
                ),
              ),

              // === Project URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _projectUrlController,
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    'Project URL',
                    hint: 'https://github.com/username/project',
                  ),
                  validator: (value) =>
                      validateRequiredUrl(value, 'Project URL'),
                ),
              ),

              // === Project Image URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _imageUrlController,
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    'Project Image URL (Optional)',
                    hint: 'https://example.com/image.png',
                  ),
                  validator: (value) =>
                      validateOptionalUrl(value, maxLength: maxImageUrlLength),
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Text('Save'),
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
