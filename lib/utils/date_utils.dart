String formatTimeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
  if (diff.inHours < 24) {
    final minutes = diff.inMinutes % 60;   // reste après avoir retiré les heures complètes
    if (minutes == 0) return 'Il y a ${diff.inHours}h';
    return 'Il y a ${diff.inHours}h et ${minutes}min';
  }
  return 'Il y a ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
}

