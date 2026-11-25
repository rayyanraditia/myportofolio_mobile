import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Halaman detail satu proyek yang dipilih dari [ProjectListScreen].
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  /// Proyek yang ditampilkan.
  final Project project;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar hanya ditampilkan jika URL gambar tidak kosong.
            if (project.projectImageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  project.projectImageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: const Text('Gambar tidak dapat dimuat'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(project.title, style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.build,
              label: 'Tech Stack',
              value: project.techStack,
            ),
            _DetailRow(
              icon: Icons.notes,
              label: 'Description',
              value: project.description,
            ),
            _DetailRow(
              icon: Icons.link,
              label: 'Project URL',
              value: project.projectUrl.isEmpty ? '-' : project.projectUrl,
              selectable: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu baris detail: ikon, label tebal, lalu nilainya.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.selectable = false,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Jika `true`, nilai dapat diseleksi dan disalin (misalnya URL).
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                selectable ? SelectableText(value) : Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
