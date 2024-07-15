// To parse this JSON data, do
//
//     final afiliadosResponse = afiliadosResponseFromJson(jsonString);

import 'dart:convert';

class AfiliadosResponse {
  AfiliadosResponse({
    this.data,
    this.links,
    this.meta,
  });

  List<Afiliados?>? data;
  Links? links;
  Meta? meta;

  factory AfiliadosResponse.fromJson(String str) =>
      AfiliadosResponse.fromMap(json.decode(str));

  factory AfiliadosResponse.fromMap(Map<String, dynamic> json) =>
      AfiliadosResponse(
        data: json["data"] == null
            ? []
            : List<Afiliados?>.from(
                json["data"]!.map((x) => Afiliados.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );
}

class Afiliados {
  Afiliados({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.nacionalidad,
    this.nacimiento,
    this.mail,
    this.celular,
    this.sexo,
    this.nui,
    this.club,
    this.division,
    this.posicion,
  });

  int? id;
  String? nombre;
  String? apellidoPaterno;
  String? apellidoMaterno;
  Nacionalidad? nacionalidad;
  DateTime? nacimiento;
  String? mail;
  String? celular;
  Sexo? sexo;
  int? nui;
  String? club;
  String? division;
  String? posicion;

  factory Afiliados.fromRawJson(String str) =>
      Afiliados.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Afiliados.fromJson(Map<String, dynamic> json) => Afiliados(
        id: json["id"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        nacionalidad: nacionalidadValues.map[json["nacionalidad"]],
        nacimiento: DateTime.parse(json["nacimiento"]),
        mail: json["mail"],
        celular: json["celular"],
        sexo: sexoValues.map[json["sexo"]],
        nui: json["nui"],
        club: json["club"],
        division: json["division"],
        posicion: json["posicion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "nacionalidad": nacionalidadValues.reverse![nacionalidad],
        "nacimiento":
            "${nacimiento!.year.toString().padLeft(4, '0')}-${nacimiento!.month.toString().padLeft(2, '0')}-${nacimiento!.day.toString().padLeft(2, '0')}",
        "mail": mail,
        "celular": celular,
        "sexo": sexoValues.reverse![sexo],
        "nui": nui,
        "club": club,
        "division": division,
        "posicion": posicion,
      };
}

enum Nacionalidad { MXICO, MEXICANO }

final nacionalidadValues = EnumValues(
    {"Mexicano": Nacionalidad.MEXICANO, " México": Nacionalidad.MXICO});

enum Sexo { MASCULINO }

final sexoValues = EnumValues({"Masculino": Sexo.MASCULINO});

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String? first;
  String? last;
  dynamic prev;
  String? next;

  factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
