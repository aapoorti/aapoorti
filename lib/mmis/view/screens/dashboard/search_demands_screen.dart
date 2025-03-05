import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/controllers/search_demand_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SearchDemandsScreen extends StatefulWidget {
  const SearchDemandsScreen({super.key});

  @override
  State<SearchDemandsScreen> createState() => _SearchDemandsScreenState();
}

class _SearchDemandsScreenState extends State<SearchDemandsScreen>
    with SingleTickerProviderStateMixin {

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 365));
  String selectedDepart = 'All';
  String deptCode = "-1";
  String selectedStatus = 'All';
  String statusCode = "-1";

  String? demandNo;
  bool isNewCRIS = true;

  final departKey = GlobalKey<DropdownSearchState>();
  final demandKey = GlobalKey<DropdownSearchState>();
  final TextEditingController _demandnumController = TextEditingController();

  final List<Map<String, dynamic>> statusOptions = [];

  final List<Map<String, dynamic>> newstatusOptions = [
    {"value": "-1", "label": "All"},
    {"value": "0", "label": "Initiated (Draft)"},
    {"value": "1", "label": "Under Fund Certification"},
    {"value": "2", "label": "Fund Certification granted"},
    {"value": "3", "label": "Forwarded for PAC Approval"},
    {"value": "4", "label": "PAC Approved"},
    {"value": "9", "label": "Under Technical Vetting"},
    {"value": "10", "label": "Technical Vetting done"},
    {"value": "7", "label": "Under Finance Concurrence"},
    {"value": "8", "label": "Finance Concurrence accorded"},
    {"value": "14", "label": "Under Purchase Review"},
    {"value": "15", "label": "Purchase Review Approved"},
    {"value": "11", "label": "Under Process"},
    {"value": "5", "label": "Under Approval"},
    {"value": "6", "label": "Approved & Forwarded to Purchase"},
    {"value": "13", "label": "Returned by Purchase Unit"},
    {"value": "12", "label": "Dropped"},
  ];

  final List<Map<String, dynamic>> oldstatusOptions = [
    {"value": "-1", "label": "All"},
    {"value": "0", "label": "Draft"},
    {"value": "3", "label": "Under Tech. Vetting"},
    {"value": "I", "label": "Tech. Vetted"},
    {"value": "1", "label": "Under Concurrence"},
    {"value": "F", "label": "Concurred"},
    {"value": "A", "label": "Approved"},
    {"value": "B", "label": "Returned Back"},
  ];

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final initialDate = isFromDate ? fromDate : toDate;
    final firstDate = isFromDate ? DateTime(2020) : fromDate;
    final lastDate = isFromDate ? toDate.isBefore(DateTime(2026)) ? toDate : DateTime(2026) : DateTime(2026);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme.copyWith(
      primary: Colors.blue.shade800,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.blue.shade800,
    );
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: colorScheme,
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade800,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        if (isFromDate) {
          fromDate = date;
          if (toDate.isBefore(fromDate)) {
            toDate = fromDate.add(const Duration(days: 1));
          }
        } else {
          toDate = date;
        }
      });
      Feedback.forTap(context);
    }
  }

  //final searchdmdController = Get.find<SearchDemandController>();
  final searchdmdController = Get.put(SearchDemandController());

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("search dmd screen initState called");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getInitData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void resetForm() {
      setState(() {
        fromDate = DateTime.now().subtract(const Duration(days: 366));
        toDate = DateTime.now();
        selectedDepart = 'All';
        deptCode = "-1";
        selectedStatus = 'All';
        statusCode = "-1";
        //_demandnumController.text = '';
        isNewCRIS = true;
      });
  }


  Future<void> getInitData() async {
    fromDate = DateTime.now().subtract(const Duration(days: 366));
    toDate = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    searchdmdController.fetchDepartment(context);
    statusOptions.addAll(newstatusOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Demands',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: AapoortiConstants.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.of(context).pop();
            //Feedback.forTap(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.of(context).pop();
              //Feedback.forTap(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please select demand type:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDemandTypeSelector(),
                      const SizedBox(height: 16),
                      const Text(
                        'Demand Date:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDateSelectors(),
                      const SizedBox(height: 16),
                      const Text(
                        'Department',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownSearch<String>(
                        key: departKey,
                        selectedItem: selectedDepart,
                        items: (filter, loadProps) => searchdmdController.departOptions.map((e) {return e.key2.toString().trim();
                        }).toList(),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            //labelText: 'Select Department',
                            hintText: '----Select----',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        onChanged: (String? value) {
                          final selectedOption = searchdmdController.departOptions.firstWhere((element) => element.key2 == value);
                          selectedDepart = value!;
                          deptCode = selectedOption.key1!;
                          //debugPrint("Selected Value: ${selectedOption.key1}");
                        },
                        popupProps: PopupProps.menu(
                            fit: FlexFit.loose,
                            showSearchBox: true,
                            constraints:
                                BoxConstraints(maxHeight: Get.height * 0.45)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Demand Status',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownSearch<String>(
                        key: demandKey,
                        selectedItem: selectedStatus,
                        items: (filter, infiniteScrollProps) => statusOptions.map((e) => e['label'] as String).toList(),
                        decoratorProps: DropDownDecoratorProps(decoration: InputDecoration(
                          //labelText: "Select Status",

                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          hintText: "Choose an option",
                          border: OutlineInputBorder(),
                        )),
                        onChanged: (String? value) {
                          final selectedOption = statusOptions.firstWhere((element) => element['label'] == value);
                          selectedStatus = value!;
                          statusCode = selectedOption['value'];
                          debugPrint("Selected Value: ${selectedOption['value']}");
                        },
                        popupProps: PopupProps.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            constraints: BoxConstraints(maxHeight: Get.height * 0.45)),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Demand No.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDemandNumberField(),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemandTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildDemandTypeButton(
            label: 'Old CRIS MMIS',
            isSelected: !isNewCRIS,
            onTap: () {
              setState(() {
                isNewCRIS = false;
              });
              ToastMessage.showSnackBar("Message", "Comming Soon!!", Colors.teal);
              Feedback.forTap(context);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDemandTypeButton(
            label: 'New CRIS MMIS',
            isSelected: isNewCRIS,
            onTap: () {
              setState(() {
                isNewCRIS = true;
              });
              Feedback.forTap(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDemandTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Hero(
      tag: 'demand_type_$label',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.blue.shade100,
          child: Ink(
            height: 50,
            decoration: BoxDecoration(
              color: isSelected
                  ? (label.contains('New')
                      ? Colors.blue.shade50
                      : Colors.grey[300])
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? (label.contains('New')
                        ? Colors.blue.shade400
                        : Colors.grey.shade400)
                    : Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? (label.contains('New')
                          ? Colors.blue.shade700
                          : Colors.grey.shade700)
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            label: 'From',
            date: fromDate,
            onTap: () => _selectDate(context, true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDateField(
            label: 'To',
            date: toDate,
            onTap: () => _selectDate(context, false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Hero(
      tag: 'date_${label}_${date.millisecondsSinceEpoch}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.blue.shade100,
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue.shade200,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formatDate(date),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.blue.shade800,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ListTile(
          dense: true,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: Icon(icon, color: Colors.blue.shade800, size: 20),
          title: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: AnimatedRotation(
                  turns: 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.arrow_drop_down, size: 20),
                ),
                hint: Text(label, style: const TextStyle(fontSize: 14)),
                style: const TextStyle(fontSize: 14, color: Colors.black),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
                menuMaxHeight: 300,
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemandNumberField() {
    return TextFormField(
      controller: _demandnumController,
      decoration: InputDecoration(
        hintText: 'Enter Demand No.',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue.shade50,
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(Icons.numbers, size: 18, color: Colors.blue.shade700),
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: (value) {
        setState(() {
          demandNo = value.isEmpty ? null : value;
        });
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          "Submit",
          Colors.blue.shade800,
          onPressed: () {
            if(_formKey.currentState?.validate() ?? false) {
              if(isNewCRIS && _demandnumController.text.length == 0){
                if(selectedStatus != "All" && selectedDepart != "All"){
                  Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', DateFormat('dd-MM-yyyy').format(fromDate), DateFormat('dd-MM-yyyy').format(toDate), deptCode, statusCode, "-1", '98', '05']);
                }
                else if(selectedStatus == "All" && selectedDepart == "All"){
                  Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', DateFormat('dd-MM-yyyy').format(fromDate), DateFormat('dd-MM-yyyy').format(toDate), "-99", "-99", "-1", '98', '05']);
                }
                else if(selectedStatus != "All" && selectedDepart == "All"){
                  Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', DateFormat('dd-MM-yyyy').format(fromDate), DateFormat('dd-MM-yyyy').format(toDate), "-99", statusCode, "-1", '98', '05']);
                }
                else if(selectedStatus == "All" && selectedDepart != "All"){
                  Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', DateFormat('dd-MM-yyyy').format(fromDate), DateFormat('dd-MM-yyyy').format(toDate), deptCode, "-99", "-1", '98', '05']);
                }
                else {
                  AapoortiUtilities.showInSnackBar(context, "Please select required fields");
                }
              }
              else if(!isNewCRIS && _demandnumController.text.length == 0){
                // if(fromDate != 'from' && toDate != 'to' && selectedstatus != "All" && selectedDepart != "All"){
                //   Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['O', fromDate, toDate, deptCode, statusCode, "-1", '98', '05']);
                // }
                // else if(fromDate != 'from' && toDate != 'to' && selectedstatus == "All" && selectedDepart == "All"){
                //   Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', fromDate, toDate, "-99", "-99", "-1", '98', '05']);
                // }
                // else{
                //   AapoortiUtilities.showInSnackBar(context, "Please select required fields");
                // }
                ToastMessage.showSnackBar("Message", "Comming Soon!!", Colors.teal);
              }
              else if(isNewCRIS && _demandnumController.text.length != 0){
                Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['N', "-1", "-1", "-1", "-1", _demandnumController.text.trim(), '98', '05']);
              }
              else if(!isNewCRIS && _demandnumController.text.length != 0 && DateFormat('dd-MM-yyyy').format(fromDate) != '' && DateFormat('dd-MM-yyyy').format(toDate) != ''){
                //Get.toNamed(Routes.searchDemandsDataScreen, arguments: ['O', "-1", "-1", "-1", "-1", _demandnumController.text.trim(), '98', '05']);
                ToastMessage.showSnackBar("Message", "Comming Soon!!", Colors.teal);
              }
            }
            Feedback.forTap(context);
          },
        ),
        // const SizedBox(height: 12),
        // _buildActionButton(
        //   "Reset",
        //   Colors.blue.shade400,
        //   onPressed: resetForm,
        //   isOutlined: true,
        // ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    Color color, {
    VoidCallback? onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOutlined ? Colors.white : color,
            foregroundColor: isOutlined ? color : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: isOutlined ? BorderSide(color: color, width: 1.5) : BorderSide.none,
            ),
            elevation: isOutlined ? 0 : 2,
          ),
          onPressed: onPressed,
          child: Text(text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isOutlined ? color : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSelectionContainer extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CustomSelectionContainer({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.grey,
          width: 2,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
