import 'package:berichtverwaltung_flutter/models/user.dart';
import 'package:berichtverwaltung_flutter/services/calculation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Overview extends StatefulWidget {
  final AppUser data;

  const Overview({super.key, required this.data});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    final userData = widget.data;

    final berichtNr = Calculations().getBerichtNr(
      DateTime.fromMillisecondsSinceEpoch(
        userData.ausbildungsbeginn.millisecondsSinceEpoch,
      ),
      DateTime.now(),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text("Hallo ${userData.name}"),
        const SizedBox(
          height: 30,
        ),
        Text(
          "Diese Woche musst du Bericht Nr.$berichtNr schreiben!",
        ),
      ],
    );
  }
}
