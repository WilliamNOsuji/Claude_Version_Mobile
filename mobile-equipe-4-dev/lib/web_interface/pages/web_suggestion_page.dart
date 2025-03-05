import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb checks if needed
import 'package:mobilelapincouvert/web_interface/widgets/drawerCart.dart';
import 'package:mobilelapincouvert/web_interface/widgets/footer.dart';

import '../../dto/auth.dart';
import '../../generated/l10n.dart';
import '../../models/colors.dart';
import '../../services/api_service.dart';
import '../../dto/vote.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/web_menu_drawer.dart';

class WebSuggestionPage extends StatefulWidget {
  const WebSuggestionPage({Key? key}) : super(key: key);

  @override
  State<WebSuggestionPage> createState() => _WebSuggestionPageState();
}

class _WebSuggestionPageState extends State<WebSuggestionPage> {
  List<SuggestedProductDTO> suggestions = [];
  bool _isLoading = true;
  ProfileDTO? profileDTO;
  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
    getProfile();

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
    final newVote = current.userVote == "For" ? null : "For";
    final updatedProduct = SuggestedProductDTO(
      id: current.id,
      name: current.name,
      photo: current.photo,
      finishDate: current.finishDate,
      userVote: newVote,
    );
    try {
      await ApiService().voteFor(current.id);
      setState(() {
        suggestions[index] = updatedProduct;
      });
    } catch (e) {
      print("Vote for failed: $e");
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
    try {
      await ApiService().voteAgainst(current.id);
      setState(() {
        suggestions[index] = updatedProduct;
      });
    } catch (e) {
      print("Vote against failed: $e");
    }
  }

  Future<void> getProfile() async {
    try{
      profileDTO = await ApiService().getProfileInfo();
    }catch (Exception){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: LeTiroir(),
      drawer: profileDTO != null ? WebMenuDrawer(profileDTO: profileDTO!) : null,
      appBar: WebCustomAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : suggestions.isEmpty
          ? Center(child: Text(S.of(context).webNoSuggestionsFound))
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    S.of(context).webSuggestionsTitle,
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: AppColors().green(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).webVoteTagline,
                    style: TextStyle(
                      fontSize: 26,
                      fontStyle: FontStyle.italic,
                      color: AppColors().green(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 70),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 932),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: suggestions.map((product) {
                          final index = suggestions.indexOf(product);
                          return SizedBox(
                            width: 300,
                            child: Card(
                              elevation: 8,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          product.photo ?? '',
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Container(
                                              height: 200,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    S.of(context).webImageNotAvailable,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.7)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Text(
                                              product.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat.yMMMMd('fr_CA').format(product.finishDate),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        WebCountdownTimer(finishDate: product.finishDate),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => _likeProduct(index),
                                          icon: Icon(
                                            Icons.thumb_up,
                                            color: product.userVote == "For" ? Colors.white : Colors.white70,
                                          ),
                                          label: Text(S.of(context).likeButton),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: product.userVote == "For" ? Colors.blue : Colors.white70,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () => _dislikeProduct(index),
                                          icon: Icon(
                                            Icons.thumb_down,
                                            color: product.userVote == "Against" ? Colors.white : Colors.white70,
                                          ),
                                          label: Text(S.of(context).dislikeButton),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: product.userVote == "Against" ? Colors.red : Colors.white70,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height : 50),
            WebFooter()
          ],
        ),
      ),
    );
  }
}

class WebCountdownTimer extends StatefulWidget {
  final DateTime finishDate;
  const WebCountdownTimer({Key? key, required this.finishDate})
      : super(key: key);

  @override
  State<WebCountdownTimer> createState() => _WebCountdownTimerState();
}

class _WebCountdownTimerState extends State<WebCountdownTimer> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

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
      return '$days ${S.of(context).countdownHours}, $hours ${S.of(context).countdownHours}, $minutes ${S.of(context).countdownMinutes}';
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
    final isLessThanADay = _timeLeft <= const Duration(days: 1);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: isLessThanADay
            ? Colors.redAccent.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatDuration(_timeLeft),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isLessThanADay ? Colors.redAccent : Colors.green,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
