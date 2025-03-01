import 'package:flutter/cupertino.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  @override
  Widget build(BuildContext context) {
    return webBuildBody();
  }

  Widget webBuildBody() {
    return Text('Ceci est la page login web');
  }
}
