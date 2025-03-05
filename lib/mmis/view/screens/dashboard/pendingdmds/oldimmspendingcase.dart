import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/controllers/oldimms_controller.dart';
import 'package:flutter_app/mmis/models/oldimmsData.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Oldimmspendingcase extends StatefulWidget {
  const Oldimmspendingcase({super.key});

  @override
  State<Oldimmspendingcase> createState() => _OldimmspendingcaseState();
}

class _OldimmspendingcaseState extends State<Oldimmspendingcase> {

  final oldimmscontroller = Get.put<OldiMMsController>(OldiMMsController());
  final _textsearchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //oldimmscontroller.fetchOldimmsData(context);
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      oldimmscontroller.fetchOldimmsData(context);
    }
    else{
      oldimmscontroller.fetchOldimmsData(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Obx((){
          return oldimmscontroller.searchoption.value == true ? Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: TextField(
              cursorColor: Colors.indigo[300],
              controller: _textsearchController,
              autofocus: oldimmscontroller.searchoption.value,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5.0),
                  prefixIcon: Icon(Icons.search, color: Colors.indigo[300]),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.indigo[300]),
                    onPressed: () {
                      oldimmscontroller.changetoolbarUi(false);
                      _textsearchController.text = "";
                      oldimmscontroller.searchingOldimmsData(_textsearchController.text.trim(), context);
                    },
                  ),
                  focusColor: Colors.indigo[300],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.indigo.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.indigo.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.indigo.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Search",
                  border: InputBorder.none),
              onChanged: (query) {
                if(query.isNotEmpty) {
                  oldimmscontroller.searchingOldimmsData(query, context);
                } else {
                  oldimmscontroller.changetoolbarUi(false);
                  _textsearchController.text = "";
                }
              },
            ),
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white)),
              SizedBox(width: 10),
              Container(
                  height: Get.height * 0.10,
                  width: Get.width / 1.5,
                  child: Marquee(
                    text: " Pending Demands",
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 30.0,
                    velocity: 100.0,
                    style: TextStyle(fontSize: 18,color: Colors.white),
                    pauseAfterRound: Duration(seconds: 1),
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ))
            ],
          );
        }),
        backgroundColor: AapoortiConstants.primary,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          Obx((){
            return oldimmscontroller.searchoption.value == true ? SizedBox() : IconButton(onPressed: (){
              //FocusScope.of(context).requestFocus(_focusNode);
              oldimmscontroller.changetoolbarUi(true);
            }, icon: Icon(Icons.search, color: Colors.white));
          })
        ],
      ),
       body: Container(
           height: Get.height,
           width: Get.width,
           child: Obx((){
             if(oldimmscontroller.oldimmsState == OldimmsState.Busy){
               return SingleChildScrollView(
                 child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Shimmer.fromColors(
                           baseColor: Colors.grey[300]!,
                           highlightColor: Colors.grey[100]!,
                           child: ListView.builder(
                               itemCount: 4,
                               shrinkWrap: true,
                               padding: EdgeInsets.all(5),
                               itemBuilder: (context, index) {
                                 return Card(
                                   elevation: 8.0,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(4.0),
                                   ),
                                   child: SizedBox(height: Get.height * 0.45),
                                 );
                               }))
                     ]),
               );
             }
             else if(oldimmscontroller.oldimmsState == OldimmsState.Finished){
               return Container(
                   height: Get.height,
                   width: Get.width,
                   child: Padding(
                     padding: EdgeInsets.only(bottom: 0.0, left: 2.0, right: 2.0),
                     child: ListView.builder(
                       itemCount: oldimmscontroller.oldimmsData.length,
                       shrinkWrap: true,
                       //controller: listScrollController,
                       padding: EdgeInsets.zero,
                       itemBuilder: (context, index) {
                         return Padding(
                           padding: const EdgeInsets.only(bottom: 5),
                           child: DemandCard(
                             demandDetails: oldimmscontroller.oldimmsData[index],
                             demandNumber: index + 1,
                           ),
                         );
                       },
                     ),
                   )
               );
             }
             else if(oldimmscontroller.oldimmsState == OldimmsState.Error){
               return Center(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Container(
                       height: 120,
                       width: 120,
                       child: Lottie.asset('assets/json/no_data.json'),
                     ),
                     AnimatedTextKit(
                         isRepeatingAnimation: false,
                         animatedTexts: [
                           TyperAnimatedText(
                               "Data not found",
                               speed: Duration(milliseconds: 150),
                               textStyle: TextStyle(fontWeight: FontWeight.bold)),
                         ])
                   ],
                 ),
               );
             }
             else if(oldimmscontroller.oldimmsState == OldimmsState.NoData){
               return Center(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Container(
                       height: 120,
                       width: 120,
                       child: Lottie.asset('assets/json/no_data.json'),
                     ),
                     AnimatedTextKit(
                         isRepeatingAnimation: false,
                         animatedTexts: [
                           TyperAnimatedText(
                               "Data not found",
                               speed: Duration(milliseconds: 150),
                               textStyle: TextStyle(fontWeight: FontWeight.bold)),
                         ])
                   ],
                 ),
               );
             }
             else if(oldimmscontroller.oldimmsState == OldimmsState.FinishedwithError){
               return Center(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Container(
                       height: 120,
                       width: 120,
                       child: Lottie.asset('assets/json/no_data.json'),
                     ),
                     AnimatedTextKit(
                         isRepeatingAnimation: false,
                         animatedTexts: [
                           TyperAnimatedText(
                               "Data not found",
                               speed: Duration(milliseconds: 150),
                               textStyle: TextStyle(fontWeight: FontWeight.bold)),
                         ])
                   ],
                 ),
               );
             }
             return SizedBox();
           })
       ),
    );
  }

}



