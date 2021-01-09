import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController imageUrlController;
  TextEditingController numberController;
  GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();

    imageUrlController = TextEditingController();
    numberController = TextEditingController();
    formKey = GlobalKey();
  }

  Future<void> _onButtonTap() async {
    if (formKey.currentState.validate()) {}
  }

  String imageUrlValidator(String s) {
    final err = 'Значение должно быть ссылкой';

    try {
      final uri = Uri.parse(s);

      if (uri.scheme.isEmpty) {
        return err;
      }
    } catch (e) {
      return err;
    }

    return null;
  }

  String numberValidator(String s) {
    final err = 'Значение должно быть целым числом от 3 до 5';

    try {
      final i = int.parse(s);
      if (i < 3 || i > 5) {
        return err;
      }
    } catch (e) {
      return err;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder();
    final inputDecoration = InputDecoration(
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder,
    );

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: imageUrlController,
                validator: imageUrlValidator,
                decoration: inputDecoration.copyWith(
                  labelText: 'Image url',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: numberController,
                validator: numberValidator,
                keyboardType: TextInputType.number,
                decoration: inputDecoration.copyWith(
                  labelText: 'Number (3-5)',
                ),
              ),
              ElevatedButton(
                onPressed: _onButtonTap,
                child: Text('Button!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
