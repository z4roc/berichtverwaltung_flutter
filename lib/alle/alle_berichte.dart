import 'package:berichtverwaltung_flutter/add/task_provider.dart';
import 'package:berichtverwaltung_flutter/detail/detail_page.dart';
import 'package:berichtverwaltung_flutter/main.dart';
import 'package:berichtverwaltung_flutter/models/bericht.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/widgets/flyout_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class AllPage extends StatefulWidget {
  const AllPage({super.key});

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  bool _isExtended = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Alle Berichte'),
        centerTitle: true,
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: _isExtended ? 100 : 56,
        child: FloatingActionButton.extended(
          label: _isExtended ? const Text("Neu") : const SizedBox(),
          isExtended: _isExtended,
          onPressed: () => Navigator.pushNamed(
            context,
            '/add',
          ),
          icon: const Icon(Icons.edit_outlined),
          //child: const Icon(Icons.note_add_rounded),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse ||
              notification.direction == ScrollDirection.forward) {
            setState(() {
              _isExtended = false;
            });
            return false;
          } else {
            return true;
          }
        },
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            setState(() {
              _isExtended = true;
            });
            return true;
          },
          child: StreamBuilder(
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
        ),
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
