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

  /// `Log In`
  String get connexionPageTitle {
    return Intl.message(
      'Log In',
      name: 'connexionPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create an Account`
  String get registerPageTitle {
    return Intl.message(
      'Create an Account',
      name: 'registerPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get labelUsername {
    return Intl.message('Username', name: 'labelUsername', desc: '', args: []);
  }

  /// `Password`
  String get labelPassword {
    return Intl.message('Password', name: 'labelPassword', desc: '', args: []);
  }

  /// `Confirm your password`
  String get labelConfirmPassword {
    return Intl.message(
      'Confirm your password',
      name: 'labelConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get labelEmail {
    return Intl.message('Email', name: 'labelEmail', desc: '', args: []);
  }

  /// `Home`
  String get labelHome {
    return Intl.message('Home', name: 'labelHome', desc: '', args: []);
  }

  /// `Cart`
  String get labelcart {
    return Intl.message('Cart', name: 'labelcart', desc: '', args: []);
  }

  /// `Profile`
  String get labelProfil {
    return Intl.message('Profile', name: 'labelProfil', desc: '', args: []);
  }

  /// `First Name`
  String get labelFirstName {
    return Intl.message(
      'First Name',
      name: 'labelFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get labelLastName {
    return Intl.message('Last Name', name: 'labelLastName', desc: '', args: []);
  }

  /// `Orders`
  String get labelCommand {
    return Intl.message('Orders', name: 'labelCommand', desc: '', args: []);
  }

  /// `Delivery`
  String get labelDelivery {
    return Intl.message('Delivery', name: 'labelDelivery', desc: '', args: []);
  }

  /// `Register`
  String get labelRegister {
    return Intl.message('Register', name: 'labelRegister', desc: '', args: []);
  }

  /// `New Password`
  String get labelNewPassord {
    return Intl.message(
      'New Password',
      name: 'labelNewPassord',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get labelOldPassord {
    return Intl.message(
      'Old Password',
      name: 'labelOldPassord',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get buttonConnexion {
    return Intl.message('Log In', name: 'buttonConnexion', desc: '', args: []);
  }

  /// `Create an account`
  String get buttonCreateAccont {
    return Intl.message(
      'Create an account',
      name: 'buttonCreateAccont',
      desc: '',
      args: [],
    );
  }

  /// `ID Number`
  String get labelIDNumber {
    return Intl.message('ID Number', name: 'labelIDNumber', desc: '', args: []);
  }

  /// `Enter your username`
  String get hintUsernameTF {
    return Intl.message(
      'Enter your username',
      name: 'hintUsernameTF',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get hintPasswordTF {
    return Intl.message(
      'Enter your password',
      name: 'hintPasswordTF',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChangeButton {
    return Intl.message(
      'Save Changes',
      name: 'saveChangeButton',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message('Cancel', name: 'cancelButton', desc: '', args: []);
  }

  /// `Profile updated`
  String get modifyProfileSnackBar {
    return Intl.message(
      'Profile updated',
      name: 'modifyProfileSnackBar',
      desc: '',
      args: [],
    );
  }

  /// `Username is empty`
  String get errorUsernameEmpty {
    return Intl.message(
      'Username is empty',
      name: 'errorUsernameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Username must be more than 3 characters`
  String get errorUsernameLength {
    return Intl.message(
      'Username must be more than 3 characters',
      name: 'errorUsernameLength',
      desc: '',
      args: [],
    );
  }

  /// `One of the password fields is empty`
  String get errorRegisterPasswordsEmpty {
    return Intl.message(
      'One of the password fields is empty',
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

  /// `Password must be 40 characters or less`
  String get errorPasswordMaxLength {
    return Intl.message(
      'Password must be 40 characters or less',
      name: 'errorPasswordMaxLength',
      desc: '',
      args: [],
    );
  }

  /// `Password and confirmed password aren't the same`
  String get errorPasswordNotTheSame {
    return Intl.message(
      'Password and confirmed password aren\'t the same',
      name: 'errorPasswordNotTheSame',
      desc: '',
      args: [],
    );
  }

  /// `The password field is empty`
  String get errorSignInPasswordEmpty {
    return Intl.message(
      'The password field is empty',
      name: 'errorSignInPasswordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid username or password`
  String get errorSignInUsername {
    return Intl.message(
      'Invalid username or password',
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

  /// `First name must be at least 2 characters`
  String get errorFirstNameLength {
    return Intl.message(
      'First name must be at least 2 characters',
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

  /// `Last name must be at least 2 characters`
  String get errorLastNameLength {
    return Intl.message(
      'Last name must be at least 2 characters',
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

  /// `Vote`
  String get voteAppBarTitle {
    return Intl.message('Vote', name: 'voteAppBarTitle', desc: '', args: []);
  }

  /// `No suggestions available`
  String get noSuggestedProducts {
    return Intl.message(
      'No suggestions available',
      name: 'noSuggestedProducts',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get countdownDays {
    return Intl.message('days', name: 'countdownDays', desc: '', args: []);
  }

  /// `hours`
  String get countdownHours {
    return Intl.message('hours', name: 'countdownHours', desc: '', args: []);
  }

  /// `minutes`
  String get countdownMinutes {
    return Intl.message(
      'minutes',
      name: 'countdownMinutes',
      desc: '',
      args: [],
    );
  }

  /// `seconds`
  String get countdownSeconds {
    return Intl.message(
      'seconds',
      name: 'countdownSeconds',
      desc: '',
      args: [],
    );
  }

  /// `No suggestions found`
  String get webNoSuggestionsFound {
    return Intl.message(
      'No suggestions found',
      name: 'webNoSuggestionsFound',
      desc: '',
      args: [],
    );
  }

  /// `Product Suggestions`
  String get webSuggestionsTitle {
    return Intl.message(
      'Product Suggestions',
      name: 'webSuggestionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Vote for your favorite products!`
  String get webVoteTagline {
    return Intl.message(
      'Vote for your favorite products!',
      name: 'webVoteTagline',
      desc: '',
      args: [],
    );
  }

  /// `Image not available`
  String get webImageNotAvailable {
    return Intl.message(
      'Image not available',
      name: 'webImageNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get likeButton {
    return Intl.message('Like', name: 'likeButton', desc: '', args: []);
  }

  /// `Dislike`
  String get dislikeButton {
    return Intl.message('Dislike', name: 'dislikeButton', desc: '', args: []);
  }

  /// `Create your password`
  String get createYourPassword {
    return Intl.message(
      'Create your password',
      name: 'createYourPassword',
      desc: '',
      args: [],
    );
  }

  /// ` is logged in!`
  String get userLoggedIn {
    return Intl.message(
      ' is logged in!',
      name: 'userLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginPageTitle {
    return Intl.message('Login', name: 'loginPageTitle', desc: '', args: []);
  }

  /// `Create an account`
  String get crerUnCompte {
    return Intl.message(
      'Create an account',
      name: 'crerUnCompte',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get dtailsDeLaCommande {
    return Intl.message(
      'Order Details',
      name: 'dtailsDeLaCommande',
      desc: '',
      args: [],
    );
  }

  /// `Order Number: `
  String get numroDeCommandeCommandcommandnumber {
    return Intl.message(
      'Order Number: ',
      name: 'numroDeCommandeCommandcommandnumber',
      desc: '',
      args: [],
    );
  }

  /// `Status: `
  String get status {
    return Intl.message('Status: ', name: 'status', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Pending`
  String get waiting {
    return Intl.message('Pending', name: 'waiting', desc: '', args: []);
  }

  /// `Order`
  String get comand {
    return Intl.message('Order', name: 'comand', desc: '', args: []);
  }

  /// `Client Phone Number: `
  String get NumeroDeTelephone {
    return Intl.message(
      'Client Phone Number: ',
      name: 'NumeroDeTelephone',
      desc: '',
      args: [],
    );
  }

  /// `Arrival Time: `
  String get arrivalTime {
    return Intl.message(
      'Arrival Time: ',
      name: 'arrivalTime',
      desc: '',
      args: [],
    );
  }

  /// `Total Price: `
  String get totalPrice {
    return Intl.message(
      'Total Price: ',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Client ID: `
  String get ClientId {
    return Intl.message('Client ID: ', name: 'ClientId', desc: '', args: []);
  }

  /// `Delivery Person Information`
  String get livreurInfo {
    return Intl.message(
      'Delivery Person Information',
      name: 'livreurInfo',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Person ID: `
  String get livreurID {
    return Intl.message(
      'Delivery Person ID: ',
      name: 'livreurID',
      desc: '',
      args: [],
    );
  }

  /// `Not assigned`
  String get assignation {
    return Intl.message(
      'Not assigned',
      name: 'assignation',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get disponible {
    return Intl.message('Available', name: 'disponible', desc: '', args: []);
  }

  /// `My Orders`
  String get mescommandes {
    return Intl.message('My Orders', name: 'mescommandes', desc: '', args: []);
  }

  /// `You have never placed an order.`
  String get jamaisCommande {
    return Intl.message(
      'You have never placed an order.',
      name: 'jamaisCommande',
      desc: '',
      args: [],
    );
  }

  /// `Order ID: `
  String get idCommande {
    return Intl.message('Order ID: ', name: 'idCommande', desc: '', args: []);
  }

  /// `Waiting for a delivery person`
  String get attenteLivreur {
    return Intl.message(
      'Waiting for a delivery person',
      name: 'attenteLivreur',
      desc: '',
      args: [],
    );
  }

  /// `Delivery in progress`
  String get enCoursDeLivraison {
    return Intl.message(
      'Delivery in progress',
      name: 'enCoursDeLivraison',
      desc: '',
      args: [],
    );
  }

  /// `Feature coming soon`
  String get FonctionToCome {
    return Intl.message(
      'Feature coming soon',
      name: 'FonctionToCome',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Person: N/A`
  String get Livreurna {
    return Intl.message(
      'Delivery Person: N/A',
      name: 'Livreurna',
      desc: '',
      args: [],
    );
  }

  /// `Total: `
  String get total {
    return Intl.message('Total: ', name: 'total', desc: '', args: []);
  }

  /// `Don't change your password`
  String get dontchangePassword {
    return Intl.message(
      'Don\'t change your password',
      name: 'dontchangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Change your `
  String get changeYour {
    return Intl.message('Change your ', name: 'changeYour', desc: '', args: []);
  }

  /// `Enter your `
  String get enterYour {
    return Intl.message('Enter your ', name: 'enterYour', desc: '', args: []);
  }

  /// `Profile updated successfully!`
  String get profileUpdated {
    return Intl.message(
      'Profile updated successfully!',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error updating profile! Please try again.`
  String get profileUpdatedError {
    return Intl.message(
      'Error updating profile! Please try again.',
      name: 'profileUpdatedError',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profil {
    return Intl.message('Profile', name: 'profil', desc: '', args: []);
  }

  /// `Loading...`
  String get chargement {
    return Intl.message('Loading...', name: 'chargement', desc: '', args: []);
  }

  /// `Inactive`
  String get inactif {
    return Intl.message('Inactive', name: 'inactif', desc: '', args: []);
  }

  /// `Active`
  String get actif {
    return Intl.message('Active', name: 'actif', desc: '', args: []);
  }

  /// `In delivery mode`
  String get enModeLivreur {
    return Intl.message(
      'In delivery mode',
      name: 'enModeLivreur',
      desc: '',
      args: [],
    );
  }

  /// `Become a delivery person`
  String get devenirLivreur {
    return Intl.message(
      'Become a delivery person',
      name: 'devenirLivreur',
      desc: '',
      args: [],
    );
  }

  /// `Resign`
  String get dmissionner {
    return Intl.message('Resign', name: 'dmissionner', desc: '', args: []);
  }

  /// `Settings`
  String get paramtres {
    return Intl.message('Settings', name: 'paramtres', desc: '', args: []);
  }

  /// `Edit my profile`
  String get modifierMonProfil {
    return Intl.message(
      'Edit my profile',
      name: 'modifierMonProfil',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get propos {
    return Intl.message('About', name: 'propos', desc: '', args: []);
  }

  /// `Log out`
  String get dconnexion {
    return Intl.message('Log out', name: 'dconnexion', desc: '', args: []);
  }

  /// `You will be active as a delivery person and you will be able to deliver orders to customers.`
  String get vousAllezTreActifEnTantQueLivreurEtVous {
    return Intl.message(
      'You will be active as a delivery person and you will be able to deliver orders to customers.',
      name: 'vousAllezTreActifEnTantQueLivreurEtVous',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get annuler {
    return Intl.message('Cancel', name: 'annuler', desc: '', args: []);
  }

  /// `Start`
  String get commencer {
    return Intl.message('Start', name: 'commencer', desc: '', args: []);
  }

  /// `You will no longer be able to be active as a delivery person and you will no longer be able to deliver orders to customers.`
  String get vousNallezPlusPouvoirTreActifEnTantQueLivreur {
    return Intl.message(
      'You will no longer be able to be active as a delivery person and you will no longer be able to deliver orders to customers.',
      name: 'vousNallezPlusPouvoirTreActifEnTantQueLivreur',
      desc: '',
      args: [],
    );
  }

  /// `Resign`
  String get demmissioner {
    return Intl.message('Resign', name: 'demmissioner', desc: '', args: []);
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Order ID: `
  String get orderID {
    return Intl.message('Order ID: ', name: 'orderID', desc: '', args: []);
  }

  /// `Status: Waiting for a delivery person`
  String get statusEnAttenteDunLivreur {
    return Intl.message(
      'Status: Waiting for a delivery person',
      name: 'statusEnAttenteDunLivreur',
      desc: '',
      args: [],
    );
  }

  /// `Status: Delivery in progress`
  String get statusEnCoursDeLivraison {
    return Intl.message(
      'Status: Delivery in progress',
      name: 'statusEnCoursDeLivraison',
      desc: '',
      args: [],
    );
  }

  /// `Assign`
  String get assign {
    return Intl.message('Assign', name: 'assign', desc: '', args: []);
  }

  /// `Assigned successfully`
  String get assignedSuccess {
    return Intl.message(
      'Assigned successfully',
      name: 'assignedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to assign delivery: `
  String get failedassignDelivery {
    return Intl.message(
      'Failed to assign delivery: ',
      name: 'failedassignDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load orders: `
  String get echecChargementCommandes {
    return Intl.message(
      'Failed to load orders: ',
      name: 'echecChargementCommandes',
      desc: '',
      args: [],
    );
  }

  /// `Delivery assigned successfully`
  String get livraisonAssigneAvecSuccs {
    return Intl.message(
      'Delivery assigned successfully',
      name: 'livraisonAssigneAvecSuccs',
      desc: '',
      args: [],
    );
  }

  /// `Delivery assignment failed:`
  String get checDeLassignationDeLaLivraison {
    return Intl.message(
      'Delivery assignment failed:',
      name: 'checDeLassignationDeLaLivraison',
      desc: '',
      args: [],
    );
  }

  /// `Order Tracking`
  String get suiviDesCommandes {
    return Intl.message(
      'Order Tracking',
      name: 'suiviDesCommandes',
      desc: '',
      args: [],
    );
  }

  /// `Order #`
  String get commande {
    return Intl.message('Order #', name: 'commande', desc: '', args: []);
  }

  /// `Delivery Person:`
  String get livreur {
    return Intl.message(
      'Delivery Person:',
      name: 'livreur',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Person: Unassigned`
  String get livreurNonAssign {
    return Intl.message(
      'Delivery Person: Unassigned',
      name: 'livreurNonAssign',
      desc: '',
      args: [],
    );
  }

  /// `Arrival Point:`
  String get pointDarrive {
    return Intl.message(
      'Arrival Point:',
      name: 'pointDarrive',
      desc: '',
      args: [],
    );
  }

  /// `Assign`
  String get assigner {
    return Intl.message('Assign', name: 'assigner', desc: '', args: []);
  }

  /// `No one has ordered.`
  String get personneNaCommand {
    return Intl.message(
      'No one has ordered.',
      name: 'personneNaCommand',
      desc: '',
      args: [],
    );
  }

  /// `View My Deliveries`
  String get voirMesLivraisons {
    return Intl.message(
      'View My Deliveries',
      name: 'voirMesLivraisons',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load deliveries:`
  String get checDuChargementDesLivraisons {
    return Intl.message(
      'Failed to load deliveries:',
      name: 'checDuChargementDesLivraisons',
      desc: '',
      args: [],
    );
  }

  /// `Delivery completed successfully`
  String get livraisonEffectueAvecSuccs {
    return Intl.message(
      'Delivery completed successfully',
      name: 'livraisonEffectueAvecSuccs',
      desc: '',
      args: [],
    );
  }

  /// `Failed to mark as delivered:`
  String get checDeLaMarqueCommeLivr {
    return Intl.message(
      'Failed to mark as delivered:',
      name: 'checDeLaMarqueCommeLivr',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Delivery`
  String get annulerLaLivraison {
    return Intl.message(
      'Cancel Delivery',
      name: 'annulerLaLivraison',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this delivery?`
  String get tesvousSrDeVouloirAnnulerCetteLivraison {
    return Intl.message(
      'Are you sure you want to cancel this delivery?',
      name: 'tesvousSrDeVouloirAnnulerCetteLivraison',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get non {
    return Intl.message('No', name: 'non', desc: '', args: []);
  }

  /// `Yes`
  String get oui {
    return Intl.message('Yes', name: 'oui', desc: '', args: []);
  }

  /// `Cancellation successful`
  String get annulationRussie {
    return Intl.message(
      'Cancellation successful',
      name: 'annulationRussie',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel delivery:`
  String get checDeLannulationDeLaLivraison {
    return Intl.message(
      'Failed to cancel delivery:',
      name: 'checDeLannulationDeLaLivraison',
      desc: '',
      args: [],
    );
  }

  /// `My Deliveries`
  String get mesLivraisons {
    return Intl.message(
      'My Deliveries',
      name: 'mesLivraisons',
      desc: '',
      args: [],
    );
  }

  /// `order-`
  String get command {
    return Intl.message('order-', name: 'command', desc: '', args: []);
  }

  /// `Status: Delivered`
  String get statutLivre {
    return Intl.message(
      'Status: Delivered',
      name: 'statutLivre',
      desc: '',
      args: [],
    );
  }

  /// `Status: Pending`
  String get statutEnAttente {
    return Intl.message(
      'Status: Pending',
      name: 'statutEnAttente',
      desc: '',
      args: [],
    );
  }

  /// `Deliver`
  String get livrer {
    return Intl.message('Deliver', name: 'livrer', desc: '', args: []);
  }

  /// `Cart`
  String get panier {
    return Intl.message('Cart', name: 'panier', desc: '', args: []);
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `The cart is empty`
  String get lePanierEstVide {
    return Intl.message(
      'The cart is empty',
      name: 'lePanierEstVide',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get payer {
    return Intl.message('Pay', name: 'payer', desc: '', args: []);
  }

  /// `Your cart is empty!`
  String get yourCartIsEmpty {
    return Intl.message(
      'Your cart is empty!',
      name: 'yourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Max:`
  String get max {
    return Intl.message('Max:', name: 'max', desc: '', args: []);
  }

  /// `Out of Stock`
  String get puis {
    return Intl.message('Out of Stock', name: 'puis', desc: '', args: []);
  }

  /// `Checkout`
  String get vrification {
    return Intl.message('Checkout', name: 'vrification', desc: '', args: []);
  }

  /// `My products`
  String get mesProduits {
    return Intl.message('My products', name: 'mesProduits', desc: '', args: []);
  }

  /// `products`
  String get produits {
    return Intl.message('products', name: 'produits', desc: '', args: []);
  }

  /// `Qty:`
  String get nbr {
    return Intl.message('Qty:', name: 'nbr', desc: '', args: []);
  }

  /// `Price:`
  String get prix {
    return Intl.message('Price:', name: 'prix', desc: '', args: []);
  }

  /// `My details`
  String get mesInformations {
    return Intl.message(
      'My details',
      name: 'mesInformations',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get nomComplet {
    return Intl.message('Full name', name: 'nomComplet', desc: '', args: []);
  }

  /// `D-0601`
  String get d0601 {
    return Intl.message('D-0601', name: 'd0601', desc: '', args: []);
  }

  /// `Local`
  String get local {
    return Intl.message('Local', name: 'local', desc: '', args: []);
  }

  /// `Phone`
  String get tlephone {
    return Intl.message('Phone', name: 'tlephone', desc: '', args: []);
  }

  /// `Subtotal`
  String get soustotal {
    return Intl.message('Subtotal', name: 'soustotal', desc: '', args: []);
  }

  /// `Payment`
  String get paiement {
    return Intl.message('Payment', name: 'paiement', desc: '', args: []);
  }

  /// `Success!`
  String get succs {
    return Intl.message('Success!', name: 'succs', desc: '', args: []);
  }

  /// `Thank You for Your Order!`
  String get thankYouForYourOrder {
    return Intl.message(
      'Thank You for Your Order!',
      name: 'thankYouForYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `Your delicious food is being prepared and will arrive soon.`
  String get yourDeliciousFoodIsBeingPreparedAndWillArriveSoon {
    return Intl.message(
      'Your delicious food is being prepared and will arrive soon.',
      name: 'yourDeliciousFoodIsBeingPreparedAndWillArriveSoon',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home`
  String get backToHome {
    return Intl.message('Back to Home', name: 'backToHome', desc: '', args: []);
  }

  /// `Vote for products!`
  String get votezPourDesProduits {
    return Intl.message(
      'Vote for products!',
      name: 'votezPourDesProduits',
      desc: '',
      args: [],
    );
  }

  /// `Share your opinion on our upcoming products!`
  String get partagezVotreAvisSurNosProchainsProduits {
    return Intl.message(
      'Share your opinion on our upcoming products!',
      name: 'partagezVotreAvisSurNosProchainsProduits',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get ajouter {
    return Intl.message('Add', name: 'ajouter', desc: '', args: []);
  }

  /// `product-`
  String get product {
    return Intl.message('product-', name: 'product', desc: '', args: []);
  }

  /// `Brand:`
  String get brand {
    return Intl.message('Brand:', name: 'brand', desc: '', args: []);
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message('Add to Cart', name: 'addToCart', desc: '', args: []);
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
