import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../models/report.dart';
import '../services/auth_service.dart';


class ModerationScreen extends StatefulWidget {
  const ModerationScreen({super.key});

  @override
  State<ModerationScreen> createState() => _ModerationScreenState();
}

class _ModerationScreenState extends State<ModerationScreen> {


  @override
  void dispose() {
    super.dispose();
  }


  // Le client HTTP — à déclarer une seule fois dans la classe
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api', // émulateur Android
  ));

  late Future<List<Report>> _reportsFuture;
  List<Report> _reports = [];



  @override
  void initState() {
    super.initState();
    _reportsFuture = _loadReports();
  }




  Future<List<Report>> _loadReports() async {
    final reports = await getReports();
    setState(() => _reports = reports);
    return reports;
  }

  Future<void> _onRefresh() async {
    final reports = await getReports();
    setState(() => _reports = reports);
  }

  Future<List<Report>> getReports() async {
    try {
      final token = await AuthService().getToken();
      final response = await _dio.get(
        '/moderation/reports',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // response.data est une List de Maps
      final List<dynamic> data = response.data;
      return data.map((json) => Report.fromJson(json)).toList();

    } on DioException catch (e) {
      throw Exception('Erreur réseau : ${e.message}');
    }
  }






  Future<void> _ignoreReport(String reportId) async {

    try {
      final token = await AuthService().getToken();
      await _dio.delete(
        '/moderation/reports/$reportId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signalement ignoré avec succès')),
      );

      setState(() {
        _reportsFuture = _loadReports();
      });


    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Une erreur est survenue, réessaie plus tard')));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2EDE1),
      appBar: AppBar(
        title: Text("Signalements", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: FutureBuilder<List<Report>>(
        future: _reportsFuture,
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
          final reports = snapshot.data!;

          if (reports.isEmpty) {
            return const Center(child: Text('Aucun signalement pour le moment.'));
          }

          return RefreshIndicator(
              onRefresh: _onRefresh,




            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _reports.length,
              itemBuilder: (context, index) {


              return
              Column(
                children: [
                  Text(reports[index].motif),

                  PostCard(
                    post: reports[index].post,
                    onSparkToggled: (post) {},
                  ),

                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Color(0xFFF2EDE1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            title: Text('ignorer le signalement'),
                            content: Text('Cette action retire le le signalement du post'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('annuler', style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _ignoreReport(reports[index].id);
                                },
                                child: Text('Supprimer le signalement', style: TextStyle(color: Colors.red)),
                              )
                            ],
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1),
                    ),
                    child: const Text('Supprimer le signalement', style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    )),
                  ),

                  Divider(
                    color: Colors.black,
                    thickness: 2,
                    height: 40,
                  )
                ],


              );

            },
          ));
        },
      ),



    );
  }
}