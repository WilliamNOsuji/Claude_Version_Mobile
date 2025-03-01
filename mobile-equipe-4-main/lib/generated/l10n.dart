// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Se Connecter`
  String get connexionPageTitle {
    return Intl.message(
      'Se Connecter',
      name: 'connexionPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Créer un compte`
  String get registerPageTitle {
    return Intl.message(
      'Créer un compte',
      name: 'registerPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Nom d'utilisateur`
  String get labelUsername {
    return Intl.message(
      'Nom d\'utilisateur',
      name: 'labelUsername',
      desc: '',
      args: [],
    );
  }

  /// `Mot de passe`
  String get labelPassword {
    return Intl.message(
      'Mot de passe',
      name: 'labelPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirmer votre mot de passe`
  String get labelConfirmPassword {
    return Intl.message(
      'Confirmer votre mot de passe',
      name: 'labelConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Matricule`
  String get labelMatricule {
    return Intl.message(
      'Matricule',
      name: 'labelMatricule',
      desc: '',
      args: [],
    );
  }

  /// `Accueil`
  String get labelHome {
    return Intl.message('Accueil', name: 'labelHome', desc: '', args: []);
  }

  /// `Panier`
  String get labelcart {
    return Intl.message('Panier', name: 'labelcart', desc: '', args: []);
  }

  /// `Profil`
  String get labelProfil {
    return Intl.message('Profil', name: 'labelProfil', desc: '', args: []);
  }

  /// `Connexion`
  String get buttonConnexion {
    return Intl.message(
      'Connexion',
      name: 'buttonConnexion',
      desc: '',
      args: [],
    );
  }

  /// `Créer un compte`
  String get buttonCreateAccont {
    return Intl.message(
      'Créer un compte',
      name: 'buttonCreateAccont',
      desc: '',
      args: [],
    );
  }

  /// `Matricule`
  String get labelIDNumber {
    return Intl.message('Matricule', name: 'labelIDNumber', desc: '', args: []);
  }

  /// `Entrez votre nom d\'utilisateur`
  String get hintUsernameTF {
    return Intl.message(
      'Entrez votre nom d\\\'utilisateur',
      name: 'hintUsernameTF',
      desc: '',
      args: [],
    );
  }

  /// `Entrez votre mot de passe`
  String get hintPasswordTF {
    return Intl.message(
      'Entrez votre mot de passe',
      name: 'hintPasswordTF',
      desc: '',
      args: [],
    );
  }

  /// `Enregistrer les modifications`
  String get saveChangeButton {
    return Intl.message(
      'Enregistrer les modifications',
      name: 'saveChangeButton',
      desc: '',
      args: [],
    );
  }

  /// `Annulé`
  String get cancelButton {
    return Intl.message('Annulé', name: 'cancelButton', desc: '', args: []);
  }

  /// `Profile modifié`
  String get modifyProfileSnackBar {
    return Intl.message(
      'Profile modifié',
      name: 'modifyProfileSnackBar',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
