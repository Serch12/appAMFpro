class Notificacion {
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final String no_solicitud;
  final String nombre;
  final String division;
  final String club;
  final int nui;
  final String tramite;
  final String observaciones;
  final String tipo_solicitud;
  final String observaciones_solicitud;
  final String archivo_solicitud;
  final int id_sol;
  final int estatus;
  final DateTime fechaSol;
  Notificacion({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.no_solicitud,
    required this.nombre,
    required this.id_sol,
    required this.division,
    required this.club,
    required this.nui,
    required this.tramite,
    required this.observaciones,
    required this.tipo_solicitud,
    required this.observaciones_solicitud,
    required this.archivo_solicitud,
    required this.estatus,
    required this.fechaSol,
  });
}
