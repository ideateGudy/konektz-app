import 'package:flutter/material.dart';
import 'package:konektz/core/theme.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text('Recent', style: Theme.of(context).textTheme.bodySmall),
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.all(5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRecentContact("John", context),
                _buildRecentContact("Jane", context),
                _buildRecentContact("Alice", context),
                _buildRecentContact("Bob", context),
                _buildRecentContact("Charlie", context),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: ListView(
                children: [
                  _buildMessageTile("John Doe", "Hey, how are you?", "2:30 PM"),
                  _buildMessageTile("Jane Smith", "Let's catch up later.", "1:15 PM"),
                  _buildMessageTile("Alice Johnson", "Can you send me the report?", "12:45 PM"),
                  _buildMessageTile("Bob Brown", "Had a great day!", "11:00 AM"),
                  _buildMessageTile("Charlie Davis", "See you tomorrow.", "10:30 AM"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(String name, String message, String time) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      leading: const CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010',
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message,
        style: const TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis),
      ),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey),
      ),

      onTap: () {
        // Implement message tap functionality here
      },
    );
  }

  Widget _buildRecentContact(String name, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010',
            ),
          ),
          const SizedBox(height: 5),
          Text(name, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
