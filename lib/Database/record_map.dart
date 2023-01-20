// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

class RecordMap {
  var record_date;
  var record_type;
  var record_weight;
  var record_price;
  var record_fromWhom;
  var record_phoneNum;
  var record_remark;
  var record_image_list;
  var first_image;
  var video;
  var second_image;
  var checkZero;

  RecordMap(
    this.record_date,
    this.record_type,
    this.record_weight,
    this.record_price,
    this.record_fromWhom,
    this.record_phoneNum,
    this.record_remark,
    this.record_image_list,
    this.first_image,
    this.video,
    this.second_image,
    this.checkZero,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'record_date': record_date,
      "record_type": record_type,
      'record_weight': record_weight,
      'record_price': record_price,
      "record_fromWhom": record_fromWhom,
      'record_phoneNum': record_phoneNum,
      'record_remark': record_remark,
      "record_image_list": record_image_list,
      "first_image": first_image,
      "video": video,
      "second_image": second_image,
      "checkZero": checkZero,
    };
    return map;
  }

  RecordMap.fromMap(Map<String, dynamic> map) {
    record_date = map["record_date"];
    record_type = map["record_type"];
    record_weight = map["record_weight"];
    record_price = map["record_price"];
    record_fromWhom = map["record_fromWhom"];
    record_phoneNum = map["record_phoneNum"];
    record_remark = map["record_remark"];
    record_image_list = map["record_image_list"];
    first_image = map["first_image"];
    video = map["video"];
    second_image = map["second_image"];
    checkZero = map["checkZero"];
  }
}
