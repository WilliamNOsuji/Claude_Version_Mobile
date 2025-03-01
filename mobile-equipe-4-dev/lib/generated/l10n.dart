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

  /// `Email`
  String get labelEmail {
    return Intl.message('Email', name: 'labelEmail', desc: '', args: []);
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

  /// `Prénom`
  String get labelFirstName {
    return Intl.message('Prénom', name: 'labelFirstName', desc: '', args: []);
  }

  /// `Nom de famille`
  String get labelLastName {
    return Intl.message(
      'Nom de famille',
      name: 'labelLastName',
      desc: '',
      args: [],
    );
  }

  /// `Commands`
  String get labelCommand {
    return Intl.message('Commands', name: 'labelCommand', desc: '', args: []);
  }

  /// `Livraison`
  String get labelDelivery {
    return Intl.message('Livraison', name: 'labelDelivery', desc: '', args: []);
  }

  /// `Register`
  String get labelRegister {
    return Intl.message('Register', name: 'labelRegister', desc: '', args: []);
  }

  /// `Nouveau Mot de passe`
  String get labelNewPassord {
    return Intl.message(
      'Nouveau Mot de passe',
      name: 'labelNewPassord',
      desc: '',
      args: [],
    );
  }

  /// `Ancien Mot de passe`
  String get labelOldPassord {
    return Intl.message(
      'Ancien Mot de passe',
      name: 'labelOldPassord',
      desc: '',
      args: [],
    );
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

  /// `Enregistrer`
  String get saveChangeButton {
    return Intl.message(
      'Enregistrer',
      name: 'saveChangeButton',
      desc: '',
      args: [],
    );
  }

  /// `Annuler`
  String get cancelButton {
    return Intl.message('Annuler', name: 'cancelButton', desc: '', args: []);
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

  /// `Username empty`
  String get errorUsernameEmpty {
    return Intl.message(
      'Username empty',
      name: 'errorUsernameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Username needs to be more than 3 characters`
  String get errorUsernameLength {
    return Intl.message(
      'Username needs to be more than 3 characters',
      name: 'errorUsernameLength',
      desc: '',
      args: [],
    );
  }

  /// `One of the password fields are emtpy`
  String get errorRegisterPasswordsEmpty {
    return Intl.message(
      'One of the password fields are emtpy',
      name: 'errorRegisterPasswordsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `The password is too short`
  String get errorPasswordShort {
    return Intl.message(
      'The password is too short',
      name: 'errorPasswordShort',
      desc: '',
      args: [],
    );
  }

  /// `Password need to have 40 character or less`
  String get errorPasswordMaxLength {
    return Intl.message(
      'Password need to have 40 character or less',
      name: 'errorPasswordMaxLength',
      desc: '',
      args: [],
    );
  }

  /// `Password and confirmed password arent the same`
  String get errorPasswordNotTheSame {
    return Intl.message(
      'Password and confirmed password arent the same',
      name: 'errorPasswordNotTheSame',
      desc: '',
      args: [],
    );
  }

  /// `the password field is emtpy`
  String get errorSignInPasswordEmpty {
    return Intl.message(
      'the password field is emtpy',
      name: 'errorSignInPasswordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Username or password invalid`
  String get errorSignInUsername {
    return Intl.message(
      'Username or password invalid',
      name: 'errorSignInUsername',
      desc: '',
      args: [],
    );
  }

  /// `First name is empty`
  String get errorFirstName {
    return Intl.message(
      'First name is empty',
      name: 'errorFirstName',
      desc: '',
      args: [],
    );
  }

  /// `First name needs to be at least 2 characters`
  String get errorFirstNameLength {
    return Intl.message(
      'First name needs to be at least 2 characters',
      name: 'errorFirstNameLength',
      desc: '',
      args: [],
    );
  }

  /// `Last name is empty`
  String get errorLastName {
    return Intl.message(
      'Last name is empty',
      name: 'errorLastName',
      desc: '',
      args: [],
    );
  }

  /// `Last name needs to be at least 2 characters`
  String get errorLastNameLength {
    return Intl.message(
      'Last name needs to be at least 2 characters',
      name: 'errorLastNameLength',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchBarHint {
    return Intl.message('Search', name: 'searchBarHint', desc: '', args: []);
  }

  /// `Sold out`
  String get noStockWidget {
    return Intl.message('Sold out', name: 'noStockWidget', desc: '', args: []);
  }

  /// `There are no suggested products`
  String get noSuggestedProducts {
    return Intl.message(
      'There are no suggested products',
      name: 'noSuggestedProducts',
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
