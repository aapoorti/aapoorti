class CrismmisDemandLPR {
  String? apiName;
  String? keyVer;
  String? status;
  String? dataCount;
  String? message;
  String? keyDefinition;
  String? instructions;
  List<LPRData>? data;

  CrismmisDemandLPR(
      {this.apiName,
        this.keyVer,
        this.status,
        this.dataCount,
        this.message,
        this.keyDefinition,
        this.instructions,
        this.data});

  CrismmisDemandLPR.fromJson(Map<String, dynamic> json) {
    apiName = json['api_Name'];
    keyVer = json['key_ver'];
    status = json['status'];
    dataCount = json['data_Count'];
    message = json['message'];
    keyDefinition = json['key_definition'];
    instructions = json['instructions'];
    if (json['data'] != null) {
      data = <LPRData>[];
      json['data'].forEach((v) {
        data!.add(new LPRData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_Name'] = this.apiName;
    data['key_ver'] = this.keyVer;
    data['status'] = this.status;
    data['data_Count'] = this.dataCount;
    data['message'] = this.message;
    data['key_definition'] = this.keyDefinition;
    data['instructions'] = this.instructions;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LPRData {
  String? id;
  String? key1;
  String? key2;
  String? key3;
  String? key4;
  String? key5;
  String? key6;
  String? key7;
  String? key8;
  String? key9;
  String? key10;
  String? key11;
  String? key12;
  String? key13;
  String? key14;
  String? key15;
  String? key16;
  String? key17;
  String? key18;
  String? key19;
  String? key20;

  LPRData(
      {this.id,
        this.key1,
        this.key2,
        this.key3,
        this.key4,
        this.key5,
        this.key6,
        this.key7,
        this.key8,
        this.key9,
        this.key10,
        this.key11,
        this.key12,
        this.key13,
        this.key14,
        this.key15,
        this.key16,
        this.key17,
        this.key18,
        this.key19,
        this.key20});

  LPRData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key1 = json['key1'];
    key2 = json['key2'];
    key3 = json['key3'];
    key4 = json['key4'];
    key5 = json['key5'];
    key6 = json['key6'];
    key7 = json['key7'];
    key8 = json['key8'];
    key9 = json['key9'];
    key10 = json['key10'];
    key11 = json['key11'];
    key12 = json['key12'];
    key13 = json['key13'];
    key14 = json['key14'];
    key15 = json['key15'];
    key16 = json['key16'];
    key17 = json['key17'];
    key18 = json['key18'];
    key19 = json['key19'];
    key20 = json['key20'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key1'] = this.key1;
    data['key2'] = this.key2;
    data['key3'] = this.key3;
    data['key4'] = this.key4;
    data['key5'] = this.key5;
    data['key6'] = this.key6;
    data['key7'] = this.key7;
    data['key8'] = this.key8;
    data['key9'] = this.key9;
    data['key10'] = this.key10;
    data['key11'] = this.key11;
    data['key12'] = this.key12;
    data['key13'] = this.key13;
    data['key14'] = this.key14;
    data['key15'] = this.key15;
    data['key16'] = this.key16;
    data['key17'] = this.key17;
    data['key18'] = this.key18;
    data['key19'] = this.key19;
    data['key20'] = this.key20;
    return data;
  }
}
