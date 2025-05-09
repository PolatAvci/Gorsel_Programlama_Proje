import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_text_field.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';
import 'package:gorsel_programlama_proje/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();

  bool _showRegisterForm = false;
  late AnimationController _animationController;
  late Animation<Offset> _loginAnimation;
  late Animation<Offset> _registerAnimation;
  bool isLoginOrRegister = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _loginAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1.5, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _registerAnimation = Tween<Offset>(
      begin: Offset(1.5, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _toggleForm() {
    setState(() {
      _showRegisterForm = !_showRegisterForm;
      if (_showRegisterForm) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    _emailController.clear();
    _registerEmailController.clear();
    _passwordController.clear();
    _registerNameController.clear();
    _registerPasswordController.clear();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            SlideTransition(
              position: _loginAnimation,
              child: Card(
                elevation: 10,
                child: GradientBorder(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Giriş Yap",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: 30),
                        CustomTextField(
                          controller: _emailController,
                          label: "Email",
                          focusedColor: Theme.of(context).colorScheme.primary,
                          enabledColor: Theme.of(context).colorScheme.onPrimary,
                          disabledColor:
                              Theme.of(context).colorScheme.onPrimary,
                          labelColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          label: "Parola",
                          isPassword: true,
                          focusedColor: Theme.of(context).colorScheme.primary,
                          enabledColor: Theme.of(context).colorScheme.onPrimary,
                          disabledColor:
                              Theme.of(context).colorScheme.onPrimary,
                          labelColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoginOrRegister = true;
                              });
                              UserService.login(
                                email: _emailController.text.toLowerCase(),
                                password: _passwordController.text,
                              ).then((_) {
                                if (!context.mounted) return;
                                setState(() {
                                  isLoginOrRegister = false;
                                });
                                if (UserService.user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Email veya parola yanlış!",
                                      ),
                                      showCloseIcon: true,
                                    ),
                                  );
                                  return;
                                }
                                Navigator.pop(context);
                              });
                            },
                            child:
                                isLoginOrRegister
                                    ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    )
                                    : Text("Giriş Yap"),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: _toggleForm,
                          child: Text(
                            "Hesabın yok mu? Kayıt ol",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _registerAnimation,
              child: Card(
                elevation: 10,
                child: GradientBorder(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Kayıt Ol",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: 30),
                        CustomTextField(
                          controller: _registerNameController,
                          label: "Kullanıcı Adı",
                          focusedColor: Theme.of(context).colorScheme.primary,
                          enabledColor: Theme.of(context).colorScheme.onPrimary,
                          disabledColor:
                              Theme.of(context).colorScheme.onPrimary,
                          labelColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _registerEmailController,
                          label: "E-posta",
                          focusedColor: Theme.of(context).colorScheme.primary,
                          enabledColor: Theme.of(context).colorScheme.onPrimary,
                          disabledColor:
                              Theme.of(context).colorScheme.onPrimary,
                          labelColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: _registerPasswordController,
                          label: "Parola",
                          isPassword: true,
                          focusedColor: Theme.of(context).colorScheme.primary,
                          enabledColor: Theme.of(context).colorScheme.onPrimary,
                          disabledColor:
                              Theme.of(context).colorScheme.onPrimary,
                          labelColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_registerEmailController.text.isEmpty ||
                                  _registerNameController.text.isEmpty ||
                                  _registerPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Lütfen tüm alanları doldurun!",
                                    ),
                                    showCloseIcon: true,
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                isLoginOrRegister = true;
                              });
                              UserService.register(
                                email:
                                    _registerEmailController.text.toLowerCase(),
                                username: _registerNameController.text,
                                password: _registerPasswordController.text,
                              ).then((_) {
                                if (!context.mounted) return;
                                setState(() {
                                  isLoginOrRegister = false;
                                });
                                Navigator.pop(context);
                              });
                            },
                            child:
                                isLoginOrRegister
                                    ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    )
                                    : Text("Kayıt Ol"),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: _toggleForm,
                          child: Text(
                            "Zaten hesabın var mı? Giriş yap",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
