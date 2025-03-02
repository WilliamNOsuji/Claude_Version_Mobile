import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:mobilelapincouvert/dto/vote.dart';
import '../../services/api_service.dart';
import '../generated/l10n.dart';
import 'package:intl/intl.dart';

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

  Future<void> _postVoteFor(int index) async {
    int suggestedProductId = suggestions[index].id;
    try {
      await ApiService().voteFor(suggestedProductId);
      await _fetchSuggestions();
    } catch (e) {
      print('Failed to post vote: $e');
    }
  }

  Future<void> _postVoteAgainst(int index) async {
    int suggestedProductId = suggestions[index].id;
    try {
      await ApiService().voteAgainst(suggestedProductId);
      await _fetchSuggestions();
    } catch (e) {
      print('Failed to post vote: $e');
    }
  }

  void _likeProduct(int index) async {
    final current = suggestions[index];
    // Determine the new vote status.
    final newVote = current.userVote == "For" ? null : "For";
    // Create a new instance with the updated vote.
    final updatedProduct = SuggestedProductDTO(
      id: current.id,
      name: current.name,
      photo: current.photo,
      finishDate: current.finishDate,
      userVote: newVote,
    );
    setState(() {
      suggestions[index] = updatedProduct;
    });
    try {
      await ApiService().voteFor(current.id);
    } catch (e) {
      print("Vote for failed: $e");
      // Optionally, revert the update here if the API call fails.
    }
  }

  void _dislikeProduct(int index) async {
    final current = suggestions[index];
    final newVote = current.userVote == "Against" ? null : "Against";
    final updatedProduct = SuggestedProductDTO(
      id: current.id,
      name: current.name,
      photo: current.photo,
      finishDate: current.finishDate,
      userVote: newVote,
    );
    setState(() {
      suggestions[index] = updatedProduct;
    });
    try {
      await ApiService().voteAgainst(current.id);
    } catch (e) {
      print("Vote against failed: $e");
      // Optionally, revert the update here if the API call fails.
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Vote",
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
                  // Product details & countdown
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
                  // Action buttons
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
    // Assign the timer first, then calculate the time left.
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
      return '$days jours, $hours heures, $minutes minutes, $seconds secondes';
    } else {
      return '$hours heures, $minutes minutes, $seconds secondes';
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
