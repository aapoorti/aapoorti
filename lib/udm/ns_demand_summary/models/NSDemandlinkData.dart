class NSDemandlinkData {
  String? apiFor;
  String? count;
  String? status;
  String? message;
  List<NSlinkData>? data;

  NSDemandlinkData(
      {this.apiFor, this.count, this.status, this.message, this.data});

  NSDemandlinkData.fromJson(Map<String, dynamic> json) {
    apiFor = json['api_for'];
    count = json['count'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NSlinkData>[];
      json['data'].forEach((v) {
        data!.add(new NSlinkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_for'] = this.apiFor;
    data['count'] = this.count;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NSlinkData {
  String? dmdstatus;
  String? fileno;
  String? approverpost;
  String? demandref;
  String? authSeq;
  String? approvalstatus;
  String? itemdescription;
  String? previouspost;
  String? initiatedwithpost;
  String? currentlywithpost;
  String? dmdkey;
  String? dmdno;
  String? dmddate;
  String? indentorname;
  String? createdtime;
  String? currentlywith;
  String? demandstatus;
  String? dmdstatusval;
  String? demandestval;
  String? approvalvalue;
  String? username;
  String? useremail;
  String? purchageunit;
  String? pdf_path;

  NSlinkData(
      {this.dmdstatus,
        this.fileno,
        this.approverpost,
        this.demandref,
        this.authSeq,
        this.approvalstatus,
        this.itemdescription,
        this.previouspost,
        this.initiatedwithpost,
        this.currentlywithpost,
        this.dmdkey,
        this.dmdno,
        this.dmddate,
        this.indentorname,
        this.createdtime,
        this.currentlywith,
        this.demandstatus,
        this.dmdstatusval,
        this.demandestval,
        this.approvalvalue,
        this.username,
        this.useremail,
        this.purchageunit,
        this.pdf_path});

  NSlinkData.fromJson(Map<String, dynamic> json) {
    dmdstatus = json['dmdstatus'];
    fileno = json['fileno'];
    approverpost = json['approverpost'];
    demandref = json['demandref'];
    authSeq = json['auth_seq'];
    approvalstatus = json['approvalstatus'];
    itemdescription = json['itemdescription'];
    previouspost = json['previouspost'];
    initiatedwithpost = json['initiatedwithpost'];
    currentlywithpost = json['currentlywithpost'];
    dmdkey = json['dmdkey'];
    dmdno = json['dmdno'];
    dmddate = json['dmddate'];
    indentorname = json['indentorname'];
    createdtime = json['createdtime'];
    currentlywith = json['currentlywith'];
    demandstatus = json['demandstatus'];
    dmdstatusval = json['dmdstatusval'];
    demandestval = json['demandestval'];
    approvalvalue = json['approvalvalue'];
    username = json['username'];
    useremail = json['useremail'];
    purchageunit = json['purchageunit'];
    pdf_path = json['pdf_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dmdstatus'] = this.dmdstatus;
    data['fileno'] = this.fileno;
    data['approverpost'] = this.approverpost;
    data['demandref'] = this.demandref;
    data['auth_seq'] = this.authSeq;
    data['approvalstatus'] = this.approvalstatus;
    data['itemdescription'] = this.itemdescription;
    data['previouspost'] = this.previouspost;
    data['initiatedwithpost'] = this.initiatedwithpost;
    data['currentlywithpost'] = this.currentlywithpost;
    data['dmdkey'] = this.dmdkey;
    data['dmdno'] = this.dmdno;
    data['dmddate'] = this.dmddate;
    data['indentorname'] = this.indentorname;
    data['createdtime'] = this.createdtime;
    data['currentlywith'] = this.currentlywith;
    data['demandstatus'] = this.demandstatus;
    data['dmdstatusval'] = this.dmdstatusval;
    data['demandestval'] = this.demandestval;
    data['approvalvalue'] = this.approvalvalue;
    data['username'] = this.username;
    data['useremail'] = this.useremail;
    data['purchageunit'] = this.purchageunit;
    data['pdf_path'] = this.pdf_path;
    return data;
  }
}