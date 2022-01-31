// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_buddy/helpers/constants.dart';
import 'package:chat_buddy/models/user_model.dart';
import 'package:chat_buddy/screens/chat/select_chat.dart';
import 'package:chat_buddy/widgets/my_container.dart';
import 'package:flutter/material.dart';

class ChatUserScreen extends StatefulWidget {
  const ChatUserScreen({Key? key}) : super(key: key);

  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  String searchKey = '';

  bool resultData(List arr, int index, String _key) {
    print(UserModel.uid);

    if (arr[index]['Info']['uid'] == UserModel.uid) return false;

    String name = arr[index]['Info']['fullName'];

    name = name.toLowerCase();
    _key = _key.toLowerCase();

    if (name.contains(_key)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(
          backgroundColor: kLightBlueShadeColor,
          child: Icon(Icons.message, size: 26),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectChatScreen(),
              ),
            );
          },
        ),
      ),
      backgroundColor: kBlueShadeColor,
      appBar: AppBar(
        backgroundColor: kBlueShadeColor,
        title: Text(
          'ChatBuddy',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 150,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: Stack(
                children: [
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Colors.grey.shade700.withOpacity(0.3),
                      border: Border.all(
                          color: Colors.grey.shade700.withOpacity(0.15)),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 16,
                    ),
                    decoration: kTextFormFieldAuthDec.copyWith(
                      hintText: 'Search User',
                      prefixIcon: Icon(Icons.search, color: kGreenShadeColor),
                      prefixIconColor: Colors.red,
                      errorStyle: TextStyle(color: kGreenShadeColor),
                    ),
                    textInputAction: TextInputAction.done,
                    cursorColor: Colors.grey.shade200,
                    onChanged: (val) {
                      setState(() {
                        searchKey = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    MyContainer4(
                      name: 'text',
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__340.jpg',
                      lastMsg:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sin",
                    ),
                    MyContainer4(
                      name: 'text',
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__340.jpg',
                      lastMsg:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sin",
                    ),
                    MyContainer4(
                      name: 'text',
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__340.jpg',
                      lastMsg:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sin",
                    ),
                    MyContainer4(
                      name: 'text',
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__340.jpg',
                      lastMsg:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sin",
                    ),
                    MyContainer4(
                      name: 'text',
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__340.jpg',
                      lastMsg:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sin",
                    ),
                    MyContainer4(
                      name: 'text',
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__340.jpg',
                      lastMsg:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sin",
                    ),
                    MyContainer4(
                      name: 'text',
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__340.jpg',
                      lastMsg:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sin",
                    ),
                    MyContainer4(
                      name: 'text',
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__340.jpg',
                      lastMsg:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sin",
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
