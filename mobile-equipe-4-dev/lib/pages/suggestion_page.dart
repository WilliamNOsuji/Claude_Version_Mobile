import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:mobilelapincouvert/dto/vote.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_suggestion_page.dart';
import '../../services/api_service.dart';
import '../generated/l10n.dart';
import 'package:intl/intl.dart';

import '../web_interface/pages/web_home_page.dart';
import '../widgets/custom_app_bar.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  List<SuggestedProductDTO> suggestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
  }

  Future<void> _fetchSuggestions() async {
    try {
      final data = await ApiService().getSuggestedProducts();
      setState(() {
        suggestions = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load suggestions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _likeProduct(int index) async {
    final current = suggestions[index];
    current.userVote = current.userVote == "For" ? null : "For";
    try {
      await ApiService().voteFor(current.id);
      setState(() {});
    } catch (e) {
      print("Vote for failed: $e");

    }
  }

  void _dislikeProduct(int index) async {
    final current = suggestions[index];
    current.userVote = current.userVote == "Against" ? null : "Against";
    try {
      await ApiService().voteAgainst(current.id);
      setState(() {});
    } catch (e) {
      print("Vote against failed: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebSuggestionPage(): Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).voteAppBarTitle,
        centerTitle: true,
        backgroundColor: Colors.white,
        backPage: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : suggestions.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/pas_de_suggestions.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              Text(
                S.of(context).noSuggestedProducts,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final product = suggestions[index];
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.photo!,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat.yMMMMd('fr_CA')
                              .format(product.finishDate),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CountdownTimer(finishDate: product.finishDate),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            color: product.userVote == "For" ? Colors.blue : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () => _likeProduct(index),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                            color: product.userVote == "Against" ? Colors.red : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () => _dislikeProduct(index),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime finishDate;
  const CountdownTimer({Key? key, required this.finishDate}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _timeLeft = Duration();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
    _calculateTimeLeft();
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    setState(() {
      _timeLeft = widget.finishDate.difference(now);
      if (_timeLeft.isNegative) {
        _timeLeft = Duration.zero;
        _timer?.cancel();
      }
    });
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (days > 0) {
      return '$days ${S.of(context).countdownDays}, $hours ${S.of(context).countdownHours}, $minutes ${S.of(context).countdownMinutes}';
    } else {
      return '$hours ${S.of(context).countdownHours}, $minutes ${S.of(context).countdownMinutes}, $seconds ${S.of(context).countdownSeconds}';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = _timeLeft <= Duration(days: 1) ? Colors.redAccent : Colors.green;
    return Text(
      _formatDuration(_timeLeft),
      style: TextStyle(
        fontSize: 16,
        color: textColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}
