import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.amber[300],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/money_icon.png'),
                      ),
                      border: Border.all(width: 2.0),
                      borderRadius: BorderRadius.circular(120.0),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  const Text(
                    "Cadastro de Usuário",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Marker Felt'),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  buildTextField(
                    labelText: "Nome de Usuário",
                    prefixIcon: const Icon(Icons.person, color: Colors.black),
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O nome de usuário não pode estar vazio';
                      } else if (value.length > 16) {
                        return 'O nome de usuário deve ter no máximo 16 caracteres';
                      } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                        return 'Use apenas letras e números, sem espaços ou caracteres especiais';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                  buildTextField(
                    labelText: "E-mail",
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O e-mail não pode estar vazio';
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                  buildTextField(
                    labelText: "Confirmar E-mail",
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    controller: _confirmEmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme o e-mail';
                      } else if (value != _emailController.text) {
                        return 'Os e-mails não coincidem';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                  buildTextField(
                    labelText: "Senha",
                    isPassword: true,
                    prefixIcon: const Icon(Icons.password, color: Colors.black),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A senha não pode estar vazia';
                      } else if (value.length < 6) {
                        return 'A senha precisa ter ao menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                  buildTextField(
                    labelText: "Confirmar Senha",
                    isPassword: true,
                    prefixIcon: const Icon(Icons.password, color: Colors.black),
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme a senha';
                      } else if (value != _passwordController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Volta para a tela de login
                    },
                    child: const Text(
                      'Já tem conta? Clique aqui',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Simulando o processo de registro
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cadastro realizado com sucesso!')),
                          );
                          Navigator.pop(context); // Volta para a tela de login
                        }
                      },
                      child: const Text(
                        'Registrar',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String labelText,
    required Icon prefixIcon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}