class DemandCard extends StatelessWidget {
  final OldImmsData demandDetails;
  final int demandNumber;

  const DemandCard({
    Key? key,
    required this.demandDetails,
    required this.demandNumber
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Demand No. & Date', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.0),
                RichText(
                  text: TextSpan(
                    text: '${demandDetails.key7}\n',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Dt.${demandDetails.key2}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      // TextSpan(
                      //   text: 'testing',
                      //   style: TextStyle(color: Colors.blue, fontSize: 16),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailItem(
              Icons.info,
              'Status',
              '${demandDetails.key4!}',
              subtitle: '',
              isBold: true,
              isBlueText: true,
            ),
            _buildDetailItem(
              Icons.person,
              'Received From',
              '${demandDetails.key6!}',
              subtitle: '',
              isBold: true,
              isBlueText: true,
            ),
            _buildDetailItem(
              Icons.description,
              'Consignee',
              "${demandDetails.key9!}",
            ),
            _buildDetailItem(
              Icons.currency_rupee,
              'Demand Value',
              'Rs.${demandDetails.key10!}/-',
              subtitle: '',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      IconData icon,
      String label,
      String value, {
        String? subtitle,
        bool isBold = false,
        bool isBlueText = false,
        bool isLast = false,
        VoidCallback? onStatusCodeTap,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF0073CF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF0073CF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if(subtitle != null) ...[
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: label == 'Status' ? onStatusCodeTap : null,
                    child: Row(
                      children: [
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: isBlueText ? const Color(0xFF0073CF) : Colors.grey[600],
                            fontSize: 14,
                            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        // if(label == 'Status') ...[
                        //   const SizedBox(width: 4),
                        //   Icon(
                        //     Icons.info_outline,
                        //     size: 14,
                        //     color: const Color(0xFF0073CF),
                        //   ),
                        // ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String removeLeadingDashes(String value) {
    if(value.startsWith('---')) {
      return value.replaceFirst('---', '');
    }
    return value;
  }
}
