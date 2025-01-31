import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_components/modals/notificacion/notificacion_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:listas_app/common/loading_spinner.dart';
import 'package:listas_app/data/service/usuario_service_impl.dart';
import 'package:listas_app/domain/entities/security/request/login_request.dart';
import 'package:listas_app/security/provider/auth_provider.dart';
import 'package:utils/utils.dart';

import '../../../../security/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, String> formSave = {};
  final loginService = UsuarioServiceImpl();

  @override
  void initState() {
    super.initState();
    checkSessionAuth(mounted, context);
  }

  Future<void> handleOnLogin() async {
    if (formSave["password"] == null || formSave["username"] == null) {
      NotificacionDialog(
              context: context,
              textBtnCancelar: "Cerrar",
              notificationType: NotificationType.error,
              subtitle: "Ingrese usuario y/o password")
          .show();
      return;
    }

    try {
      onLoadingSpinner(true, context);

      final resultLogin = await loginService.login(LoginRequest(
          password: formSave["password"], username: formSave["username"]));

      if (mounted) {
        onLoadingSpinner(false, context);
      }
      if (resultLogin.statusCode == 200) {
        Toasted.success(message: "usuario autenticado correctamente").show();

        if (resultLogin.data != null) {
          final logged = await AuthProvider().logged(resultLogin.data!);
          if (logged) {
            if (mounted) {
              context.go("/products");
            }
          }
        }
      } else {
        setState(() {
          formSave = {};
        });
        Toasted.warning(message: "${resultLogin.message}").show();
        return;
      }
    } catch (e) {
      setState(() {
        formSave = {};
      });
      if (mounted) {
        log(e.toString());
        onLoadingSpinner(false, context);
        NotificacionDialog(
                context: context,
                notificationType: NotificationType.error,
                subtitle: e.toString())
            .show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: Image.asset(
                    'assets/images/login_image.jpg',
                    // #Image Url: https://unsplash.com/photos/bOBM8CB4ZC4
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                            child: SizedBox(
                              width: size.width * .9,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: size.width * .15,
                                      bottom: size.width * .1,
                                    ),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(.8),
                                      ),
                                    ),
                                  ),
                                  // component(
                                  //   Icons.account_circle_outlined,
                                  //   'User name...',
                                  //   false,
                                  //   false,
                                  // ),
                                  component(Icons.email_outlined, 'Usuario',
                                      false, true, formSave, 'username'),
                                  component(Icons.lock_outline, 'Contraseña',
                                      true, false, formSave, 'password'),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [],
                                  ),
                                  SizedBox(height: size.width * .3),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        bottom: size.width * .05,
                                      ),
                                      height: size.width / 8,
                                      width: size.width / 1.25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextButton.icon(
                                        onPressed: handleOnLogin,
                                        // context.go("/products"),
                                        label: const Text("Autenticar"),
                                        icon: const Icon(Icons.lock),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget component(IconData icon, String hintText, bool isPassword,
      bool isEmail, Map<String, String> formSave, String formKey) {
    Size size = MediaQuery.of(context).size;
    TextEditingController controller = TextEditingController();

    void handleChange(String value) {
      formSave[formKey] = value;
    }

    return Container(
      height: size.width / 8,
      width: size.width / 1.25,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: size.width / 30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: handleChange,
        controller: controller,
        style: TextStyle(
          color: Colors.white.withOpacity(.9),
        ),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(.8),
          ),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(.5),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
