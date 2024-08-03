import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
    String brokenPart;
    List<String> stepsToFix;

    Response({
        required this.brokenPart,
        required this.stepsToFix,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        brokenPart: json["broken_part"],
        stepsToFix: List<String>.from(json["steps_to_fix"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "broken_part": brokenPart,
        "steps_to_fix": List<dynamic>.from(stepsToFix.map((x) => x)),
    };
}
