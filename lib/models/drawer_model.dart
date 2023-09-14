import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerModel {
  String? name;
  IconData? icon;
  bool? isExpanded;
  Widget? page;
  List<DrawerChildren>? children;

  DrawerModel({this.name, this.icon, this.children, this.isExpanded, this.page});

  DrawerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    isExpanded = json['isExpanded'];
    if (json['children'] != null) {
      children = <DrawerChildren>[];
      json['children'].forEach((v) {
        children!.add(DrawerChildren.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['isExpanded'] = this.isExpanded;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DrawerChildren {
  String? name;
  IconData? icon;
  Widget? page;

  DrawerChildren({this.name, this.icon, this.page});

  DrawerChildren.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}
