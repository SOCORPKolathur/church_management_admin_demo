import 'package:church_management_admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfx/pdfx.dart';

class SimplePage extends StatefulWidget {
  const SimplePage({Key? key}) : super(key: key);

  @override
  State<SimplePage> createState() => _SimplePageState();
}

class _SimplePageState extends State<SimplePage> {
  static const int _initialPage = 0;
  bool _isSampleDoc = true;
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/termsandconditions.pdf'),
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants().primaryAppColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Terms And Conditions',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.navigate_before),
          //   onPressed: () {
          //     _pdfController.previousPage(
          //       curve: Curves.ease,
          //       duration: const Duration(milliseconds: 100),
          //     );
          //   },
          // ),
          // PdfPageNumber(
          //   controller: _pdfController,
          //   builder: (_, loadingState, page, pagesCount) => Container(
          //     alignment: Alignment.center,
          //     child: Text(
          //       '$page/${pagesCount ?? 0}',
          //       style: const TextStyle(fontSize: 22),
          //     ),
          //   ),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.navigate_next),
          //   onPressed: () {
          //     _pdfController.nextPage(
          //       curve: Curves.ease,
          //       duration: const Duration(milliseconds: 100),
          //     );
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(Icons.refresh),
          //   onPressed: () {
          //     if (_isSampleDoc) {
          //       _pdfController.loadDocument(
          //           PdfDocument.openAsset('termsandconditions.pdf'));
          //     } else {
          //       _pdfController
          //           .loadDocument(PdfDocument.openAsset('termsandconditions.pdf'));
          //     }
          //     _isSampleDoc = !_isSampleDoc;
          //   },
          // ),
        ],
      ),
      body: SafeArea(
        child: PdfView(
          builders: PdfViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
            pageLoaderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
            pageBuilder: _pageBuilder,
          ),
          controller: _pdfController,
          scrollDirection: Axis.vertical,
        ),
      ),
      // body: ListView.builder(
      //   itemCount: _pdfController.pagesCount,
      //   itemBuilder: (ctx, i){
      //     return Container(
      //
      //     );
      //   },
      // ),
    );
  }

  PhotoViewGalleryPageOptions _pageBuilder(
      BuildContext context,
      Future<PdfPageImage> pageImage,
      int index,
      PdfDocument document,
      ) {
    return PhotoViewGalleryPageOptions(
      imageProvider: PdfPageImageProvider(
        pageImage,
        index,
        document.id,
      ),
      scaleStateController: PhotoViewScaleStateController(),
      filterQuality: FilterQuality.high,
      basePosition: Alignment.centerLeft,
      // minScale: PhotoViewComputedScale.contained * 1.3,
      // maxScale: PhotoViewComputedScale.contained * 2,
      initialScale: PhotoViewComputedScale.contained * 1.2,
      tightMode: true,
      heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
    );
  }
}