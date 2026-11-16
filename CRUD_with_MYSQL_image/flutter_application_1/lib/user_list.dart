import 'package:flutter/material.dart';
import 'user_service.dart';
import 'user_model.dart';
import 'add_user_form.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = UserService.getUsers();
  }

  void _refreshUsers() {
    setState(() {
      _futureUsers = UserService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  leading: user.foto != null
                      ? Image.network(
                    'http://192.168.72.49/APIFlutter/${user.foto}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.person),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await UserService.deleteUser(user.id);
                      _refreshUsers();
                    },
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                    MaterialPageRoute(
                      builder: (context)=>AddUserForm(user: user),
                    )
                    ).then((_)=>_refreshUsers());
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
            MaterialPageRoute(builder: (context) => AddUserForm()),
            ).then((_) => _refreshUsers());
          },
          child: Icon(Icons.add),
      ),
    );
  }
}