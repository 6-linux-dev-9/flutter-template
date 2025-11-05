// lib/presentation/forms/input_image_picker.dart
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class InputImagePicker extends StatefulWidget {
  final bool multiple;
  final List<XFile> initial;
  final ValueChanged<List<XFile>>? onChanged;
  final String? label;
  final String? helper;
  final int maxCount;

  const InputImagePicker({
    super.key,
    this.multiple = false,
    this.initial = const [],
    this.onChanged,
    this.label,
    this.helper,
    this.maxCount = 10,
  });

  @override
  State<InputImagePicker> createState() => _InputImagePickerState();
}

class _InputImagePickerState extends State<InputImagePicker> {
  final _picker = ImagePicker();
  late List<XFile> _files;
  bool get _supportsCamera {
    if (kIsWeb)
      return true; // el <input capture> puede abrir cámara si el navegador lo permite
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      // En desktop no hay soporte nativo de cámara para image_picker
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return false;
      case TargetPlatform.fuchsia:
        return false;
    }
  }
  @override
  void initState() {
    super.initState();
    _files = List.of(widget.initial);
  }

  Future<void> _pickFromGallery() async {
    if (widget.multiple) {
      final r = await _picker.pickMultiImage();
      if (r.isNotEmpty) {
        setState(() {
          _files = (_files + r).take(widget.maxCount).toList();
        });
        widget.onChanged?.call(_files);
      }
    } else {
      final r = await _picker.pickImage(source: ImageSource.gallery);
      if (r != null) {
        setState(() => _files = [r]);
        widget.onChanged?.call(_files);
      }
    }
  }

  Future<void> _pickFromCamera() async {
    if (!_supportsCamera) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cámara no soportada en esta plataforma'),
          ),
        );
      }
      return;
    }
    try {
      final r = await _picker.pickImage(source: ImageSource.camera);
      if (r != null) {
        setState(() {
          if (widget.multiple) {
            _files = (_files + [r]).take(widget.maxCount).toList();
          } else {
            _files = [r];
          }
        });
        widget.onChanged?.call(_files);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir la cámara: $e')),
        );
      }
    }
  }

  void _removeAt(int i) {
    setState(() => _files.removeAt(i));
    widget.onChanged?.call(_files);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label ?? 'Imágenes';
    final canUseCamera = _supportsCamera;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          children: [
            OutlinedButton.icon(
              onPressed: _pickFromGallery,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(widget.multiple ? 'Galería (múltiples)' : 'Galería'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
               onPressed: canUseCamera ? _pickFromCamera : null,
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Cámara'),
            ),
            const Spacer(),
            if (widget.helper != null)
              Text(
                widget.helper!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        const SizedBox(height: 8),
        _PreviewGrid(files: _files, onRemove: _removeAt),
      ],
    );
  }
}

class _PreviewGrid extends StatelessWidget {
  final List<XFile> files;
  final void Function(int index) onRemove;
  const _PreviewGrid({required this.files, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Sin imágenes seleccionadas',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, i) {
        final f = files[i];
        final imageWidget =
            kIsWeb
                ? FutureBuilder<Uint8List>(
                  future: f.readAsBytes(),
                  builder: (_, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Image.memory(snap.data!, fit: BoxFit.cover);
                  },
                )
                : Image.file(File(f.path), fit: BoxFit.cover);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(color: Colors.black12, child: imageWidget),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: IconButton.filledTonal(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => onRemove(i),
                tooltip: 'Quitar',
              ),
            ),
          ],
        );
      },
    );
  }
}
