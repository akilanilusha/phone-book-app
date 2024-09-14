import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:sqliteapp/controller/call_service.dart';
import 'package:sqliteapp/provide/contact_provide.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> colors = [
    Colors.amber,
    Colors.green,
    const Color.fromARGB(255, 255, 229, 220),
    const Color.fromARGB(255, 244, 137, 98),
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.yellow,
    Colors.lightBlue,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Phone Book",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: value.fetchContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something Went Wrong");
                }
                if (snapshot.hasData) {
                  final contacts = snapshot.data;
                  return ListView.builder(
                    itemCount: contacts!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey.shade300,
                        child: ListTile(
                          title: Text(
                            contacts[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(contacts[index].number),
                          leading: CircleAvatar(
                            backgroundColor:
                                colors[int.parse(index.toString()[0])],
                            child: Text(
                              contacts[index].name[0].toUpperCase(),
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  CallService()
                                      .startCall(contacts[index].number);
                                },
                                icon: const Icon(Icons.call),
                              ),
                              IconButton(
                                onPressed: () {
                                  value.setTextFields(contacts[index]);
                                  contactDetails(context, value,
                                      id: contacts[index].id, isUpdate: true);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  value.deleteContact(contacts[index].id);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          );
        },
      ),
      floatingActionButton: Consumer<ContactProvider>(
        builder: (context, value, child) {
          return FloatingActionButton(
            onPressed: () {
              contactDetails(context, value);
            },
            backgroundColor: Colors.green,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> contactDetails(BuildContext context, ContactProvider value,
      {bool isUpdate = false, int? id}) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(isUpdate ? "Update Contact" : "Add New Contact"),
          content: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: value.name,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Contact Name"),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: value.number,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Contact Number"),
                  ),
                ),
              ),
              FilledButton(
                style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromARGB(255, 0, 163, 41)),
                ),
                onPressed: () {
                  if (value.name.text.isNotEmpty &&
                      value.number.text.isNotEmpty) {
                    if (isUpdate) {
                      value.startUpdate(id!).then((value) {
                        Navigator.pop(context);
                      });
                    } else {
                      value.addNewContact().then((value) {
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    Logger().e("Please Insert Contact Details");
                  }
                },
                child: Text(!isUpdate ? "Save Contact" : "Update"),
              ),
            ],
          ),
        );
      },
    );
  }
}
