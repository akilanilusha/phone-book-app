import 'package:flutter/material.dart';
import 'package:sqliteapp/controller/db_controller.dart';
import 'package:sqliteapp/models/contact_model.dart';

class ContactProvider extends ChangeNotifier {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  TextEditingController get name => _name;
  TextEditingController get number => _number;

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  Future<void> addNewContact() async {
    await DbController.createNew(_name.text, _number.text);
    notifyListeners();
    clearInputs();
  }

  Future<List<Contact>> fetchContacts() async {
    _contacts = await DbController.getContacts();
    return _contacts;
  }

  void clearInputs() {
    _name.clear();
    _number.clear();
  }

  void setTextFields(Contact contact) {
    _name.text = contact.name;
    _number.text = contact.number;
    notifyListeners();
  }

  Future<void> startUpdate(int id) async {
    DbController.upDate(Contact(id: id, name: _name.text, number: _number.text))
        .then((value) => clearInputs());
    notifyListeners();
  }

  Future<void> deleteContact(int id) async {
    DbController.deleteContact(id);
    notifyListeners();
  }
}
