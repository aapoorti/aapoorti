import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiException.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/ChallanStatusDetails.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/leaseApiProvider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/custome_radio_button.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

import 'CustomRadioController.dart';

// class LeasePaymentStatus extends StatefulWidget {
//   static const routeName = "/lease-payment-status";
//
//   @override
//   State<LeasePaymentStatus> createState() => _LeasePaymentStatusState();
// }
//
// class _LeasePaymentStatusState extends State<LeasePaymentStatus> with SingleTickerProviderStateMixin{
//
//   final _formKey = GlobalKey<FormState>();
//   String? selectedValue = 'F1';
//   String _selectedType = 'SLR';
//   DateTime? _selectedDate;
//   final TextEditingController _trainController = TextEditingController();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//     pr = ProgressDialog(context);
//    _challanStatusProvider = Provider.of<ChallanStatusProvider>(context, listen: false);
//    _selectedDate = DateTime.now();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _trainController.dispose();
//     super.dispose();
//   }
//
//   String formatDate(DateTime date) {
//     return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
//   }
//

//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: AapoortiConstants.primary,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text(
//           'Parcel Payment',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//         // actions: [
//         //   IconButton(
//         //     icon: Icon(Icons.home_rounded, color: Colors.white),
//         //     onPressed: () {
//         //       Navigator.of(context, rootNavigator: true).pop();
//         //     },
//         //   ),
//         // ],
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Container(
//           color: Colors.grey[100],
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Container(
//                         padding: EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [Colors.white, Colors.blue.shade50],
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             buildAnimatedTextField(
//                               controller: _trainController,
//                               label: 'Train No.',
//                               icon: Icons.train_rounded,
//                               validator: (value) {
//                                 if (value?.isEmpty ?? true) {
//                                   return 'Please enter train number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 24),
//                             buildTypeSelection(),
//                             SizedBox(height: 24),
//                             buildDropdown(),
//                             SizedBox(height: 24),
//                             buildDatePicker(),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     buildSubmitButton(),
//                     SizedBox(height: 16),
//                     _buildResetButton(
//                       "Reset",
//                       Colors.blue.shade400,
//                       onPressed: resetForm,
//                       isOutlined: true,
//                     ),
//                     //buildResetButton(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void resetForm() {
//     _trainController.clear();
//     setState(() {
//       _selectedType = 'SLR';
//       selectedValue = 'F1';
//       _selectedDate = null;
//     });
//   }
//
//   Widget buildAnimatedTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(
//           color: Colors.blue.shade800,
//           fontWeight: FontWeight.w500,
//         ),
//         prefixIcon: Icon(icon, color: Colors.blue.shade800),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.blue.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.blue.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//       validator: validator,
//     );
//   }
//
//   Widget buildTypeSelection() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue.shade300),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: buildTypeButton('SLR'),
//           ),
//           Container(
//             width: 1,
//             height: 48,
//             color: Colors.blue.shade300,
//           ),
//           Expanded(
//             child: buildTypeButton('VP'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildResetButton(
//       String text,
//       Color color, {
//         VoidCallback? onPressed,
//         bool isOutlined = false,
//       }) {
//     return SizedBox(
//       width: double.infinity,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: isOutlined ? Colors.white : color,
//             foregroundColor: isOutlined ? color : Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: isOutlined ? BorderSide(color: color, width: 1.5) : BorderSide.none,
//             ),
//             elevation: isOutlined ? 0 : 2,
//           ),
//           onPressed: onPressed,
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: isOutlined ? color : Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTypeButton(String type) {
//     bool isSelected = _selectedType == type;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedType = type;
//           // Reset selected value when type changes
//           selectedValue = _selectedType == 'SLR' ? 'F1' : '1';
//         });
//       },
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.shade800 : Colors.transparent,
//           borderRadius: BorderRadius.horizontal(
//             left: type == 'SLR' ? Radius.circular(12) : Radius.zero,
//             right: type == 'VP' ? Radius.circular(12) : Radius.zero,
//           ),
//         ),
//         child: Text(
//           type,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.blue.shade800,
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildDropdown() {
//     // Define options based on selected type
//     List<String> options = _selectedType == 'SLR'
//         ? ['F1', 'F2', 'R1']
//         : ['1', '2', '3', '4', '5'];
//
//     return DropdownButtonFormField<String>(
//       value: selectedValue,
//       decoration: InputDecoration(
//         labelText: 'Value',
//         labelStyle: TextStyle(
//           color: Colors.blue.shade800,
//           fontWeight: FontWeight.w500,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       items: options.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//       onChanged: (newValue) {
//         setState(() {
//           selectedValue = newValue;
//         });
//       },
//     );
//   }
//
//   Widget buildDatePicker() {
//     return TextFormField(
//       readOnly: true,
//       decoration: InputDecoration(
//         labelText: 'Date',
//         labelStyle: TextStyle(
//           color: Colors.blue.shade800,
//           fontWeight: FontWeight.w500,
//         ),
//         prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.blue.shade800),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       controller: TextEditingController(
//         text: _selectedDate != null ? formatDate(_selectedDate!) : '',
//       ),
//       onTap: () async {
//         final DateTime? picked = await showDatePicker(
//           context: context,
//           initialDate: _selectedDate ?? DateTime.now(),
//           firstDate: DateTime(2000),
//           lastDate: DateTime(2100),
//           builder: (context, child) {
//             return Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: ColorScheme.light(
//                   primary: Colors.blue.shade800,
//                 ),
//               ),
//               child: child!,
//             );
//           },
//         );
//         if (picked != null) {
//           setState(() {
//             _selectedDate = picked;
//           });
//         }
//       },
//     );
//   }
//
//   Widget buildSubmitButton() {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         fixedSize: Size(MediaQuery.of(context).size.width, 50),
//         backgroundColor: Colors.blue.shade800,
//         padding: EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 4,
//       ),
//       onPressed: () {
//         validateAndSave();
//         // if (_formKey.currentState?.validate() ?? false) {
//         //   ScaffoldMessenger.of(context).showSnackBar(
//         //     SnackBar(
//         //       content: Text('Processing Payment...'),
//         //       backgroundColor: Colors.blue.shade800,
//         //       behavior: SnackBarBehavior.floating,
//         //       shape: RoundedRectangleBorder(
//         //         borderRadius: BorderRadius.circular(10),
//         //       ),
//         //     ),
//         //   );
//         // }
//       },
//       child: Text(
//         'Submit',
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   Widget buildResetButton() {
//     return TextButton(
//       style: TextButton.styleFrom(
//         padding: EdgeInsets.symmetric(vertical: 16),
//         backgroundColor: Colors.grey[300],
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       onPressed: () {
//         _trainController.clear();
//         setState(() {
//           _selectedType = 'SLR';
//           selectedValue = 'F1';
//           _selectedDate = null;
//         });
//       },
//       child: Text(
//         'Reset',
//         style: TextStyle(
//           fontSize: 16,
//           color: Colors.blue.shade800,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
//
// class LeasePaymentStatus extends StatefulWidget {
//   static const routeName = "/lease-payment-status";
//   @override
//   State<LeasePaymentStatus> createState() => _LeasePaymentStatusState();
// }
//
// class _LeasePaymentStatusState extends State<LeasePaymentStatus> {
//   var width, height, padding;
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _trainController = TextEditingController();
//   CustomRadioController typecustomRadioController = CustomRadioController(0);
//
//   TextEditingController _dateController = TextEditingController();
//   DateTime selectedDate = DateTime.now();
//   FocusNode dropDownFocusNode = FocusNode();
//   List<String> subTypeItems = ["F1", "F2", "R1"];
//   int dropDownValue = 0;
//   List<String> types = ["SLR", "VP"];
//
//   String? trainNo, type, subType, date;
//
//   ChallanStatusProvider? _challanStatusProvider;
//   ProgressDialog? pr;
//   @override
//   void initState() {
//     // TODO: implement initState
//     type = types[0];
//     pr = ProgressDialog(context);
//     _challanStatusProvider =
//         Provider.of<ChallanStatusProvider>(context, listen: false);
//     super.initState();
//   }
//
//   void validateAndSave() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       String temp = DateFormat("dd/MM/yyyy").format(selectedDate);
//       String input = "$trainNo~$type~$subType~$temp";
//
//       try {
//         await pr!.show();
//
//         await _challanStatusProvider!.getStatus(input);
//
//         await pr!.hide();
//         if (ChallanStatusProvider.apiStatus == ApiStatus.finished) {
//           Navigator.of(context).pushNamed(
//             ChallanStatusDetails.routename,
//             arguments: _challanStatusProvider!.challanStatus,
//           );
//         }
//         else if (ChallanStatusProvider.apiStatus == ApiStatus.none) {
//           Navigator.of(context).pushNamed("/nodata");
//         }
//       } on SocketException catch (_) {
//         await pr!.hide();
//         Future.delayed(
//             Duration.zero,
//             () => ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text("Internet Connectivity issue"),
//                     backgroundColor: Colors.red[300],
//                   ),
//                 ));
//       } on TimeoutException catch (_) {
//         await pr!.hide();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Internet Connectivity issue"),
//             backgroundColor: Colors.red[300],
//           ),
//         );
//       } on FormatException catch (_) {
//         await pr!.hide();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Errorneous response"),
//             backgroundColor: Colors.red[300],
//           ),
//         );
//       } on AapoortiException catch (_) {
//         await pr!.hide();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Service Not Available!"),
//             backgroundColor: Colors.red[300],
//           ),
//         );
//       } on Exception catch (_) {
//         await pr!.hide();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Unexpected Error!"),
//             backgroundColor: Colors.red[300],
//           ),
//         );
//       } catch (error) {
//         await pr!.hide();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Unexpected Error!"),
//             backgroundColor: Colors.red[300],
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     padding = MediaQuery.of(context).padding;
//
//     return Scaffold(
//       appBar: AppBar(
//           iconTheme: IconThemeData(color: Colors.white),
//           backgroundColor: AapoortiConstants.primary,
//           actions: [
//             IconButton(
//               alignment: Alignment.centerRight,
//               icon: Icon(
//                 Icons.home,
//               ),
//               onPressed: () {
//                 Navigator.of(context, rootNavigator: true).pop();
//               },
//             ),
//           ],
//           title: Text('Parcel Payment (Leasing)', style: TextStyle(color: Colors.white, fontSize: 20.0)),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: Column(children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       autofocus: false,
//                       keyboardType: TextInputType.number,
//                       maxLength: 5,
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
//                         counterText: "",
//                         icon: Icon(Icons.train, color: Colors.black),
//                         hintText: 'Enter Train no.',
//                         filled: true,
//                         labelText: 'Train No.',
//                         fillColor: Colors.white,
//                         hoverColor: Colors.cyan,
//                         labelStyle: TextStyle(color: Colors.cyan),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.cyan, width: 1.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.cyan, width: 1.0),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red, width: 1.0),
//                         ),
//                       ),
//                       onSaved: (value) {
//                         trainNo = value!;
//                       },
//                       validator: (value) {
//                         if (value?.isEmpty ?? false) {
//                           return 'Train no. is required';
//                         } else if (value?.length != 5) {
//                           return 'Train no. should be in 5 digit';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 15),
//               CustomRadioButton(
//                   customRadioController: typecustomRadioController,
//                   //label: "Type",
//                   values: types,
//                   onSaved: (value) {},
//                   onChanged: (value) {
//                     setState(() {
//                       dropDownValue = 0;
//                       subTypeItems = value == 0 ? ["F1", "F2", "R1"] : ["1", "2", "3", "4", "5"];
//                       type = types[value];
//                     });
//                     typecustomRadioController.removeFocus();
//                     FocusScope.of(context).requestFocus(dropDownFocusNode);
//                   }),
//               SizedBox(height: 15),
//               DropdownButtonFormField(
//                 focusNode: dropDownFocusNode,
//                 decoration: InputDecoration(
//                   icon: Icon(
//                     Icons.account_tree_sharp,
//                     color: Colors.black,
//                   ),
//                   fillColor: Colors.white,
//                   hoverColor: Colors.cyan,
//                   labelStyle: TextStyle(color: Colors.cyan),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.cyan, width: 1.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.cyan, width: 1.0),
//                   ),
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.red, width: 1.0),
//                   ),
//                   label: Text(
//                     "Value",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   filled: true,
//                 ),
//                 value: dropDownValue,
//                 items: List.generate(
//                   subTypeItems.length,
//                   (index) => DropdownMenuItem<int>(
//                     value: index,
//                     child: Text(subTypeItems[index]),
//                   ),
//                 ),
//                 onSaved: (value) {
//                   subType = subTypeItems[value as int];
//                 },
//                 onChanged: (value) {
//                   //setState(() {
//                   dropDownValue = value as int;
//                   //});
//                 },
//               ),
//               SizedBox(height: 15),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _dateController,
//                       autofocus: false,
//                       readOnly: true,
//                       onTap: () async {
//                         DateTime? picked = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.parse("2022-01-01"),
//                           lastDate: DateTime.now().add(Duration(days: 7)),
//                         );
//                         if (picked != null)
//                           setState(() {
//                             selectedDate = picked;
//                             _dateController.text =
//                                 DateFormat("dd/MMM/yyyy").format(selectedDate);
//                           });
//                       },
//                       decoration: InputDecoration(
//                         icon: Icon(
//                           Icons.calendar_month,
//                           color: Colors.black,
//                         ),
//                         hintText: 'Pick a date',
//                         filled: true,
//                         labelText: 'Date',
//                         fillColor: Colors.white,
//                         hoverColor: Colors.cyan,
//                         labelStyle: TextStyle(color: Colors.cyan),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.cyan, width: 1.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.cyan, width: 1.0),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red, width: 1.0),
//                         ),
//                       ),
//                       onSaved: (value) {
//                         date = _dateController.text;
//                       },
//                       validator: (value) {
//                         if (value?.isEmpty ?? false) {
//                           return 'Date is required';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.cyan[400],
//                         ),
//                         onPressed: () {
//                           validateAndSave();
//                           FocusScope.of(context).unfocus();
//                         },
//                         child: Text(
//                           "Submit",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                         ),
//                         onPressed: () {
//                           _formKey.currentState?.reset();
//                           _dateController.clear();
//                           typecustomRadioController.reset();
//                           setState(() {
//                             subTypeItems = ["F1", "F2", "R1"];
//                           });
//                         },
//                         child: Text(
//                           "Reset",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ]),
//           ),
//         ),
//       ),
//       // ),
//     );
//   }
// }
//
// class LeasePaymentStatus extends StatefulWidget {
//   static const routeName = "/lease-payment-status";
//   @override
//   State<LeasePaymentStatus> createState() => _LeasePaymentStatusState();
// }
//
// class _LeasePaymentStatusState extends State<LeasePaymentStatus> {
//   var width, height, padding;
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _singletrainController = TextEditingController();
//   TextEditingController _firsttrainController = TextEditingController();
//   TextEditingController _secondtrainController = TextEditingController();
//   CustomRadioController typecustomRadioController = CustomRadioController(0);
//
//   TextEditingController _dateController = TextEditingController();
//   DateTime selectedDate = DateTime.now();
//   FocusNode dropDownFocusNode = FocusNode();
//   List<String> subTypeItems = ["F1", "F2", "R1"];
//   int dropDownValue = 0;
//   List<String> types = ["SLR", "VP"];
//
//   String trainNo, type, subType, date;
//
//   ChallanStatusProvider _challanStatusProvider;
//   ProgressDialog pr;
//
//   @override
//   void initState() {
//     type = types[0];
//     pr = ProgressDialog(context);
//     _challanStatusProvider = Provider.of<ChallanStatusProvider>(context, listen: false);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _singletrainController.dispose();
//     _firsttrainController.dispose();
//     _secondtrainController.dispose();
//     //typecustomRadioController.dispose();
//     super.dispose();
//   }
//
//   void validateAndSave(String trainno) async {
//     if(_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       String selectDate = DateFormat("dd/MM/yyyy").format(selectedDate);
//       String input = _challanStatusProvider.getrdtraintype == "Multi" && _challanStatusProvider.gettraintype == "SLR" ? "$trainno~MSLR~$subType~$selectDate" : "$trainno~$type~$subType~$selectDate";
//
//       print("input $input");
//
//       try {
//         await pr.show();
//         await _challanStatusProvider.getStatus(input);
//         await pr.hide();
//         if(ChallanStatusProvider.apiStatus == ApiStatus.finished) {
//           Navigator.of(context).pushNamed(ChallanStatusDetails.routename, arguments: _challanStatusProvider.challanStatus);
//         }
//         else if (ChallanStatusProvider.apiStatus == ApiStatus.none) {
//           Navigator.of(context).pushNamed("/nodata");
//         }
//       } on SocketException catch (_) {
//         await pr.hide();
//         Future.delayed(Duration.zero, () => AapoortiUtilities.showInSnackBar(context, "Internet Connectivity issue!!"));
//       } on TimeoutException catch (_) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Internet Connectivity issue!!");
//       } on FormatException catch (_) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Something went wrong!!");
//       } on AapoortiException catch (_) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Service Not Available!!");
//       } on Exception catch (_) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Unexpected Error!!");
//       } catch (error) {
//         await pr.hide();
//         AapoortiUtilities.showInSnackBar(context, "Unexpected Error!!");
//       }
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     _challanStatusProvider.updateTrain("Single");
//     _challanStatusProvider.updatetraintype("SLR");
//     Navigator.of(context).pop(true);
//     return Future<bool>.value(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     padding = MediaQuery.of(context).padding;
//     return WillPopScope(
//         child: Scaffold(
//           appBar: AppBar(
//               iconTheme: IconThemeData(color: Colors.white),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(padding: EdgeInsets.only(left: 15.0)),
//                   Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Parcel Payment Details',
//                         style: TextStyle(color: Colors.white),
//                       )),
//                   // new Padding(padding: new EdgeInsets.only(right: 15.0)),
//                   Expanded(
//                       child: SizedBox(
//                     width: 2,
//                   )),
//                   IconButton(
//                     alignment: Alignment.centerRight,
//                     icon: Icon(
//                       Icons.home,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context, rootNavigator: true).pop();
//                     },
//                   ),
//                 ],
//               )),
//           body: Container(
//             height: height,
//             width: width,
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Consumer<ChallanStatusProvider>(
//                         builder: (context, provider, child) {
//                           if(provider.getrdtraintype == "Single" && provider.gettraintype == "VP") {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Train",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16)),
//                                 SizedBox(height: 5.0),
//                                 TextFormField(
//                                   controller: _singletrainController,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 5,
//                                   decoration: InputDecoration(
//                                     hintText: "Enter train no.",
//                                     counterText: "",
//                                     //suffixIcon: _singletrainController.text.length == 5 ? Container(height: 32, width: 32, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.green), child: Icon(Icons.check)) : SizedBox(child: Text("1"),),
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.cyan, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     disabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     focusColor: Colors.red[300],
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.red, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                   onSaved: (value) {
//                                     trainNo = value;
//                                   },
//                                   validator: (value) {
//                                     if(value.isEmpty ?? false) {
//                                       return 'Train no. is required';
//                                     } else if(value.length != 5) {
//                                       return 'Train no. should be in 5 digit';
//                                     }
//                                     return null;
//                                   },
//                                   onChanged: (value) {},
//                                 )
//                               ],
//                             );
//                           }
//                           else if (provider.getrdtraintype == "Single" && provider.gettraintype == "SLR") {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Train",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16)),
//                                 SizedBox(height: 5.0),
//                                 TextFormField(
//                                   controller: _singletrainController,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 5,
//                                   decoration: InputDecoration(
//                                     hintText: "Enter train no.",
//                                     counterText: "",
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.cyan, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     disabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     focusColor: Colors.red[300],
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.red, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                   onSaved: (value) {
//                                     trainNo = value;
//                                   },
//                                   validator: (value) {
//                                     if (value.isEmpty ?? false) {
//                                       return 'Train no. is required';
//                                     } else if (value.length != 5) {
//                                       return 'Train no. should be in 5 digit';
//                                     }
//                                     return null;
//                                   },
//                                   onChanged: (value) {},
//                                 )
//                               ],
//                             );
//                           }
//                           else if (provider.getrdtraintype == "Multi" && provider.gettraintype == "VP") {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Train",
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16)),
//                                 SizedBox(height: 5.0),
//                                 TextFormField(
//                                   controller: _singletrainController,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 5,
//                                   decoration: InputDecoration(
//                                     hintText: "Enter train no.",
//                                     counterText: "",
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.cyan, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     disabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                         color: Colors.grey,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.grey, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     focusColor: Colors.red[300],
//                                     focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           color: Colors.red, width: 1.0),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                   ),
//                                   onSaved: (value) {
//                                     trainNo = value;
//                                   },
//                                   validator: (value) {
//                                     if (value.isEmpty ?? false) {
//                                       return 'Train no. is required';
//                                     } else if (value.length != 5) {
//                                       return 'Train no. should be in 5 digit';
//                                     }
//                                     return null;
//                                   },
//                                   onChanged: (value) {},
//                                 )
//                               ],
//                             );
//                           }
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: [
//                                    Text("Train 1",
//                                        style: TextStyle(
//                                            color: Colors.black,
//                                            fontWeight: FontWeight.bold,
//                                            fontSize: 16)),
//                                    SizedBox(height: 5.0),
//                                    TextFormField(
//                                      controller: _firsttrainController,
//                                      keyboardType: TextInputType.number,
//                                      maxLength: 5,
//                                      decoration: InputDecoration(
//                                        hintText: "Enter first train no.",
//                                        counterText: "",
//                                        contentPadding: EdgeInsets.symmetric(
//                                            horizontal: 10, vertical: 5),
//                                        focusedBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                              color: Colors.cyan, width: 1.0),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        border: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                            color: Colors.grey,
//                                          ),
//                                          borderRadius: BorderRadius.circular(10),
//                                        ),
//                                        disabledBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                            color: Colors.grey,
//                                          ),
//                                          borderRadius: BorderRadius.circular(10),
//                                        ),
//                                        errorBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                              color: Colors.grey, width: 1.0),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        enabledBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                              color: Colors.grey, width: 1.0),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                        focusColor: Colors.red[300],
//                                        focusedErrorBorder: OutlineInputBorder(
//                                          borderSide: const BorderSide(
//                                              color: Colors.red, width: 1.0),
//                                          borderRadius: BorderRadius.circular(10.0),
//                                        ),
//                                      ),
//                                      validator: (value) {
//                                        if (value.isEmpty ?? false) {
//                                          return 'Train no. is required';
//                                        } else if (value.length != 5) {
//                                          return 'Train no. should be in 5 digit';
//                                        }
//                                        return null;
//                                      },
//                                      onChanged: (value) {},
//                                    ),
//                                  ],
//                               )),
//                               SizedBox(width: 10),
//                               Expanded(child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Train 2",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16)),
//                                   SizedBox(height: 5.0),
//                                   TextFormField(
//                                     controller: _secondtrainController,
//                                     keyboardType: TextInputType.number,
//                                     maxLength: 5,
//                                     decoration: InputDecoration(
//                                       hintText: "Enter second train no.",
//                                       counterText: "",
//                                       contentPadding: EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 5),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.cyan, width: 1.0),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       disabledBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.grey, width: 1.0),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.grey, width: 1.0),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       focusColor: Colors.red[300],
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.red, width: 1.0),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value.isEmpty ?? false) {
//                                         return 'Train no. is required';
//                                       } else if (value.length != 5) {
//                                         return 'Train no. should be in 5 digit';
//                                       }
//                                       return null;
//                                     },
//                                     onChanged: (value) {},
//                                   ),
//                                 ],
//                               ))
//                             ],
//                           );
//                         }),
//                     SizedBox(height: 20),
//                     CustomRadioButton(
//                         customRadioController: typecustomRadioController,
//                         values: _challanStatusProvider.types,
//                         onSaved: (value) {},
//                         onChanged: (value) {
//                           _challanStatusProvider.updatetraintype(value == 0 ? "SLR" : "VP");
//                           setState(() {
//                             dropDownValue = 0;
//                             subTypeItems = value == 0
//                                 ? ["F1", "F2", "R1"]
//                                 : ["1", "2", "3", "4", "5"];
//                             type = types[value];
//                           });
//                           typecustomRadioController.removeFocus();
//                           FocusScope.of(context).requestFocus(dropDownFocusNode);
//                         }),
//                     SizedBox(height: 20),
//                     Consumer<ChallanStatusProvider>(
//                         builder: (context, trainnum, child) {
//                           if (trainnum.gettraintype != "SLR") {
//                             return SizedBox();
//                           }
//                           return Row(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Radio<String>(
//                                     value: 'Single',
//                                     groupValue: trainnum.getrdtraintype,
//                                     onChanged: (value) {
//                                       trainnum.updateTrain(value);
//                                     },
//                                   ),
//                                   Text("Single Train",
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 16))
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Radio<String>(
//                                     value: 'Multi',
//                                     groupValue: trainnum.getrdtraintype,
//                                     onChanged: (value) {
//                                       trainnum.updateTrain(value);
//                                     },
//                                   ),
//                                   Text("Multi Train",
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 16))
//                                 ],
//                               ),
//                             ],
//                           );
//                         }),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField(
//                       focusNode: dropDownFocusNode,
//                       decoration: InputDecoration(
//                         label: Text(
//                           "Value",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         filled: true,
//                         contentPadding:
//                         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                               color: Colors.cyan, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: Colors.grey,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: Colors.grey,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                               color: Colors.grey, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(
//                               color: Colors.grey, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         focusColor: Colors.red[300],
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide:
//                           const BorderSide(color: Colors.red, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       // decoration: InputDecoration(
//                       //
//                       //   // icon: Icon(
//                       //   //   Icons.account_tree_sharp,
//                       //   //   color: Colors.black,
//                       //   // ),
//                       //   label: Text(
//                       //     "Value",
//                       //     style: TextStyle(
//                       //       fontSize: 16,
//                       //       fontWeight: FontWeight.w400,
//                       //     ),
//                       //   ),
//                       //   filled: true,
//                       // ),
//                       value: dropDownValue,
//                       items: List.generate(
//                         subTypeItems.length,
//                             (index) => DropdownMenuItem<int>(
//                           value: index,
//                           child: Text(subTypeItems[index]),
//                         ),
//                       ),
//                       onSaved: (value) {
//                         subType = subTypeItems[value];
//                       },
//                       onChanged: (value) {
//                         dropDownValue = value;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _dateController,
//                             readOnly: true,
//                             onTap: () async {
//                               DateTime picked = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime.parse("2022-01-01"),
//                                 lastDate:
//                                 DateTime.now().add(Duration(days: 7)),
//                               );
//                               if (picked != null)
//                                 setState(() {
//                                   selectedDate = picked;
//                                   _dateController.text =
//                                       DateFormat("dd/MMM/yyyy")
//                                           .format(selectedDate);
//                                 });
//                             },
//                             decoration: InputDecoration(
//                               suffixIcon: Icon(
//                                 Icons.calendar_month,
//                                 color: Colors.black,
//                               ),
//                               hintText: 'Pick a date',
//                               filled: true,
//                               labelText: 'Date',
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.cyan, width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                   color: Colors.grey,
//                                 ),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                   color: Colors.grey,
//                                 ),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.grey, width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.grey, width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               focusColor: Colors.red[300],
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Colors.red, width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                             onSaved: (value) {
//                               date = _dateController.text;
//                             },
//                             validator: (value) {
//                               if (value.isEmpty ?? false) {
//                                 return 'Date is required';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 25),
//                     Consumer<ChallanStatusProvider>(
//                         builder: (context, value, child) {
//                           return Container(
//                               width: width,
//                               padding: EdgeInsets.symmetric(horizontal: 5.0),
//                               height: 45,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   MaterialButton(
//                                       height: 45,
//                                       minWidth: width * 0.40,
//                                       child: Text(
//                                         "Submit",
//                                         style: TextStyle(
//                                             fontSize: 16, color: Colors.white),
//                                       ),
//                                       shape: BeveledRectangleBorder(
//                                           side: BorderSide(
//                                               width: 1.0,
//                                               color: Colors.grey.shade300)),
//                                       onPressed: () {
//                                         if (_challanStatusProvider
//                                             .getrdtraintype ==
//                                             "Single") {
//                                           validateAndSave(
//                                               _singletrainController.text.trim());
//                                         } else {
//                                           validateAndSave(
//                                               "${_firsttrainController.text.trim()}#${_secondtrainController.text.trim()}");
//                                         }
//                                         FocusScope.of(context).unfocus();
//                                       },
//                                       color: Colors.cyan,
//                                       textColor: Colors.white),
//                                   MaterialButton(
//                                       height: 45,
//                                       minWidth: width * 0.40,
//                                       child: Text(
//                                         "Reset",
//                                         style: TextStyle(
//                                             fontSize: 16, color: Colors.white),
//                                       ),
//                                       shape: BeveledRectangleBorder(
//                                           side: BorderSide(
//                                               width: 1.0,
//                                               color: Colors.grey.shade300)),
//                                       onPressed: () {
//                                         _formKey.currentState.reset();
//                                         _dateController.clear();
//                                         typecustomRadioController.reset();
//                                         _challanStatusProvider.updateTrain("Single");
//                                         _challanStatusProvider.updatetraintype("SLR");
//                                         setState(() {
//                                           subTypeItems = ["F1", "F2", "R1"];
//                                         });
//                                       },
//                                       color: Colors.red,
//                                       textColor: Colors.white),
//                                 ],
//                               ));
//                         }),
//                     // Row(
//                     //   children: [
//                     //     Expanded(
//                     //       child: ElevatedButton(
//                     //         onPressed: () {
//                     //           validateAndSave();
//                     //           FocusScope.of(context).unfocus();
//                     //         },
//                     //         child: Text(
//                     //           "Submit",
//                     //           style: TextStyle(fontSize: 16,  color: Colors.white),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     // SizedBox(height: 10),
//                     // Row(
//                     //   children: [
//                     //     Expanded(
//                     //       child: ElevatedButton(
//                     //         onPressed: () {
//                     //           _formKey.currentState.reset();
//                     //           _dateController.clear();
//                     //           typecustomRadioController.reset();
//                     //           setState(() {
//                     //             subTypeItems = ["F1", "F2", "R1"];
//                     //           });
//                     //         },
//                     //         child: Text(
//                     //           "Reset",
//                     //           style: TextStyle(fontSize: 16, color: Colors.white),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // ),
//         ),
//         onWillPop: _onWillPop);
//   }
// }
//LeasePaymentStatus
//LeasePaymentStatus
//  class LeasePaymentStatus extends StatefulWidget {
//    static const routeName = "/lease-payment-status";
//
//    @override
//    State<LeasePaymentStatus> createState() => _LeasePaymentStatusScreenState();
//  }
//
//  class _LeasePaymentStatusScreenState extends State<LeasePaymentStatus> with SingleTickerProviderStateMixin{
//
//    final _formKey = GlobalKey<FormState>();
//    String? selectedValue = 'F1';
//    String _selectedType = 'SLR';
//    DateTime? _selectedDate;
//    final TextEditingController _trainController = TextEditingController();
//    late AnimationController _animationController;
//    late Animation<double> _fadeAnimation;
//
//    @override
//    void initState() {
//      super.initState();
//      _animationController = AnimationController(
//        vsync: this,
//        duration: Duration(milliseconds: 800),
//      );
//      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//      );
//      _animationController.forward();
//    }
//
//    @override
//    void dispose() {
//      _animationController.dispose();
//      _trainController.dispose();
//      super.dispose();
//    }
//
//    String formatDate(DateTime date) {
//      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
//    }
//
//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        backgroundColor: Colors.grey[100],
//        appBar: AppBar(
//          backgroundColor: Colors.blue.shade800,
//          elevation: 0,
//          centerTitle: true,
//          title: Text(
//            'Parcel Payment',
//            style: TextStyle(
//              color: Colors.white,
//              fontWeight: FontWeight.w600,
//              fontSize: 22,
//            ),
//          ),
//          leading: IconButton(
//            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
//            onPressed: () => Navigator.pop(context),
//          ),
//          actions: [
//            IconButton(
//              icon: Icon(Icons.home_rounded, color: Colors.white),
//              onPressed: () {},
//            ),
//          ],
//        ),
//        body: FadeTransition(
//          opacity: _fadeAnimation,
//          child: Container(
//            color: Colors.grey[100],
//            child: SingleChildScrollView(
//              physics: BouncingScrollPhysics(),
//              child: Padding(
//                padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
//                child: Form(
//                  key: _formKey,
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: [
//                      Card(
//                        elevation: 8,
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(16),
//                        ),
//                        child: Container(
//                          padding: EdgeInsets.all(20),
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(16),
//                            gradient: LinearGradient(
//                              begin: Alignment.topLeft,
//                              end: Alignment.bottomRight,
//                              colors: [Colors.white, Colors.blue.shade50],
//                            ),
//                          ),
//                          child: Column(
//                            children: [
//                              buildAnimatedTextField(
//                                controller: _trainController,
//                                label: 'Train No.',
//                                icon: Icons.train_rounded,
//                                validator: (value) {
//                                  if (value?.isEmpty ?? true) {
//                                    return 'Please enter train number';
//                                  }
//                                  return null;
//                                },
//                              ),
//                              SizedBox(height: 24),
//                              buildTypeSelection(),
//                              SizedBox(height: 24),
//                              buildDropdown(),
//                              SizedBox(height: 24),
//                              buildDatePicker(),
//                            ],
//                          ),
//                        ),
//                      ),
//                      SizedBox(height: 32),
//                      buildSubmitButton(),
//                      SizedBox(height: 16),
//                      buildResetButton(),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ),
//      );
//    }
//
//    Widget buildAnimatedTextField({
//      required TextEditingController controller,
//      required String label,
//      required IconData icon,
//      required String? Function(String?)? validator,
//    }) {
//      return TextFormField(
//        controller: controller,
//        decoration: InputDecoration(
//          labelText: label,
//          labelStyle: TextStyle(
//            color: Colors.blue.shade800,
//            fontWeight: FontWeight.w500,
//          ),
//          prefixIcon: Icon(icon, color: Colors.blue.shade800),
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(12),
//            borderSide: BorderSide(color: Colors.blue.shade300),
//          ),
//          enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(12),
//            borderSide: BorderSide(color: Colors.blue.shade300),
//          ),
//          focusedBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(12),
//            borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
//          ),
//          filled: true,
//          fillColor: Colors.white,
//        ),
//        validator: validator,
//      );
//    }
//
//    Widget buildTypeSelection() {
//      return Container(
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(12),
//          border: Border.all(color: Colors.blue.shade300),
//        ),
//        child: Row(
//          children: [
//            Expanded(
//              child: buildTypeButton('SLR'),
//            ),
//            Container(
//              width: 1,
//              height: 48,
//              color: Colors.blue.shade300,
//            ),
//            Expanded(
//              child: buildTypeButton('VP'),
//            ),
//          ],
//        ),
//      );
//    }
//
//    Widget buildTypeButton(String type) {
//      bool isSelected = _selectedType == type;
//      return GestureDetector(
//        onTap: () {
//          setState(() {
//            _selectedType = type;
//            // Reset selected value when type changes
//            selectedValue = _selectedType == 'SLR' ? 'F1' : '1';
//          });
//        },
//        child: AnimatedContainer(
//          duration: Duration(milliseconds: 200),
//          padding: EdgeInsets.symmetric(vertical: 12),
//          decoration: BoxDecoration(
//            color: isSelected ? Colors.blue.shade800 : Colors.transparent,
//            borderRadius: BorderRadius.horizontal(
//              left: type == 'SLR' ? Radius.circular(12) : Radius.zero,
//              right: type == 'VP' ? Radius.circular(12) : Radius.zero,
//            ),
//          ),
//          child: Text(
//            type,
//            textAlign: TextAlign.center,
//            style: TextStyle(
//              color: isSelected ? Colors.white : Colors.blue.shade800,
//              fontWeight: FontWeight.w600,
//              fontSize: 16,
//            ),
//          ),
//        ),
//      );
//    }
//
//    Widget buildDropdown() {
//      // Define options based on selected type
//      List<String> options = _selectedType == 'SLR'
//          ? ['F1', 'F2', 'R1']
//          : ['1', '2', '3', '4', '5'];
//
//      return DropdownButtonFormField<String>(
//        value: selectedValue,
//        decoration: InputDecoration(
//          labelText: 'Value',
//          labelStyle: TextStyle(
//            color: Colors.blue.shade800,
//            fontWeight: FontWeight.w500,
//          ),
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(12),
//          ),
//        ),
//        items: options.map((String value) {
//          return DropdownMenuItem<String>(
//            value: value,
//            child: Text(value),
//          );
//        }).toList(),
//        onChanged: (newValue) {
//          setState(() {
//            selectedValue = newValue;
//          });
//        },
//      );
//    }
//
//    Widget buildDatePicker() {
//      return TextFormField(
//        readOnly: true,
//        decoration: InputDecoration(
//          labelText: 'Date',
//          labelStyle: TextStyle(
//            color: Colors.blue.shade800,
//            fontWeight: FontWeight.w500,
//          ),
//          prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.blue.shade800),
//          border: OutlineInputBorder(
//            borderRadius: BorderRadius.circular(12),
//          ),
//        ),
//        controller: TextEditingController(
//          text: _selectedDate != null ? formatDate(_selectedDate!) : '',
//        ),
//        onTap: () async {
//          final DateTime? picked = await showDatePicker(
//            context: context,
//            initialDate: _selectedDate ?? DateTime.now(),
//            firstDate: DateTime(2000),
//            lastDate: DateTime(2100),
//            builder: (context, child) {
//              return Theme(
//                data: Theme.of(context).copyWith(
//                  colorScheme: ColorScheme.light(
//                    primary: Colors.blue.shade800,
//                  ),
//                ),
//                child: child!,
//              );
//            },
//          );
//          if (picked != null) {
//            setState(() {
//              _selectedDate = picked;
//            });
//          }
//        },
//      );
//    }
//
//    Widget buildSubmitButton() {
//      return ElevatedButton(
//        style: ElevatedButton.styleFrom(
//          backgroundColor: Colors.blue.shade800,
//          padding: EdgeInsets.symmetric(vertical: 16),
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(12),
//          ),
//          elevation: 4,
//        ),
//        onPressed: () {
//          if (_formKey.currentState?.validate() ?? false) {
//            ScaffoldMessenger.of(context).showSnackBar(
//              SnackBar(
//                content: Text('Processing Payment...'),
//                backgroundColor: Colors.blue.shade800,
//                behavior: SnackBarBehavior.floating,
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(10),
//                ),
//              ),
//            );
//          }
//        },
//        child: Text(
//          'Submit',
//          style: TextStyle(
//            fontSize: 18,
//            fontWeight: FontWeight.w600,
//            color: Colors.white,
//          ),
//        ),
//      );
//    }
//
//    Widget buildResetButton() {
//      return TextButton(
//        style: TextButton.styleFrom(
//          padding: EdgeInsets.symmetric(vertical: 16),
//          backgroundColor: Colors.grey[300],
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(12),
//          ),
//        ),
//        onPressed: () {
//          _trainController.clear();
//          setState(() {
//            _selectedType = 'SLR';
//            selectedValue = 'F1';
//            _selectedDate = null;
//          });
//        },
//        child: Text(
//          'Reset',
//          style: TextStyle(
//            fontSize: 16,
//            color: Colors.blue.shade800,
//            fontWeight: FontWeight.w500,
//          ),
//        ),
//      );
//    }
//  }

class LeasePaymentStatus extends StatefulWidget {
  static const routeName = "/lease-payment-status";

  @override
  State<LeasePaymentStatus> createState() => _LeasePaymentStatusState();
}

class _LeasePaymentStatusState extends State<LeasePaymentStatus> {
  final TextEditingController _trainController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedValue = 'F1';
  String _selectedType = 'SLR';
  bool _isSLRSelected = true;
  ProgressDialog? pr;
  ChallanStatusProvider? _challanStatusProvider;

  List<String> options = [];

  List<String> slroptions = ["F1", "F2", "R1"];
  List<String> vpoptions = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    options.addAll(slroptions);
    pr = ProgressDialog(context);
    _challanStatusProvider = Provider.of<ChallanStatusProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _trainController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _trainController.clear();
      _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      _selectedValue = 'F1';
      _selectedType = 'SLR';
      _isSLRSelected = true;
      options.clear();
      options.addAll(slroptions);
    });
  }

  void validateAndSave(BuildContext context) async {
    String temp = _dateController.text;
    String input = "${_trainController.text.trim()}~$_selectedType~$_selectedValue~$temp";
    try {
      await pr!.show();
      await _challanStatusProvider!.getStatus(input);
      await pr!.hide();
      if(ChallanStatusProvider.apiStatus == ApiStatus.finished) {
        Navigator.of(context).pushNamed(
          ChallanStatusDetails.routename,
          arguments: _challanStatusProvider!.challanStatus,
        );
      }
      else if(ChallanStatusProvider.apiStatus == ApiStatus.none) {Navigator.of(context).pushNamed("/nodata");}
    }
    on SocketException catch (_) {
      await pr!.hide();
      Future.delayed(Duration.zero, () =>  AapoortiUtilities.showInSnackBar(context,"Internet Connectivity issue"));
    }
    on TimeoutException catch (_) {
      await pr!.hide();
      AapoortiUtilities.showInSnackBar(context,"Internet Connectivity issue");
    }
    on FormatException catch (_) {
      await pr!.hide();
      AapoortiUtilities.showInSnackBar(context, "Errorneous response");
    }
    on AapoortiException catch (_) {
      await pr!.hide();
      AapoortiUtilities.showInSnackBar(context, "Service Not Available!");
    }
    on Exception catch (_) {
      await pr!.hide();
      AapoortiUtilities.showInSnackBar(context, "Unexpected Error!");
    }
    catch (error) {
      await pr!.hide();
      AapoortiUtilities.showInSnackBar(context, "Unexpected Error!");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text(
          'Parcel Payments',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Train Number Field
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: TextField(
                  controller: _trainController,
                  decoration: const InputDecoration(
                    prefixIcon:
                        Icon(Icons.train, color: Color(0xFF1976D2), size: 20),
                    hintText: 'Train No.',
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // SLR/VP Toggle
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSLRSelected = true;
                            _selectedType = 'SLR';
                            // Reset selected value when type changes
                           _selectedValue = 'F1' ;
                           options.clear();
                           options.addAll(slroptions);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isSLRSelected
                                ? const Color(0xFF1976D2)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(7),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'SLR',
                              style: TextStyle(
                                color: _isSLRSelected
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _isSLRSelected = false;
                            _selectedType = 'VP';
                            _selectedValue = '1';
                            options.clear();
                            options.addAll(vpoptions);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_isSLRSelected ? const Color(0xFF1976D2) : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(7),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'VP',
                              style: TextStyle(
                                color: !_isSLRSelected
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Value Dropdown
              buildDropdown(),
              const SizedBox(height: 12),

              // Date Field
              Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today,
                        color: Color(0xFF1976D2), size: 20),
                    hintText: 'Date',
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2026),
                    );
                    if (picked != null) {
                      setState(() {
                        _dateController.text =
                            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              Container(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if(_trainController.text.isNotEmpty){
                      validateAndSave(context);
                      FocusScope.of(context).unfocus();
                    }
                    else{
                      AapoortiUtilities.showInSnackBar(context, "Please enter train number");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Reset Button
              Container(
                height: 45,
                child: OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue.shade300),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


   Widget buildDropdown() {
     // Define options based on selected type
     List<String> options = _selectedType == 'SLR'
         ? ['F1', 'F2', 'R1']
         : ['1', '2', '3', '4', '5'];

     return Container(
       height: 50,
       child: DropdownButtonFormField<String>(
         value: _selectedValue,
         decoration: InputDecoration(
           labelText: 'Value',
           labelStyle: TextStyle(
             color: AapoortiConstants.primary,
             fontWeight: FontWeight.w500,
           ),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(8),
           ),
         ),
         items: options.map((String value) {
           return DropdownMenuItem<String>(
             value: value,
             child: Text(value),
           );
         }).toList(),
         onChanged: (newValue) {
           setState(() {
             _selectedValue = newValue;
           });
         },
       ),
     );
   }
}
