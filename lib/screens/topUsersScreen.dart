import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/top_user.dart';
import 'userProfileScreen.dart';
import '../services/api_service.dart';


class TopUsersScreen extends StatefulWidget {
  const TopUsersScreen({super.key});

  @override
  State<TopUsersScreen> createState() => _TopUsersScreenState();
}


class _TopUsersScreenState extends State<TopUsersScreen> {


  late Future<List<TopUser>> _usersFuture;


  @override
  void initState() {
    super.initState();
    _usersFuture = getUsers();
  }

  Future<void> _onRefresh() async {
    // Accolades obligatoires : avec "=>", la closure renverrait la Future (valeur de
    // l'affectation), et setState refuse une closure qui renvoie une Future
    setState(() {
      _usersFuture = getUsers();
    });
    await _usersFuture;
  }

  Future<List<TopUser>> getUsers() async {
    try {
      final response = await ApiService.dio.get(
        '/users/top',
      );

      // response.data est une List de Maps
      final List<dynamic> data = response.data;
      return data.map((json) => TopUser.fromJson(json)).toList();

    } on DioException catch (e) {
      throw Exception('Erreur réseau : ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2EDE1),
      appBar: AppBar(
        title: Text("Hall of Fame", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<TopUser>>(
        future: _usersFuture,
        builder: (context, snapshot) {

          // État 1 : en cours de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // État 2 : une erreur est survenue
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          // État 3 : les données sont là
          final users = snapshot.data!;

          if (users.isEmpty) {
            return const Center(child: Text('Aucun utilisateur pour le moment.'));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey, height: 1),
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 32,
                        child: Text('${index + 1}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      ),
                      CircleAvatar(
                        backgroundImage: user.displayAvatarUrl != null
                            ? NetworkImage(user.displayAvatarUrl!)
                            : AssetImage('assets/images/pp.jpg') as ImageProvider,
                      ),
                    ],
                  ),
                  title: Text(user.pseudo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('${user.sparksCount} Sparks'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserProfileScreen(userId: user.id)),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
