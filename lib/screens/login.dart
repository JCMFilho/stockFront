import 'dart:developer';

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
import 'package:uuid/uuid.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginModel login = LoginModel(login: data.name, senha: data.password);
    UsuarioModel user = await UserService.postLoginUsuario(login);
    return Future.delayed(loginTime).then((_) {
      if (user.id == null) {
        return 'Usuário não existe e/ou senha incorreta';
      }
      prefs.setString('id', user.id ?? '');
      prefs.setString('role', user.role ?? '');
      prefs.setString('login', 'email');
      prefs.setString('avatar', user.avatar ?? '');
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    UsuarioModel? fullUser = UsuarioModel(id: null, nome: null, email: null);

    return Future.delayed(loginTime).then((_) async {
      try {
        var uuid = const Uuid();
        var v1 = uuid.v1();
        fullUser.id = v1;
        fullUser.email = data.name;
        fullUser.senha = data.password;
        fullUser.nome = data.additionalSignupData!['nome'];
        fullUser.cpf = data.additionalSignupData!['cpf'];
        fullUser.rg = data.additionalSignupData!['rg'];
        fullUser.celular = data.additionalSignupData!['celular'];
        fullUser.telefone = data.additionalSignupData!['telefone'];
        fullUser.role = "comum";
        await UserService.postUsuario(fullUser);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', fullUser.id ?? '');
        prefs.setString('role', fullUser.role ?? '');
        prefs.setString('login', 'email');
        prefs.setString('avatar', fullUser.avatar ?? '');

        return null;
      } catch (error) {
        log("an error occured while signup email info $error");
        throw error.toString();
      }
    });
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      return 'Senha deve conter pelo menos 8 caracteres';
    }
    return null;
  }

  String? _validateUser(String? value) {
    if (!value!.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }

  Future<String?> _recoverPassword(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UsuarioModel user = await UserService.getUsuarioByEmail(email);
    String verificationCode = '';
    if (user.id == null) {
      verificationCode = 'Usuário não existe';
    } else {
      int code = await UserService.recuperarSenha(email);
      verificationCode = code.toString();
    }
    return Future.delayed(loginTime).then((_) {
      prefs.setString('code', verificationCode.toString());
      return null;
    });
  }

  Future<String?> _confirmPassword(
      String verificationCode, LoginData login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('code') != verificationCode) {
      return 'Código incorreto';
    }
    prefs.remove('code');
    bool result = await UserService.trocarSenha(
        LoginModel(login: login.name, senha: login.password));
    return Future.delayed(loginTime).then((_) {
      if (!result) {
        return 'Não foi possível alterar senha, tente novamente mais tarde';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage(Images.logo),
      onLogin: _authUser,
      additionalSignupFields: [
        UserFormField(
            keyName: 'cpf',
            displayName: 'CPF',
            fieldValidator: (value) {
              final numericRegex = RegExp(r'^-?[0-9]+$');
              if (value!.length > 11) {
                return 'CPF deve conter no máximo 11 caracteres';
              }
              if (!numericRegex.hasMatch(value)) {
                return 'CPF deve conter apenas números';
              }
              return null;
            }),
        UserFormField(
            keyName: 'rg',
            displayName: 'RG',
            fieldValidator: (value) {
              final numericRegex = RegExp(r'^-?[0-9]+$');
              if (value!.length > 8) {
                return 'RG deve conter no máximo 8 caracteres';
              }
              if (!numericRegex.hasMatch(value)) {
                return 'RG deve conter apenas números';
              }
              return null;
            }),
        UserFormField(
            keyName: 'nome',
            displayName: 'Nome completo',
            fieldValidator: (value) => !value!.contains(' ')
                ? 'Digite pelo menos um sobrenome'
                : null),
        UserFormField(
            keyName: 'celular',
            displayName: 'Celular',
            userType: LoginUserType.phone,
            fieldValidator: (value) {
              final numericRegex = RegExp(r'^-?[0-9]+$');
              if (value!.length > 11) {
                return 'Celular deve conter no máximo 11 caracteres';
              }
              if (!numericRegex.hasMatch(value)) {
                return 'Celular deve conter apenas números';
              }
              return null;
            }),
        UserFormField(
            keyName: 'telefone',
            displayName: 'Telefone',
            userType: LoginUserType.phone,
            fieldValidator: (value) {
              final numericRegex = RegExp(r'^-?[0-9]+$');
              if (value!.length > 10) {
                return 'Telefone deve conter no máximo 10 caracteres';
              }
              if (!numericRegex.hasMatch(value)) {
                return 'Telefone deve conter apenas números';
              }
              return null;
            }),
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
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.facebookF,
          label: 'Facebook',
          callback: () async {
            await signInWithFacebook();
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.twitter,
          label: 'Twitter',
          callback: () async {
            await signInWithTwitter();
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
      onRecoverPassword: _recoverPassword,
      onConfirmRecover: _confirmPassword,
      passwordValidator: _validatePassword,
      userValidator: _validateUser,
      messages: LoginMessages(
          userHint: 'Email',
          passwordHint: 'Senha',
          confirmPasswordHint: 'Confirmar senha',
          loginButton: 'LOGIN',
          signupButton: 'Não tem uma conta? Cadastre-se',
          confirmSignupButton: 'Cadastrar',
          confirmSignupSuccess: 'Cadastro realizado com sucesso',
          confirmSignupIntro: 'Cadastro realizado com sucesso',
          forgotPasswordButton: 'Esqueceu a senha?',
          recoverPasswordButton: 'Enviar',
          goBackButton: 'Voltar',
          setPasswordButton: 'Trocar senha',
          confirmPasswordError: 'Senha não correspondem',
          providersTitleFirst: 'ou logar com:',
          recoverPasswordIntro: 'Insira um e-mail valido',
          recoverCodePasswordDescription:
              'Você receberá por e-mail um código para alterar sua senha',
          recoverPasswordSuccess: 'Código enviado com sucesso',
          confirmRecoverSuccess: 'Senha alterada com sucesso',
          recoveryCodeHint: 'Código de recuperação',
          confirmRecoverIntro:
              'Use o código de recuparação enviado para seu e-mail para trocar sua senha',
          additionalSignUpFormDescription:
              'Por favor, preencha o formulário para completar o seu cadastro',
          additionalSignUpSubmitButton: 'Cadastrar',
          signUpSuccess: 'Usuário criado com sucesso'),
    );
  }
}
