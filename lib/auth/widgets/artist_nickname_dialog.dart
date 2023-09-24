import 'package:flutter/material.dart';

class ArtistNicknameDialog extends StatefulWidget {
  const ArtistNicknameDialog({
    super.key,
    this.onSubmit,
    this.onCancel,
    this.isLoading = false,
  });

  final ValueChanged<String>? onSubmit;
  final VoidCallback? onCancel;
  final bool isLoading;

  @override
  State<ArtistNicknameDialog> createState() => _ArtistNicknameDialogState();
}

class _ArtistNicknameDialogState extends State<ArtistNicknameDialog> {
  String? nickname;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (nickname != null) widget.onSubmit?.call(nickname!);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick your artist nickname'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          onSaved: (value) => nickname = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required!';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Enter your artist nickname',
          ),
        ),
      ),
      actions: [
        if (widget.onCancel != null)
          TextButton(
            onPressed: widget.onCancel,
            child: const Text('I Just want to watch 👀'),
          ),
        ElevatedButton(
          onPressed: widget.isLoading ? null : () => _submit(context),
          child: widget.isLoading
              ? const CircularProgressIndicator()
              : const Text('Start'),
        ),
      ],
    );
  }
}
