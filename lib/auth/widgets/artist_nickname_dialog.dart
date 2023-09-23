import 'package:flutter/material.dart';

class ArtistNicknameDialog extends StatefulWidget {
  const ArtistNicknameDialog({
    super.key,
    this.onSubmit,
  });

  final ValueChanged<String>? onSubmit;

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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick your artist nickname 🧑🏻‍🎨'),
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('I Just want to watch 👀'),
        ),
        ElevatedButton(
          onPressed: () => _submit(context),
          child: const Text('Start 🎨'),
        ),
      ],
    );
  }
}
