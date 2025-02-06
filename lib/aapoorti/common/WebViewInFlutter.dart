import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewInFlutter extends StatefulWidget {
  final String? url1;

  WebViewInFlutter({
    this.url1,
  });

  @override
  WebViewInFlutterState createState() => WebViewInFlutterState(this.url1);
}

class WebViewInFlutterState extends State<WebViewInFlutter> {
  String? Corri_url;
  String? yyyy, mm, dd;
  late final WebViewController _controller;
  ProgressDialog? pr;

  WebViewInFlutterState(String? Corri_url) {
    this.Corri_url = Corri_url;
    debugPrint("Pdf path url====" + Corri_url!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            pr!.show();
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            pr!.hide();
          },
          onHttpError: (HttpResponseError error) {
            AapoortiUtilities.showInSnackBar(context, "Something wrong, please try later.");
            pr!.hide();
          },
          onWebResourceError: (WebResourceError error) {
            AapoortiUtilities.showInSnackBar(context, "Something wrong, please try later.");
            pr!.hide();
          },
          onNavigationRequest: (NavigationRequest request) {
            if(request.url.toLowerCase().contains('https://www.ireps.gov.in')) {
              IRUDMConstants.launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(Corri_url!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        //automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan[400],
        title: Text("IREPS", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
