import 'package:berichtverwaltung_flutter/detail/detail_page.dart';
import 'package:berichtverwaltung_flutter/main.dart';
import 'package:berichtverwaltung_flutter/models/bericht.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/widgets/flyout_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AllPage extends StatelessWidget {
  const AllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Alle Berichte'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/add',
        ),
        child: const Icon(Icons.note_add_rounded),
      ),
      body: StreamBuilder(
        stream: FirestoreService().berichtStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BerichtList(berichte: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class BerichtList extends StatefulWidget {
  final List<Bericht> berichte;

  const BerichtList({super.key, required this.berichte});

  @override
  State<BerichtList> createState() => _BerichtListState();
}

class _BerichtListState extends State<BerichtList> {
  @override
  Widget build(BuildContext context) {
    final items = widget.berichte;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final startDate = DateTime.fromMillisecondsSinceEpoch(
            items[index].datum_start.millisecondsSinceEpoch);
        final endDate = DateTime.fromMillisecondsSinceEpoch(
            items[index].datum_end.millisecondsSinceEpoch);
        final String dateString =
            "${startDate.day}.${startDate.month}.${startDate.year} - ${endDate.day}.${endDate.month}.${endDate.year}";

        return Slidable(
          startActionPane: ActionPane(motion: const BehindMotion(), children: [
            SlidableAction(
              onPressed: (context) async {
                FirestoreService().deleteBericht(items[index].id);
              },
              icon: Icons.delete,
              autoClose: true,
              backgroundColor: Colors.red.shade400,
            ),
          ]),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {},
                icon: Icons.edit,
                autoClose: true,
                backgroundColor: Colors.indigo,
              ),
            ],
          ),
          child: ListTile(
            leading: const Icon(Icons.file_open_rounded, size: 30),
            title: Text(items[index].id.toString()),
            subtitle: Text(
              "${items[index].abteilung}   $dateString",
            ),
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => DetailPage(bericht: items[index]),
              ));
            },
          ),
        );
      },
    );
  }
}
