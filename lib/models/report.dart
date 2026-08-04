import 'package:gudnuz/models/post.dart';

class Report {
  final String id;
  final Post post;
  final String motif;
  final String signalePar;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.post,
    required this.motif,
    required this.signalePar,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id:          json['id']          as String,
      post: Post.fromJson(json['post']),
      motif:          json['motif']          as String,
      signalePar:          json['signalePar']          as String,
      createdAt:   DateTime.parse('${json['createdAt']}Z').toLocal(),
    );
  }

}
