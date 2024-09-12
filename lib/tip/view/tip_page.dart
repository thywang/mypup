import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_pup_simple/puppy_profile/data/puppy_preferences.dart';
import 'package:my_pup_simple/puppy_profile/model/puppy.dart';
import 'package:my_pup_simple/src/constants/app_colors.dart';
import 'package:my_pup_simple/src/constants/app_sizes.dart';
import 'package:my_pup_simple/tip/model/tip.dart';
import 'package:my_pup_simple/widgets/header.dart';
import 'package:url_launcher/url_launcher.dart';

class TipPage extends StatefulWidget {
  const TipPage({required this.name, required this.mainColor, super.key});
  final String name;
  final Color mainColor;

  @override
  State<TipPage> createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  // default values
  String collectionName = 'generalTips';
  Color tipColor = mainAppColor;
  late final Query<Tip> tips;
  late Puppy puppy;

  @override
  void initState() {
    super.initState();

    collectionName = '${widget.name.toLowerCase()}Tips';
    tipColor = widget.mainColor;
    puppy = PuppyPreferences.getMyPuppy();
    tips = FirebaseFirestore.instance
        .collection(collectionName)
        .withConverter<Tip>(
          fromFirestore: (snapshot, _) => Tip.fromFirestore(snapshot),
          toFirestore: (Tip tip, _) => tip.toFirestore(),
        )
        .where(PuppyPreferences.getMyPuppy().growthStage, isEqualTo: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tipColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          alignment: Alignment.centerLeft,
          onPressed: () {
            // Navigate back to the previous screen by popping the current route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 60,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: HeaderWidget(
                  text: '${widget.name} Tips',
                ),
              ),
            ),
            gapH24,
            Flexible(
              child: StreamBuilder(
                stream: tips.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading');
                  }

                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final tip = snapshot.data!.docs[index].data();
                      final hasVideo = tip.video != null;

                      if (tip.steps != null && tip.steps!.isNotEmpty) {
                        final steps = tip.steps!;

                        return ExpansionTile(
                          leading: hasVideo
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.smart_display,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => {
                                    _launchUniversalLinkIOS(tip.video!),
                                  },
                                )
                              : null,
                          backgroundColor: trainingSecondaryColor,
                          collapsedBackgroundColor: tipColor,
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.p16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.p16),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(
                              top: Sizes.p12,
                              bottom: Sizes.p12,
                            ),
                            child: Text(
                              tip.title,
                              style: TextStyle(
                                color: titleTextColorLight,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(
                              bottom: Sizes.p8,
                            ),
                            child: Text(
                              tip.description,
                              style: TextStyle(
                                color: titleTextColorLight,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          children: steps
                              .asMap()
                              .entries
                              .map(
                                (step) => ListTile(
                                  minVerticalPadding: Sizes.p12,
                                  leading: CircleAvatar(
                                    backgroundColor: tipColor,
                                    child: Text(
                                      '${step.key + 1}',
                                    ), // make 1-indexed
                                  ),
                                  title: Text(
                                    step.value,
                                    style: TextStyle(
                                      color: titleTextColorLight,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return ListTile(
                          leading: hasVideo
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.smart_display,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => {
                                    _launchUniversalLinkIOS(tip.video!),
                                  },
                                )
                              : null,
                          tileColor: tipColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.p16),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(
                              top: Sizes.p12,
                              bottom: Sizes.p12,
                            ),
                            child: Text(
                              tip.title,
                              style: TextStyle(
                                color: titleTextColorLight,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(
                              bottom: Sizes.p8,
                            ),
                            child: Text(
                              tip.description,
                              style: TextStyle(
                                color: titleTextColorLight,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) => gapH16,
                    itemCount: snapshot.data!.docs.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUniversalLinkIOS(String url) async {
    try {
      final nativeAppLaunchSucceeded = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (!nativeAppLaunchSucceeded) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.inAppBrowserView,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
