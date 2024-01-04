import 'dart:async';

//import 'package:austin_feeds_me/model/austin_feeds_me_event.dart';
import 'package:my_pup_simple/tip/model/tip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipsRepository {
  static const tipsTableName = 'tips';

  static Future<List<Tip>> _getTipsFromFirestore() async {
    final ref =
        FirebaseFirestore.instance.collection(tipsTableName).withConverter(
              fromFirestore: Tip.fromFirestore,
              toFirestore: (Tip tip, _) => tip.toFirestore(),
            );

    final tipsQuery = await ref.where('terrible_twos', isEqualTo: true).get();

    List<Tip> list = List.empty();

    for (final docSnapshot in tipsQuery.docs) {
      print('${docSnapshot.id} => ${docSnapshot.data()}');
      list.add(docSnapshot.data());
    }

    return list;
  }
}
