import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:translator/translator.dart';

class KText extends StatefulWidget {
  const KText({super.key, required this.text,required this.style, this.maxLines});

  final String text;
  final TextStyle style;
  final int? maxLines;

  @override
  State<KText> createState() => _KTextState();
}

class _KTextState extends State<KText> {

  GoogleTranslator translator = GoogleTranslator();

  Future<String> translateLanguage(String text, String code) async {
    Translation translation = await translator.translate(text, to: code);
    return translation.text;
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    Locale currentLocale = localizationDelegate.currentLocale;
    return FutureBuilder(
        future: translateLanguage(widget.text,currentLocale.languageCode),
        builder: (ctx, AsyncSnapshot snapshot){
          if(snapshot.hasError){
            return Text(
              widget.text,
              textAlign: TextAlign.center,
              maxLines: widget.maxLines ?? 1,
              style: widget.style,
            );
          }else if(snapshot.hasData){
            return Text(
                snapshot.data,
                overflow: TextOverflow.ellipsis,
                style: widget.style,
            );
          }
          return Text(
            widget.text,
            style: widget.style,
          );
        }
    );
  }
}