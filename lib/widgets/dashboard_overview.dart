import 'package:berichtverwaltung_flutter/main.dart';
import 'package:berichtverwaltung_flutter/models/user.dart';
import 'package:berichtverwaltung_flutter/services/calculation_service.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/widgets/flyout_nav.dart';
import 'package:flutter/material.dart';

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

    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Ausbildungsberichte'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "Hallo ${userData.name}",
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            homeCard(berichtNr),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text('Letzte Berichte'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    navigatorKey.currentState!.pushNamed('/alle');
                  },
                  child: const Text(
                    'Alle ansehen',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            last5list(),
          ],
        ),
      ),
    );
  }
}

Widget homeCard(int bericht) => Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: AssetImage('assets/study.jpg'),
          fit: BoxFit.cover,
          opacity: .8,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Berichte',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Diese Woche fällig:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          Text(
            'Ausbildungsbericht Nr. $bericht',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const SizedBox(),
              const Spacer(),
              TextButton(
                onPressed: () {
                  navigatorKey.currentState!.pushNamed('/alle');
                },
                child: const Text(
                  'Jetzt schreiben',
                ),
              ),
            ],
          ),
        ],
      ),
    );

Widget last5list() => SizedBox(
      height: 135,
      child: StreamBuilder(
        stream: FirestoreService().berichtStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length < 3) {
              return Container(
                height: 175,
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Zu wenige Berichte, fange an welche zu schreiben!',
                    ),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  DateTime dtStart = snapshot.data![index].datum_start.toDate();
                  DateTime dtEnd = snapshot.data![index].datum_end.toDate();
                  return Container(
                    width: 175,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Bericht ${snapshot.data![index].id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Abteilung ${snapshot.data![index].abteilung}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              '${dtStart.day}.${dtStart.month}.${dtStart.year} - ${dtEnd.day}.${dtEnd.month}.${dtEnd.year}',
                              softWrap: true,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(),
                              Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
