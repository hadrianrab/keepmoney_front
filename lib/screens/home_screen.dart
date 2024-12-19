import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                  "Keep Money",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Marker Felt'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        labelText: "Nome de Usuário",
                        prefixIcon: const Icon(Icons.person, color: Colors.black),
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O nome de usuário não pode estar vazio';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                      buildTextField(
                        labelText: "Senha",
                        prefixIcon: const Icon(Icons.password, color: Colors.black),
                        isPassword: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Preencha a senha corretamente';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.018),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final username = _usernameController.text;
                        final password = _passwordController.text;

                        // Verificação simples de login
                        if (username == 'user' && password == '12345678') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login realizado com sucesso!')),
                          );
                          Navigator.of(context).pushReplacementNamed('/dashboardscreen');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Usuário ou senha incorretos')),
                          );
                        }
                      }
                    },
                    child: const Text('Login',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/registerscreen');
                  },
                  child: const Text(
                    'Não tem conta? Registre-se aqui',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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