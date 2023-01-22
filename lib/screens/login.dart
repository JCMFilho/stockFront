import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:stock/screens/home.dart';
import 'package:stock/consts/cores.dart';
import 'package:stock/consts/imagens.dart';
import 'package:stock/models/usuario.dart';
import 'package:stock/services/user_service.dart';
import 'package:stock/utils/authentication.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginModel login = LoginModel(login: data.name, senha: data.password);
    UsuarioModel user = await UserService.postLoginUsuario(login);
    return Future.delayed(loginTime).then((_) {
      if (user.id == null) {
        return 'Usuário não existe o/ou Senha incorreta';
      }
      prefs.setString('id', user.id ?? '');
      prefs.setString('role', user.role ?? '');
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Usuário não existe';
      }
      return 'table';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage(Images.logo),
      onLogin: _authUser,
      additionalSignupFields: const [
        UserFormField(keyName: 'cpf', displayName: 'CPF'),
        UserFormField(keyName: 'rg', displayName: 'RG'),
        UserFormField(keyName: 'nome', displayName: 'Nome completo'),
        UserFormField(
            keyName: 'celular',
            displayName: 'Celular',
            userType: LoginUserType.phone),
        UserFormField(
            keyName: 'telefone',
            displayName: 'Telefone',
            userType: LoginUserType.phone),
      ],
      onSignup: _signupUser,
      theme: LoginTheme(
          pageColorLight: yellow,
          accentColor: lightBlue,
          buttonTheme: const LoginButtonTheme(
              backgroundColor: Color.fromARGB(255, 20, 12, 100))),
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            await signInWithGoogle();
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.facebookF,
          label: 'Facebook',
          callback: () async {
            debugPrint('start facebook sign in');
            signInWithFacebook();
            debugPrint('stop facebook sign in');
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.twitter,
          label: 'Twitter',
          callback: () async {
            debugPrint('start twitter sign in');
            signInWithTwitter();
            debugPrint('stop twitter sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
          userHint: 'Email',
          passwordHint: 'Senha',
          confirmPasswordHint: 'Confirmar senha',
          loginButton: 'LOGIN',
          signupButton: 'Não tem uma conta? Cadastre-se',
          confirmSignupButton: 'Cadastrar',
          forgotPasswordButton: 'Esqueceu a senha?',
          recoverPasswordButton: 'Enviar',
          goBackButton: 'Voltar',
          confirmPasswordError: 'Senha não correspondem',
          providersTitleFirst: 'ou logar com:',
          recoverPasswordIntro: 'Troque sua senha aqui',
          recoverPasswordDescription:
              'Insira o seu e-mail para recuperar sua senha',
          recoverPasswordSuccess: 'Senha recuperada com sucesso',
          additionalSignUpFormDescription:
              'Por favor, preencha o formulário para completar o seu cadastro',
          additionalSignUpSubmitButton: 'Cadastrar'),
    );
  }
}
