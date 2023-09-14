class MailModel {
  Delivery? delivery;
  Message? message;
  String? to;

  MailModel({this.delivery, this.message, this.to});

  MailModel.fromJson(Map<String, dynamic> json) {
    delivery = json['delivery'] != null
        ? new Delivery.fromJson(json['delivery'])
        : null;
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.delivery != null) {
      data['delivery'] = this.delivery!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['to'] = this.to;
    return data;
  }
}

class Delivery {
  int? attempts;
  String? endTime;
  String? error;
  String? leaseExpireTime;
  String? startTime;
  String? state;
  Info? info;

  Delivery(
      {this.attempts,
        this.endTime,
        this.error,
        this.leaseExpireTime,
        this.startTime,
        this.state,
        this.info});

  Delivery.fromJson(Map<String, dynamic> json) {
    attempts = json['attempts'];
    endTime = json['endTime'];
    error = json['error'];
    leaseExpireTime = json['leaseExpireTime'];
    startTime = json['startTime'];
    state = json['state'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attempts'] = this.attempts;
    data['endTime'] = this.endTime;
    data['error'] = this.error;
    data['leaseExpireTime'] = this.leaseExpireTime;
    data['startTime'] = this.startTime;
    data['state'] = this.state;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class Info {
  List<String>? accepted;
  String? messageId;
  List<String>? pending;
  List<String>? rejected;
  String? response;

  Info(
      {this.accepted,
        this.messageId,
        this.pending,
        this.rejected,
        this.response});

  Info.fromJson(Map<String, dynamic> json) {
    if (json['accepted'] != null) {
      accepted = <String>[];
      json['accepted'].forEach((v) {
        accepted!.add(v);
      });
    }
    messageId = json['messageId'];
    if (json['pending'] != null) {
      pending = <String>[];
      json['pending'].forEach((v) {
        pending!.add(v);
      });
    }
    if (json['rejected'] != null) {
      rejected = <String>[];
      json['rejected'].forEach((v) {
        rejected!.add(v);
      });
    }
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accepted != null) {
      data['accepted'] = this.accepted!.map((v) => v).toList();
    }
    data['messageId'] = this.messageId;
    if (this.pending != null) {
      data['pending'] = this.pending!.map((v) => v).toList();
    }
    if (this.rejected != null) {
      data['rejected'] = this.rejected!.map((v) => v).toList();
    }
    data['response'] = this.response;
    return data;
  }
}

class Message {
  String? html;
  String? subject;
  String? text;

  Message({this.html, this.subject, this.text});

  Message.fromJson(Map<String, dynamic> json) {
    html = json['html'];
    subject = json['subject'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['html'] = this.html;
    data['subject'] = this.subject;
    data['text'] = this.text;
    return data;
  }
}
