import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:wasm';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart' as crypto;
///
///  加入依赖库【必须】
///
///
///      fluttertoast: ^3.1.3
///      flutter_swiper: ^1.0.6
///      cookie_jar: ^1.0.0
///      path_provider: ^0.5.0+1
///      url_launcher: 5.4.1
///
///      mqtt_client: ^8.0.0
///
///      # The following adds the Cupertino Icons font to your application.
///      # Use with the CupertinoIcons class for iOS style icons.
///      cupertino_icons: ^0.1.2
///      json_annotation: ^2.0.0
///      shared_preferences: "^0.4.2"
///      #加解密基础库
///      pointycastle: 1.0.0
///      #PEM证书解码
///      asn1lib: 0.5.3
///      dio_cookie_manager: ^1.0.0
///      #dio_cookie_manager: ^3.0.0
///      #dio_http_cache: ^0.2.6
///
///      dio: 3.0.10
///      # https://github.com/a14n/dart-decimal
///      decimal: ">=0.3.1 <3.0.0"
///      # https://github.com/dart-lang/crypto
///      crypto: ">=2.0.6 <4.0.0"
///      # https://github.com/dart-lang/convert
///      convert: ">=1.0.0 <4.0.0"
///
///
///
///      可选-------------------------------------------------------
///     上啦刷新
///     简单下拉刷新上拉加载 https://github.com/xuelongqy/flutter_easyrefresh
///     flutter_easyrefresh: ^2.1.0
///
///
///     webView框架
///     WebView插件 https://github.com/flutter/plugins/tree/master/packages/webview_flutter
///     webview_flutter: 0.3.19+9
///
///     键盘监听
///     键盘监听 https://github.com/diegoveloper/flutter_keyboard_actions/
///     keyboard_actions: ^3.2.0
///
///     图片加载
///     图片加载库 https://github.com/renefloor/flutter_cached_network_image
///     cached_network_image: ^2.0.0
///
///     Loading指示器
///     加载Loading（指示器） https://github.com/jogboms/flutter_spinkit
///     flutter_spinkit: "^4.1.2"
///
///     列表悬浮图
///     列表悬浮头 https://github.com/fluttercommunity/flutter_sticky_headers
///     sticky_headers: ^0.1.8+1
///
///     Flutter轮播插件
///     # https://github.com/best-flutter/flutter_swiper
///     flutter_swiper: ^1.1.6
///

///     import 'package:pointycastle/pointycastle.dart';
///
///     更多
///     https://www.jianshu.com/p/67cda9aba038
///
///

class UUtils {
  /// 十六进制颜色，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  static Color getColor(int hex, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0, alpha);
  }


  static String getImagePath(String str){

    return "img/$str.png";

  }
  //滑动组件
  static Widget scrollViewIOS2Android(List<Widget> children) {
    return CustomScrollView(
      slivers: <Widget>[
        new SliverList(delegate: SliverChildListDelegate(children))
      ],
    );
  }

  //跳转新页面并且销毁当前页面
  static void startActivityFinish(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
      return widget;
    }), (h) => h == null);
  }

  //销毁当前页面
  static void finish(BuildContext context){
    Navigator.of(context).pop(1);
  }
  static launchUrl(String url,Function function) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      function();
    }
  }

  //跳转新页面
  static void startActivity(BuildContext context, Widget widget) async {
   await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return widget;
    }));
  }

  //延迟刷新
  static void sleepThread(int milliseconds, Function function) {
    new Timer(Duration(milliseconds: milliseconds), function);
  }

  //循环刷新
  static Timer sleepThreadWhile(int milliseconds, void callback(Timer timer)) {
    var timer = Timer.periodic(Duration(milliseconds: milliseconds), callback);
    return timer;
  }

  //循环刷新
  static Timer sleepThreadWhileDuration(
      Duration mDuration, void callback(Timer timer)) {
    var timer = Timer.periodic(mDuration, callback);

    return timer;
  }

  //跳转新页面 IOS
  static void push(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return widget;
    }));
  }

  //传入当前页面的context
  static void pop(BuildContext context){
    Navigator.of(context).pop(1);
  }

  static void pushPop(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
      return widget;
    }), (h) => h == null);
  }

  static void getIosTemporaryDirectory(Function(String tempPath) fun) async{
    var directory = (await getTemporaryDirectory()).path;
    fun(directory);
  }

  static void getIosApplicationDocumentsDirectory(Function(String application) fun) async{
    String sDocumentDir = (await getApplicationDocumentsDirectory()).path;
    fun(sDocumentDir);
  }

  static void mkdir(File file){

    new Directory(file.path).create(recursive: true)
        .then((Directory directory) {
      print(directory.path);
    });


  }

  static void assetsWriterFile(String name,File file) async{

    ByteData bytes = await rootBundle.load(name);

    file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));


  }



  ///不建议使用！！！！！
  ///Ios系统会抛异常[无法使用!]
  static void getAndroidExternalStorageDirectory(Function(String sdCard) fun) async{
    String sDCardDir = (await getExternalStorageDirectory()).path;

    fun(sDCardDir);
  }

  static void showLog(Object string) {
    print(string);
  }

  static void showMsg(Object msg) {
    Fluttertoast.showToast(msg: msg);
  }
}

class UUSaveData{

  //添加数据
  static void saveData(String key,String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  //获取数据
  static void getData(String key,Function(String string) function)async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String str = await prefs.get(key);
    UUtils.showLog("获取保存的数据1:$str");
    function(str);



  }


}

class UUJsonUtil {
  /// 转换类为json
  static String encodeObj(Object value) {
    return value == null ? null : json.encode(value);
  }

  /// 将JSON字符串[源]转换为对象。
  static T getObj<T>(String source, T f(Map v)) {
    if (source == null || source.isEmpty) return null;
    try {
      Map map = json.decode(source);
      return map == null ? null : f(map);
    } catch (e) {
      print('JsonUtil convert error, Exception：${e.toString()}');
    }
    return null;
  }

  /// 将JSON字符串或JSON映射[源]转换为对象。
  static T getObject<T>(Object source, T f(Map v)) {
    if (source == null || source.toString().isEmpty) return null;
    try {
      Map map;
      if (source is String) {
        map = json.decode(source);
      } else {
        map = source;
      }
      return map == null ? null : f(map);
    } catch (e) {
      print('JsonUtil convert error, Exception：${e.toString()}');
    }
    return null;
  }

  /// Converts JSON string list [source] to object list.
  static List<T> getObjList<T>(String source, T f(Map v)) {
    if (source == null || source.isEmpty) return null;
    try {
      List list = json.decode(source);
      return list?.map((value) {
        return f(value);
      })?.toList();
    } catch (e) {
      print('JsonUtil convert error, Exception：${e.toString()}');
    }
    return null;
  }

  /// Converts JSON string or JSON map list [source] to object list.
  static List<T> getObjectList<T>(Object source, T f(Map v)) {
    if (source == null || source.toString().isEmpty) return null;
    try {
      List list;
      if (source is String) {
        list = json.decode(source);
      } else {
        list = source;
      }
      return list?.map((value) {
        return f(value);
      })?.toList();
    } catch (e) {
      print('JsonUtil convert error, Exception：${e.toString()}');
    }
    return null;
  }
}

class UULogUtil {
  static const String _defTag = 'common_utils';
  static bool _debugMode = false; //是否是debug模式,true: log v 不输出.
  static int _maxLen = 128;
  static String _tagValue = _defTag;

  static void init({
    String tag = _defTag,
    bool isDebug = false,
    int maxLen = 128,
  }) {
    _tagValue = tag;
    _debugMode = isDebug;
    _maxLen = maxLen;
  }

  static void e(Object object, {String tag}) {
    _printLog(tag, ' e ', object);
  }

  static void v(Object object, {String tag}) {
    if (_debugMode) {
      _printLog(tag, ' v ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    String da = object.toString();
    tag = tag ?? _tagValue;
    if (da.length <= _maxLen) {
      print('$tag$stag $da');
      return;
    }
    print(
        '$tag$stag — — — — — — — — — — — — — — — — st — — — — — — — — — — — — — — — —');
    while (da.isNotEmpty) {
      if (da.length > _maxLen) {
        print('$tag$stag| ${da.substring(0, _maxLen)}');
        da = da.substring(_maxLen, da.length);
      } else {
        print('$tag$stag| $da');
        da = '';
      }
    }
    print(
        '$tag$stag — — — — — — — — — — — — — — — — ed — — — — — — — — — — — — — — — —');
  }
}

/// TextUtil.
class UUTextUtil {
  /// isEmpty
  static bool isEmpty(String text) {
    return text == null || text.isEmpty;
  }

  /// 每隔 x位 加 pattern
  static String formatDigitPattern(String text,
      {int digit = 4, String pattern = ' '}) {
    text = text?.replaceAllMapped(RegExp('(.{$digit})'), (Match match) {
      return '${match.group(0)}$pattern';
    });
    if (text != null && text.endsWith(pattern)) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  /// 每隔 x位 加 pattern, 从末尾开始
  static String formatDigitPatternEnd(String text,
      {int digit = 4, String pattern = ' '}) {
    String temp = reverse(text);
    temp = formatDigitPattern(temp, digit: digit, pattern: pattern);
    temp = reverse(temp);
    return temp;
  }

  /// 每隔4位加空格
  static String formatSpace4(String text) {
    return formatDigitPattern(text);
  }

  /// 每隔3三位加逗号
  /// num 数字或数字字符串。int型。
  static String formatComma3(Object num) {
    return formatDigitPatternEnd(num?.toString(), digit: 3, pattern: ',');
  }

  /// 每隔3三位加逗号
  /// num 数字或数字字符串。double型。
  static String formatDoubleComma3(Object num,
      {int digit = 3, String pattern = ','}) {
    if (num == null) return '';
    List<String> list = num.toString().split('.');
    String left =
        formatDigitPatternEnd(list[0], digit: digit, pattern: pattern);
    String right = list[1];
    return '$left.$right';
  }

  /// hideNumber
  static String hideNumber(String phoneNo,
      {int start = 3, int end = 7, String replacement = '****'}) {
    return phoneNo?.replaceRange(start, end, replacement);
  }

  /// replace
  static String replace(String text, Pattern from, String replace) {
    return text?.replaceAll(from, replace);
  }

  /// split
  static List<String> split(String text, Pattern pattern,
      {List<String> defValue = const []}) {
    List<String> list = text?.split(pattern);
    return list ?? defValue;
  }

  /// reverse
  static String reverse(String text) {
    if (isEmpty(text)) return '';
    StringBuffer sb = StringBuffer();
    for (int i = text.length - 1; i >= 0; i--) {
      sb.writeCharCode(text.codeUnitAt(i));
    }
    return sb.toString();
  }
}

enum MoneyUnit {
  NORMAL, // 6.00
  YUAN, // ¥6.00
  YUAN_ZH, // 6.00元
  DOLLAR, // $6.00
}
enum MoneyFormat {
  NORMAL, //保留两位小数(6.00元)
  END_INTEGER, //去掉末尾'0'(6.00元 -> 6元, 6.60元 -> 6.6元)
  YUAN_INTEGER, //整元(6.00元 -> 6元)
}
/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Money Util.
 * @Date: 2018/9/29
 */

///
class UUMoneyUtil {
  static const String YUAN = '¥';
  static const String YUAN_ZH = '元';
  static const String DOLLAR = '\$';

  /// fen to yuan, format output.
  /// 分 转 元, format格式输出.
  static String changeF2Y(int amount,
      {MoneyFormat format = MoneyFormat.NORMAL}) {
    if (amount == null) return null;
    String moneyTxt;
    double yuan = NumUtil.divide(amount, 100);
    switch (format) {
      case MoneyFormat.NORMAL:
        moneyTxt = yuan.toStringAsFixed(2);
        break;
      case MoneyFormat.END_INTEGER:
        if (amount % 100 == 0) {
          moneyTxt = yuan.toInt().toString();
        } else if (amount % 10 == 0) {
          moneyTxt = yuan.toStringAsFixed(1);
        } else {
          moneyTxt = yuan.toStringAsFixed(2);
        }
        break;
      case MoneyFormat.YUAN_INTEGER:
        moneyTxt = (amount % 100 == 0)
            ? yuan.toInt().toString()
            : yuan.toStringAsFixed(2);
        break;
    }
    return moneyTxt;
  }

  /// fen str to yuan, format & unit  output.
  /// 分字符串 转 元, format 与 unit 格式 输出.
  static String changeFStr2YWithUnit(String amountStr,
      {MoneyFormat format = MoneyFormat.NORMAL,
      MoneyUnit unit = MoneyUnit.NORMAL}) {
    int amount;
    if (amountStr != null) {
      double value = double.tryParse(amountStr);
      amount = (value == null ? null : value.toInt());
    }
    return changeF2YWithUnit(amount, format: format, unit: unit);
  }

  /// fen to yuan, format & unit  output.
  /// 分 转 元, format 与 unit 格式 输出.
  static String changeF2YWithUnit(int amount,
      {MoneyFormat format = MoneyFormat.NORMAL,
      MoneyUnit unit = MoneyUnit.NORMAL}) {
    return withUnit(changeF2Y(amount, format: format), unit);
  }

  /// yuan, format & unit  output.(yuan is int,double,str).
  /// 元, format 与 unit 格式 输出.
  static String changeYWithUnit(Object yuan, MoneyUnit unit,
      {MoneyFormat format}) {
    if (yuan == null) return null;
    String yuanTxt = yuan.toString();
    if (format != null) {
      int amount = changeY2F(yuan);
      yuanTxt = changeF2Y(amount.toInt(), format: format);
    }
    return withUnit(yuanTxt, unit);
  }

  /// yuan to fen.
  /// 元 转 分，
  static int changeY2F(Object yuan) {
    if (yuan == null) return null;
    return NumUtil.multiplyDecStr(yuan.toString(), '100').toInt();
  }

  /// with unit.
  /// 拼接单位.
  static String withUnit(String moneyTxt, MoneyUnit unit) {
    if (moneyTxt == null || moneyTxt.isEmpty) return null;
    switch (unit) {
      case MoneyUnit.YUAN:
        moneyTxt = YUAN + moneyTxt;
        break;
      case MoneyUnit.YUAN_ZH:
        moneyTxt = moneyTxt + YUAN_ZH;
        break;
      case MoneyUnit.DOLLAR:
        moneyTxt = DOLLAR + moneyTxt;
        break;
      default:
        break;
    }
    return moneyTxt;
  }
}

/// Num Util.
class NumUtil {
  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num getNumByValueStr(String valueStr, {int fractionDigits}) {
    double value = double.tryParse(valueStr);
    return fractionDigits == null
        ? value
        : getNumByValueDouble(value, fractionDigits);
  }

  /// The parameter [fractionDigits] must be an integer satisfying: `0 <= fractionDigits <= 20`.
  static num getNumByValueDouble(double value, int fractionDigits) {
    if (value == null) return null;
    String valueStr = value.toStringAsFixed(fractionDigits);
    return fractionDigits == 0
        ? int.tryParse(valueStr)
        : double.tryParse(valueStr);
  }

  /// get int by value str.
  static int getIntByValueStr(String valueStr, {int defValue = 0}) {
    return int.tryParse(valueStr) ?? defValue;
  }

  /// get double by value str.
  static double getDoubleByValueStr(String valueStr, {double defValue = 0}) {
    return double.tryParse(valueStr) ?? defValue;
  }

  ///isZero
  static bool isZero(num value) {
    return value == null || value == 0;
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static double add(num a, num b) {
    return addDec(a, b).toDouble();
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static double subtract(num a, num b) {
    return subtractDec(a, b).toDouble();
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static double multiply(num a, num b) {
    return multiplyDec(a, b).toDouble();
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static double divide(num a, num b) {
    return divideDec(a, b).toDouble();
  }

  /// 加 (精确相加,防止精度丢失).
  /// add (without loosing precision).
  static Decimal addDec(num a, num b) {
    return addDecStr(a.toString(), b.toString());
  }

  /// 减 (精确相减,防止精度丢失).
  /// subtract (without loosing precision).
  static Decimal subtractDec(num a, num b) {
    return subtractDecStr(a.toString(), b.toString());
  }

  /// 乘 (精确相乘,防止精度丢失).
  /// multiply (without loosing precision).
  static Decimal multiplyDec(num a, num b) {
    return multiplyDecStr(a.toString(), b.toString());
  }

  /// 除 (精确相除,防止精度丢失).
  /// divide (without loosing precision).
  static Decimal divideDec(num a, num b) {
    return divideDecStr(a.toString(), b.toString());
  }

  /// 余数
  static Decimal remainder(num a, num b) {
    return remainderDecStr(a.toString(), b.toString());
  }

  /// Relational less than operator.
  static bool lessThan(num a, num b) {
    return lessThanDecStr(a.toString(), b.toString());
  }

  /// Relational less than or equal operator.
  static bool thanOrEqual(num a, num b) {
    return thanOrEqualDecStr(a.toString(), b.toString());
  }

  /// Relational greater than operator.
  static bool greaterThan(num a, num b) {
    return greaterThanDecStr(a.toString(), b.toString());
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqual(num a, num b) {
    return greaterOrEqualDecStr(a.toString(), b.toString());
  }

  /// 加
  static Decimal addDecStr(String a, String b) {
    return Decimal.parse(a) + Decimal.parse(b);
  }

  /// 减
  static Decimal subtractDecStr(String a, String b) {
    return Decimal.parse(a) - Decimal.parse(b);
  }

  /// 乘
  static Decimal multiplyDecStr(String a, String b) {
    return Decimal.parse(a) * Decimal.parse(b);
  }

  /// 除
  static Decimal divideDecStr(String a, String b) {
    return Decimal.parse(a) / Decimal.parse(b);
  }

  /// 余数
  static Decimal remainderDecStr(String a, String b) {
    return Decimal.parse(a) % Decimal.parse(b);
  }

  /// Relational less than operator.
  static bool lessThanDecStr(String a, String b) {
    return Decimal.parse(a) < Decimal.parse(b);
  }

  /// Relational less than or equal operator.
  static bool thanOrEqualDecStr(String a, String b) {
    return Decimal.parse(a) <= Decimal.parse(b);
  }

  /// Relational greater than operator.
  static bool greaterThanDecStr(String a, String b) {
    return Decimal.parse(a) > Decimal.parse(b);
  }

  /// Relational greater than or equal operator.
  static bool greaterOrEqualDecStr(String a, String b) {
    return Decimal.parse(a) >= Decimal.parse(b);
  }
}

class UUDateFormats {
  static String full = 'yyyy-MM-dd HH:mm:ss';
  static String y_mo_d_h_m = 'yyyy-MM-dd HH:mm';
  static String y_mo_d = 'yyyy-MM-dd';
  static String y_mo = 'yyyy-MM';
  static String mo_d = 'MM-dd';
  static String mo_d_h_m = 'MM-dd HH:mm';
  static String h_m_s = 'HH:mm:ss';
  static String h_m = 'HH:mm';

  static String zh_full = 'yyyy年MM月dd日 HH时mm分ss秒';
  static String zh_y_mo_d_h_m = 'yyyy年MM月dd日 HH时mm分';
  static String zh_y_mo_d = 'yyyy年MM月dd日';
  static String zh_y_mo = 'yyyy年MM月';
  static String zh_mo_d = 'MM月dd日';
  static String zh_mo_d_h_m = 'MM月dd日 HH时mm分';
  static String zh_h_m_s = 'HH时mm分ss秒';
  static String zh_h_m = 'HH时mm分';
}

/// month->days.
Map<int, int> MONTH_DAY = {
  1: 31,
  2: 28,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};

/// Date Util.
class UUDateUtil {
  /// get DateTime By DateStr.
  static DateTime getDateTime(String dateStr, {bool isUtc}) {
    DateTime dateTime = DateTime.tryParse(dateStr);
    if (isUtc != null) {
      if (isUtc) {
        dateTime = dateTime.toUtc();
      } else {
        dateTime = dateTime.toLocal();
      }
    }
    return dateTime;
  }

  /// get DateTime By Milliseconds.
  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return ms == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  /// get DateMilliseconds By DateStr.
  static int getDateMsByTimeStr(String dateStr) {
    DateTime dateTime = DateTime.tryParse(dateStr);
    return dateTime?.millisecondsSinceEpoch;
  }

  /// 现在获得日期毫秒。
  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// get Now Date Str.(yyyy-MM-dd HH:mm:ss)
  static String getNowDateStr() {
    return formatDate(DateTime.now());
  }

  /// format date by milliseconds.
  /// milliseconds 日期毫秒
  static String formatDateMs(int ms, {bool isUtc = false, String format}) {
    return formatDate(getDateTimeByMs(ms, isUtc: isUtc), format: format);
  }

  /// format date by date str.
  /// dateStr 日期字符串
  static String formatDateStr(String dateStr, {bool isUtc, String format}) {
    return formatDate(getDateTime(dateStr, isUtc: isUtc), format: format);
  }

  /// format date by DateTime.
  /// format 转换格式(已提供常用格式 DateFormats，可以自定义格式：'yyyy/MM/dd HH:mm:ss')
  /// 格式要求
  /// year -> yyyy/yy   month -> MM/M    day -> dd/d
  /// hour -> HH/H      minute -> mm/m   second -> ss/s
  static String formatDate(DateTime dateTime, {String format}) {
    if (dateTime == null) return '';
    format = format ?? UUDateFormats.full;
    if (format.contains('yy')) {
      String year = dateTime.year.toString();
      if (format.contains('yyyy')) {
        format = format.replaceAll('yyyy', year);
      } else {
        format = format.replaceAll(
            'yy', year.substring(year.length - 2, year.length));
      }
    }

    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');

    return format;
  }

  /// com format.
  static String _comFormat(
      int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format =
            format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  /// get WeekDay.
  /// dateTime
  /// isUtc
  /// languageCode zh or en
  /// short
  static String getWeekday(DateTime dateTime,
      {String languageCode = 'en', bool short = false}) {
    if (dateTime == null) return null;
    String weekday;
    switch (dateTime.weekday) {
      case 1:
        weekday = languageCode == 'zh' ? '星期一' : 'Monday';
        break;
      case 2:
        weekday = languageCode == 'zh' ? '星期二' : 'Tuesday';
        break;
      case 3:
        weekday = languageCode == 'zh' ? '星期三' : 'Wednesday';
        break;
      case 4:
        weekday = languageCode == 'zh' ? '星期四' : 'Thursday';
        break;
      case 5:
        weekday = languageCode == 'zh' ? '星期五' : 'Friday';
        break;
      case 6:
        weekday = languageCode == 'zh' ? '星期六' : 'Saturday';
        break;
      case 7:
        weekday = languageCode == 'zh' ? '星期日' : 'Sunday';
        break;
      default:
        break;
    }
    return languageCode == 'zh'
        ? (short ? weekday.replaceAll('星期', '周') : weekday)
        : weekday.substring(0, short ? 3 : weekday.length);
  }

  /// get WeekDay By Milliseconds.
  static String getWeekdayByMs(int milliseconds,
      {bool isUtc = false, String languageCode, bool short = false}) {
    DateTime dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getWeekday(dateTime, languageCode: languageCode, short: short);
  }

  /// get day of year.
  /// 在今年的第几天.
  static int getDayOfYear(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int days = dateTime.day;
    for (int i = 1; i < month; i++) {
      days = days + MONTH_DAY[i];
    }
    if (isLeapYearByYear(year) && month > 2) {
      days = days + 1;
    }
    return days;
  }

  /// get day of year.
  /// 在今年的第几天.
  static int getDayOfYearByMs(int ms, {bool isUtc = false}) {
    return getDayOfYear(DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc));
  }

  /// is today.
  /// 是否是当天.
  static bool isToday(int milliseconds, {bool isUtc = false, int locMs}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime old =
        DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime now;
    if (locMs != null) {
      now = UUDateUtil.getDateTimeByMs(locMs);
    } else {
      now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  /// is yesterday by dateTime.
  /// 是否是昨天.
  static bool isYesterday(DateTime dateTime, DateTime locDateTime) {
    if (yearIsEqual(dateTime, locDateTime)) {
      int spDay = getDayOfYear(locDateTime) - getDayOfYear(dateTime);
      return spDay == 1;
    } else {
      return ((locDateTime.year - dateTime.year == 1) &&
          dateTime.month == 12 &&
          locDateTime.month == 1 &&
          dateTime.day == 31 &&
          locDateTime.day == 1);
    }
  }

  /// is yesterday by millis.
  /// 是否是昨天.
  static bool isYesterdayByMs(int ms, int locMs) {
    return isYesterday(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  /// is Week.
  /// 是否是本周.
  static bool isWeek(int ms, {bool isUtc = false, int locMs}) {
    if (ms == null || ms <= 0) {
      return false;
    }
    DateTime _old = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
    DateTime _now;
    if (locMs != null) {
      _now = UUDateUtil.getDateTimeByMs(locMs, isUtc: isUtc);
    } else {
      _now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }

    DateTime old =
        _now.millisecondsSinceEpoch > _old.millisecondsSinceEpoch ? _old : _now;
    DateTime now =
        _now.millisecondsSinceEpoch > _old.millisecondsSinceEpoch ? _now : _old;
    return (now.weekday >= old.weekday) &&
        (now.millisecondsSinceEpoch - old.millisecondsSinceEpoch <=
            7 * 24 * 60 * 60 * 1000);
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) {
    return dateTime.year == locDateTime.year;
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqualByMs(int ms, int locMs) {
    return yearIsEqual(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  /// Return whether it is leap year.
  /// 是否是闰年
  static bool isLeapYear(DateTime dateTime) {
    return isLeapYearByYear(dateTime.year);
  }

  /// Return whether it is leap year.
  /// 是否是闰年
  static bool isLeapYearByYear(int year) {
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
  }
}

List<String> ID_CARD_PROVINCE_DICT = [
  '11=北京',
  '12=天津',
  '13=河北',
  '14=山西',
  '15=内蒙古',
  '21=辽宁',
  '22=吉林',
  '23=黑龙江',
  '31=上海',
  '32=江苏',
  '33=浙江',
  '34=安徽',
  '35=福建',
  '36=江西',
  '37=山东',
  '41=河南',
  '42=湖北',
  '43=湖南',
  '44=广东',
  '45=广西',
  '46=海南',
  '50=重庆',
  '51=四川',
  '52=贵州',
  '53=云南',
  '54=西藏',
  '61=陕西',
  '62=甘肃',
  '63=青海',
  '64=宁夏',
  '65=新疆',
  '71=台湾',
  '81=香港',
  '82=澳门',
  '91=国外',
];

/// Regex Util.
class UURegexUtil {
  /// Regex of simple mobile.
  static final String regexMobileSimple = '^[1]\\d{10}\$';

  /// Regex of exact mobile.
  /// <p>china mobile: 134(0-8), 135, 136, 137, 138, 139, 147, 150, 151, 152, 157, 158, 159, 178, 182, 183, 184, 187, 188, 198</p>
  /// <p>china unicom: 130, 131, 132, 145, 155, 156, 166, 171, 175, 176, 185, 186</p>
  /// <p>china telecom: 133, 153, 173, 177, 180, 181, 189, 199</p>
  /// <p>global star: 1349</p>
  /// <p>virtual operator: 170</p>
  static final String regexMobileExact =
      '^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[1,8,9]))\\d{8}\$';

  /// Regex of telephone number.
  static final String regexTel = '^0\\d{2,3}[- ]?\\d{7,8}';

  /// Regex of id card number which length is 15.
  static final String regexIdCard15 =
      '^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}\$';

  /// Regex of id card number which length is 18.
  static final String regexIdCard18 =
      '^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9Xx])\$';

  /// Regex of email.
  static final String regexEmail =
      '^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$';

  /// Regex of url.
  static final String regexUrl = '[a-zA-Z]+://[^\\s]*';

  /// Regex of Chinese character.
  static final String regexZh = '[\\u4e00-\\u9fa5]';

  /// Regex of date which pattern is 'yyyy-MM-dd'.
  static final String regexDate =
      '^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\$';

  /// Regex of ip address.
  static final String regexIp =
      '((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)';

  /// must contain letters and numbers, 6 ~ 18.
  /// 必须包含字母和数字, 6~18.
  static const String regexUsername =
      '^(?![0-9]+\$)(?![a-zA-Z]+\$)[0-9A-Za-z]{6,18}\$';

  /// must contain letters and numbers, can contain special characters 6 ~ 18.
  /// 必须包含字母和数字,可包含特殊字符 6~18.
  static const String regexUsername2 =
      '^(?![0-9]+\$)(?![a-zA-Z]+\$)[0-9A-Za-z\\W]{6,18}\$';

  /// must contain letters and numbers and special characters, 6 ~ 18.
  /// 必须包含字母和数字和殊字符, 6~18.
  static const String regexUsername3 =
      '^(?![0-9]+\$)(?![a-zA-Z]+\$)(?![0-9a-zA-Z]+\$)(?![0-9\\W]+\$)(?![a-zA-Z\\W]+\$)[0-9A-Za-z\\W]{6,18}\$';

  /// QQ号码的正则表达式。
  static final String regexQQ = '[1-9][0-9]{4,}';

  /// 中国邮政编码的正则表达式。
  static final String regexChinaPostalCode = "[1-9]\\d{5}(?!\\d)";

  /// 正则表达式的护照。
  static final String regexPassport =
      r'(^[EeKkGgDdSsPpHh]\d{8}$)|(^(([Ee][a-fA-F])|([DdSsPp][Ee])|([Kk][Jj])|([Mm][Aa])|(1[45]))\d{7}$)';

  static final Map<String, String> cityMap = Map();

  ///返回输入是否匹配简单移动的正则表达式。
  static bool isMobileSimple(String input) {
    return matches(regexMobileSimple, input);
  }

  ///返回输入是否匹配精确移动的正则表达式。
  static bool isMobileExact(String input) {
    return matches(regexMobileExact, input);
  }

  /// 返回输入是否匹配电话号码的正则表达式。
  static bool isTel(String input) {
    return matches(regexTel, input);
  }

  /// 返回输入是否匹配id卡号的正则表达式。
  static bool isIDCard(String input) {
    if (input != null && input.length == 15) {
      return isIDCard15(input);
    }
    if (input != null && input.length == 18) {
      return isIDCard18Exact(input);
    }
    return false;
  }

  /// Return whether input matches regex of id card number which length is 15.
  static bool isIDCard15(String input) {
    return matches(regexIdCard15, input);
  }

  /// Return whether input matches regex of id card number which length is 18.
  static bool isIDCard18(String input) {
    return matches(regexIdCard18, input);
  }

  ///Return whether input matches regex of exact id card number which length is 18.
  static bool isIDCard18Exact(String input) {
    if (isIDCard18(input)) {
      List<int> factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      List<String> suffix = [
        '1',
        '0',
        'X',
        '9',
        '8',
        '7',
        '6',
        '5',
        '4',
        '3',
        '2'
      ];
      if (cityMap.isEmpty) {
        List<String> list = ID_CARD_PROVINCE_DICT;
        List<MapEntry<String, String>> mapEntryList = List();
        for (int i = 0, length = list.length; i < length; i++) {
          List<String> tokens = list[i].trim().split('=');
          MapEntry<String, String> mapEntry = MapEntry(tokens[0], tokens[1]);
          mapEntryList.add(mapEntry);
        }
        cityMap.addEntries(mapEntryList);
      }
      if (cityMap[input.substring(0, 2)] != null) {
        int weightSum = 0;
        for (int i = 0; i < 17; ++i) {
          weightSum += (input.codeUnitAt(i) - '0'.codeUnitAt(0)) * factor[i];
        }
        int idCardMod = weightSum % 11;
        String idCardLast = String.fromCharCode(input.codeUnitAt(17));
        return idCardLast == suffix[idCardMod];
      }
    }
    return false;
  }

  /// Return whether input matches regex of email.
  static bool isEmail(String input) {
    return matches(regexEmail, input);
  }

  /// Return whether input matches regex of url.
  static bool isURL(String input) {
    return matches(regexUrl, input);
  }

  /// Return whether input matches regex of Chinese character.
  static bool isZh(String input) {
    return '〇' == input || matches(regexZh, input);
  }

  /// Return whether input matches regex of date which pattern is 'yyyy-MM-dd'.
  static bool isDate(String input) {
    return matches(regexDate, input);
  }

  /// Return whether input matches regex of ip address.
  static bool isIP(String input) {
    return matches(regexIp, input);
  }

  /// Return whether input matches regex of username.
  static bool isUserName(String input, {String regex = regexUsername}) {
    return matches(regex, input);
  }

  /// Return whether input matches regex of QQ.
  static bool isQQ(String input) {
    return matches(regexQQ, input);
  }

  ///Return whether input matches regex of Passport.
  static bool isPassport(String input) {
    return matches(regexPassport, input);
  }

  static bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return RegExp(regex).hasMatch(input);
  }
}

///(xx)Configurable output.
///(xx)为可配置输出.
enum DayFormat {
  ///(less than 10s->just now)、x minutes、x hours、(Yesterday)、x days.
  ///(小于10s->刚刚)、x分钟、x小时、(昨天)、x天.
  Simple,

  ///(less than 10s->just now)、x minutes、x hours、[This year:(Yesterday/a day ago)、(two days age)、MM-dd ]、[past years: yyyy-MM-dd]
  ///(小于10s->刚刚)、x分钟、x小时、[今年: (昨天/1天前)、(2天前)、MM-dd],[往年: yyyy-MM-dd].
  Common,

  ///日期 + HH:mm
  ///(less than 10s->just now)、x minutes、x hours、[This year:(Yesterday HH:mm/a day ago)、(two days age)、MM-dd HH:mm]、[past years: yyyy-MM-dd HH:mm]
  ///小于10s->刚刚)、x分钟、x小时、[今年: (昨天 HH:mm/1天前)、(2天前)、MM-dd HH:mm],[往年: yyyy-MM-dd HH:mm].
  Full,
}

///Timeline information configuration.
///Timeline信息配置.
abstract class TimelineInfo {
  String suffixAgo(); //suffix ago(后缀 后).

  String suffixAfter(); //suffix after(后缀 前).

  int maxJustNowSecond() => 30; // max just now second.

  String lessThanOneMinute() => ''; //just now(刚刚).

  String customYesterday() => ''; //Yesterday(昨天).优先级高于keepOneDay

  bool keepOneDay(); //保持1天,example: true -> 1天前, false -> MM-dd.

  bool keepTwoDays(); //保持2天,example: true -> 2天前, false -> MM-dd.

  String oneMinute(int minutes); //a minute(1分钟).

  String minutes(int minutes); //x minutes(x分钟).

  String anHour(int hours); //an hour(1小时).

  String hours(int hours); //x hours(x小时).

  String oneDay(int days); //a day(1天).

  String weeks(int week) => ''; //x week(星期x).

  String days(int days); //x days(x天).

}

class ZhInfo implements TimelineInfo {
  String suffixAgo() => '前';

  String suffixAfter() => '后';

  int maxJustNowSecond() => 30;

  String lessThanOneMinute() => '刚刚';

  String customYesterday() => '昨天';

  bool keepOneDay() => true;

  bool keepTwoDays() => true;

  String oneMinute(int minutes) => '$minutes分钟';

  String minutes(int minutes) => '$minutes分钟';

  String anHour(int hours) => '$hours小时';

  String hours(int hours) => '$hours小时';

  String oneDay(int days) => '$days天';

  String weeks(int week) => ''; //x week(星期x).

  String days(int days) => '$days天';
}

class EnInfo implements TimelineInfo {
  String suffixAgo() => ' ago';

  String suffixAfter() => ' after';

  int maxJustNowSecond() => 30;

  String lessThanOneMinute() => 'just now';

  String customYesterday() => 'Yesterday';

  bool keepOneDay() => true;

  bool keepTwoDays() => true;

  String oneMinute(int minutes) => 'a minute';

  String minutes(int minutes) => '$minutes minutes';

  String anHour(int hours) => 'an hour';

  String hours(int hours) => '$hours hours';

  String oneDay(int days) => 'a day';

  String weeks(int week) => ''; //x week(星期x).

  String days(int days) => '$days days';
}

class ZhNormalInfo implements TimelineInfo {
  String suffixAgo() => '前';

  String suffixAfter() => '后';

  int maxJustNowSecond() => 30;

  String lessThanOneMinute() => '刚刚';

  String customYesterday() => '昨天';

  bool keepOneDay() => true;

  bool keepTwoDays() => false;

  String oneMinute(int minutes) => '$minutes分钟';

  String minutes(int minutes) => '$minutes分钟';

  String anHour(int hours) => '$hours小时';

  String hours(int hours) => '$hours小时';

  String oneDay(int days) => '$days天';

  String weeks(int week) => ''; //x week(星期x).

  String days(int days) => '$days天';
}

class EnNormalInfo implements TimelineInfo {
  String suffixAgo() => ' ago';

  String suffixAfter() => ' after';

  int maxJustNowSecond() => 30;

  String lessThanOneMinute() => 'just now';

  String customYesterday() => 'Yesterday';

  bool keepOneDay() => true;

  bool keepTwoDays() => false;

  String oneMinute(int minutes) => 'a minute';

  String minutes(int minutes) => '$minutes minutes';

  String anHour(int hours) => 'an hour';

  String hours(int hours) => '$hours hours';

  String oneDay(int days) => 'a day';

  String weeks(int week) => ''; //x week(星期x).

  String days(int days) => '$days days';
}

Map<String, TimelineInfo> _timelineInfoMap = {
  'zh': ZhInfo(),
  'en': EnInfo(),
  'zh_normal': ZhNormalInfo(), //keepTwoDays() => false
  'en_normal': EnNormalInfo(), //keepTwoDays() => false
};

///add custom configuration.
void setLocaleInfo(String locale, TimelineInfo timelineInfo) {
  assert(locale != null, '[locale] must not be null');
  assert(timelineInfo != null, '[timelineInfo] must not be null');
  _timelineInfoMap[locale] = timelineInfo;
}

/// TimelineUtil
class UUTimelineUtil {
  /// format time by DateTime.
  /// dateTime
  /// locDateTime: current time or schedule time.
  /// locale: output key.
  static String formatByDateTime(
    DateTime dateTime, {
    DateTime locDateTime,
    String locale,
    DayFormat dayFormat,
  }) {
    return format(
      dateTime?.millisecondsSinceEpoch,
      locTimeMs: locDateTime?.millisecondsSinceEpoch,
      locale: locale,
      dayFormat: dayFormat,
    );
  }

  /// format time by millis.
  /// dateTime : millis.
  /// locDateTime: current time or schedule time. millis.
  /// locale: output key.
  static String format(
    int ms, {
    int locTimeMs,
    String locale,
    DayFormat dayFormat,
  }) {
    int _locTimeMs = locTimeMs ?? DateTime.now().millisecondsSinceEpoch;
    String _locale = locale ?? 'en';
    TimelineInfo _info = _timelineInfoMap[_locale] ?? EnInfo();
    DayFormat _dayFormat = dayFormat ?? DayFormat.Common;

    int elapsed = _locTimeMs - ms;
    String suffix;
    if (elapsed < 0) {
      suffix = _info.suffixAfter();
      // suffix after is empty. user just now.
      if (suffix.isNotEmpty) {
        elapsed = elapsed.abs();
        _dayFormat = DayFormat.Simple;
      } else {
        return _info.lessThanOneMinute();
      }
    } else {
      suffix = _info.suffixAgo();
    }

    String timeline;
    if (_info.customYesterday().isNotEmpty &&
        UUDateUtil.isYesterdayByMs(ms, _locTimeMs)) {
      return _getYesterday(ms, _info, _dayFormat);
    }

    if (!UUDateUtil.yearIsEqualByMs(ms, _locTimeMs)) {
      timeline = _getYear(ms, _dayFormat);
      if (timeline.isNotEmpty) return timeline;
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    if (seconds < 90) {
      timeline = _info.oneMinute(1);
      if (suffix != _info.suffixAfter() &&
          _info.lessThanOneMinute().isNotEmpty &&
          seconds < _info.maxJustNowSecond()) {
        timeline = _info.lessThanOneMinute();
        suffix = '';
      }
    } else if (minutes < 60) {
      timeline = _info.minutes(minutes.round());
    } else if (minutes < 90) {
      timeline = _info.anHour(1);
    } else if (hours < 24) {
      timeline = _info.hours(hours.round());
    } else {
      if ((days.round() == 1 && _info.keepOneDay() == true) ||
          (days.round() == 2 && _info.keepTwoDays() == true)) {
        _dayFormat = DayFormat.Simple;
      }
      timeline = _formatDays(ms, days.round(), _info, _dayFormat);
      suffix = (_dayFormat == DayFormat.Simple ? suffix : '');
    }
    return timeline + suffix;
  }

  /// Timeline like QQ.
  ///
  /// today (HH:mm)
  /// yesterday (昨天;Yesterday)
  /// this week (星期一,周一;Monday,Mon)
  /// others (yyyy-MM-dd)
  static String formatA(
    int ms, {
    int locMs,
    String formatToday = 'HH:mm',
    String format = 'yyyy-MM-dd',
    String languageCode = 'zh',
    bool short = false,
  }) {
    int _locTimeMs = locMs ?? DateTime.now().millisecondsSinceEpoch;
    int elapsed = _locTimeMs - ms;
    if (elapsed < 0) {
      return UUDateUtil.formatDateMs(ms, format: formatToday);
    }

    if (UUDateUtil.isToday(ms, locMs: _locTimeMs)) {
      return UUDateUtil.formatDateMs(ms, format: formatToday);
    }

    if (UUDateUtil.isYesterdayByMs(ms, _locTimeMs)) {
      return languageCode == 'zh' ? '昨天' : 'Yesterday';
    }

    if (UUDateUtil.isWeek(ms, locMs: _locTimeMs)) {
      return UUDateUtil.getWeekdayByMs(ms,
          languageCode: languageCode, short: short);
    }

    return UUDateUtil.formatDateMs(ms, format: format);
  }

  /// get Yesterday.
  /// 获取昨天.
  static String _getYesterday(
    int ms,
    TimelineInfo info,
    DayFormat dayFormat,
  ) {
    return info.customYesterday() +
        (dayFormat == DayFormat.Full
            ? (' ' + UUDateUtil.formatDateMs(ms, format: 'HH:mm'))
            : '');
  }

  /// get is not year info.
  /// 获取非今年信息.
  static String _getYear(
    int ms,
    DayFormat dayFormat,
  ) {
    if (dayFormat != DayFormat.Simple) {
      return UUDateUtil.formatDateMs(ms,
          format: (dayFormat == DayFormat.Common
              ? 'yyyy-MM-dd'
              : 'yyyy-MM-dd HH:mm'));
    }
    return '';
  }

  /// format Days.
  static String _formatDays(
    int ms,
    num days,
    TimelineInfo timelineInfo,
    DayFormat dayFormat,
  ) {
    String timeline;
    switch (dayFormat) {
      case DayFormat.Simple:
        timeline = (days == 1
            ? timelineInfo.oneDay(days.round())
            : timelineInfo.days(days.round()));
        break;
      case DayFormat.Common:
        timeline = UUDateUtil.formatDateMs(ms, format: 'MM-dd');
        break;
      case DayFormat.Full:
        timeline = UUDateUtil.formatDateMs(ms, format: 'MM-dd HH:mm');
        break;
    }
    return timeline;
  }
}

// Object Util.
class IIObjectUtil {
  /// Returns true if the string is null or 0-length.
  static bool isEmptyString(String str) {
    return str == null || str.isEmpty;
  }

  /// Returns true if the list is null or 0-length.
  static bool isEmptyList(Iterable list) {
    return list == null || list.isEmpty;
  }

  /// Returns true if there is no key/value pair in the map.
  static bool isEmptyMap(Map map) {
    return map == null || map.isEmpty;
  }

  /// Returns true  String or List or Map is empty.
  static bool isEmpty(Object object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is Iterable && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  /// Returns true String or List or Map is not empty.
  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  /// Returns true Two List Is Equal.
  static bool twoListIsEqual(List listA, List listB) {
    if (listA == listB) return true;
    if (listA == null || listB == null) return false;
    int length = listA.length;
    if (length != listB.length) return false;
    for (int i = 0; i < length; i++) {
      if (!listA.contains(listB[i])) {
        return false;
      }
    }
    return true;
  }

  /// get length.
  static int getLength(Object value) {
    if (value == null) return 0;
    if (value is String) {
      return value.length;
    } else if (value is Iterable) {
      return value.length;
    } else if (value is Map) {
      return value.length;
    } else {
      return 0;
    }
  }
}

//----------------------

///默认设计稿尺寸（单位 dp or pt）
double _designW = 360.0;
double _designH = 640.0;
double _designD = 3.0;

/**
 * 配置设计稿尺寸（单位 dp or pt）
 * w 宽
 * h 高
 * density 像素密度
 */

/// 配置设计稿尺寸 屏幕 宽，高，密度。
/// Configuration design draft size  screen width, height, density.
void setDesignWHD(double w, double h, {double density = 3.0}) {
  _designW = w ?? _designW;
  _designH = h ?? _designH;
  _designD = density ?? _designD;
}

/// Screen Util.
class UUScreenUtil {
  double _screenWidth = 0.0;
  double _screenHeight = 0.0;
  double _screenDensity = 0.0;
  double _statusBarHeight = 0.0;
  double _bottomBarHeight = 0.0;
  double _appBarHeight = 0.0;
  MediaQueryData _mediaQueryData;

  static final UUScreenUtil _singleton = UUScreenUtil();

  static UUScreenUtil getInstance() {
    _singleton._init();
    return _singleton;
  }

  _init() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    if (_mediaQueryData != mediaQuery) {
      _mediaQueryData = mediaQuery;
      _screenWidth = mediaQuery.size.width;
      _screenHeight = mediaQuery.size.height;
      _screenDensity = mediaQuery.devicePixelRatio;
      _statusBarHeight = mediaQuery.padding.top;
      _bottomBarHeight = mediaQuery.padding.bottom;
      _appBarHeight = kToolbarHeight;
    }
  }

  /// screen width
  /// 屏幕 宽
  double get screenWidth => _screenWidth;

  /// screen height
  /// 屏幕 高
  double get screenHeight => _screenHeight;

  /// appBar height
  /// appBar 高
  double get appBarHeight => _appBarHeight;

  /// screen density
  /// 屏幕 像素密度
  double get screenDensity => _screenDensity;

  /// status bar Height
  /// 状态栏高度
  double get statusBarHeight => _statusBarHeight;

  /// bottom bar Height
  double get bottomBarHeight => _bottomBarHeight;

  /// media Query Data
  MediaQueryData get mediaQueryData => _mediaQueryData;

  /// screen width
  /// 当前屏幕 宽
  static double getScreenW(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width;
  }

  /// screen height
  /// 当前屏幕 高
  static double getScreenH(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height;
  }

  /// screen density
  /// 当前屏幕 像素密度
  static double getScreenDensity(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.devicePixelRatio;
  }

  /// status bar Height
  /// 当前状态栏高度
  static double getStatusBarH(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.padding.top;
  }

  /// status bar Height
  /// 当前BottomBar高度
  static double getBottomBarH(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.padding.bottom;
  }

  /// 当前MediaQueryData
  static MediaQueryData getMediaQueryData(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery;
  }

  /// 仅支持纵屏。
  /// returns the size after adaptation according to the screen width.(unit dp or pt)
  /// 返回根据屏幕宽适配后尺寸（单位 dp or pt）
  /// size 单位 dp or pt
  static double xp2dpW(BuildContext context, double size) {
    if (context == null || getScreenW(context) == 0.0) return size;
    return size * getScreenW(context) / _designW;
  }

  /// 仅支持纵屏。
  /// returns the size after adaptation according to the screen height.(unit dp or pt)
  /// 返回根据屏幕高适配后尺寸 （单位 dp or pt）
  /// size unit dp or pt
  static double xp2dpH(BuildContext context, double size) {
    if (context == null || getScreenH(context) == 0.0) return size;
    return size * getScreenH(context) / _designH;
  }

  /// 仅支持纵屏。
  /// returns the font size after adaptation according to the screen density.
  /// 返回根据屏幕宽适配后字体尺寸
  /// fontSize 字体尺寸
  static double xp2sp(BuildContext context, double fontSize) {
    if (context == null || getScreenW(context) == 0.0) return fontSize;
    return fontSize * getScreenW(context) / _designW;
  }

  /// Orientation
  /// 设备方向(portrait, landscape)
  static Orientation getOrientation(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.orientation;
  }

  /// 仅支持纵屏。
  /// returns the size after adaptation according to the screen width.(unit dp or pt)
  /// 返回根据屏幕宽适配后尺寸（单位 dp or pt）
  /// size 单位 dp or pt
  double getWidth(double size) {
    return _screenWidth == 0.0 ? size : (size * _screenWidth / _designW);
  }

  /// 仅支持纵屏。
  /// returns the size after adaptation according to the screen height.(unit dp or pt)
  /// 返回根据屏幕高适配后尺寸（单位 dp or pt）
  /// size unit dp or pt
  double getHeight(double size) {
    return _screenHeight == 0.0 ? size : (size * _screenHeight / _designH);
  }

  /// 仅支持纵屏
  /// returns the size after adaptation according to the screen width.(unit dp or pt)
  /// 返回根据屏幕宽适配后尺寸（单位 dp or pt）
  /// sizePx unit px
  double getWidthPx(double sizePx) {
    return _screenWidth == 0.0
        ? (sizePx / _designD)
        : (sizePx * _screenWidth / (_designW * _designD));
  }

  /// 仅支持纵屏。
  /// returns the size after adaptation according to the screen height.(unit dp or pt)
  /// 返回根据屏幕高适配后尺寸（单位 dp or pt）
  /// sizePx unit px
  double getHeightPx(double sizePx) {
    return _screenHeight == 0.0
        ? (sizePx / _designD)
        : (sizePx * _screenHeight / (_designH * _designD));
  }

  /// 仅支持纵屏。
  /// returns the font size after adaptation according to the screen density.
  /// 返回根据屏幕宽适配后字体尺寸
  /// fontSize 字体尺寸
  double getSp(double fontSize) {
    if (_screenDensity == 0.0) return fontSize;
    return fontSize * _screenWidth / _designW;
  }

  /// 兼容横/纵屏。
  /// 获取适配后的尺寸，兼容横/纵屏切换，可用于宽，高，字体尺寸适配。
  /// Get the appropriate size, compatible with horizontal/vertical screen switching, can be used for wide, high, font size adaptation.
  double getAdapterSize(double dp) {
    if (_screenWidth == 0 || _screenHeight == 0) return dp;
    return getRatio() * dp;
  }

  /// 适配比率。
  /// Ratio.
  double getRatio() {
    return (_screenWidth > _screenHeight ? _screenHeight : _screenWidth) /
        _designW;
  }

  /// 兼容横/纵屏。
  /// 获取适配后的尺寸，兼容横/纵屏切换，适应宽，高，字体尺寸。
  /// Get the appropriate size, compatible with horizontal/vertical screen switching, can be used for wide, high, font size adaptation.
  static double getAdapterSizeCtx(BuildContext context, double dp) {
    Size size = MediaQuery.of(context).size;
    if (size == Size.zero) return dp;
    return getRatioCtx(context) * dp;
  }

  /// 适配比率。
  /// Ratio.
  static double getRatioCtx(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (size.width > size.height ? size.height : size.width) / _designW;
  }
}


/// 网络

/*
 * dio网络请求失败的回调错误码
 */
class ResultCode {

  //正常返回是1
  static const SUCCESS = 1;

  //异常返回是0
  static const ERROR = 1;

  /// When opening  url timeout, it occurs.
  static const CONNECT_TIMEOUT = -1;

  ///It occurs when receiving timeout.
  static const RECEIVE_TIMEOUT = -2;

  /// When the server response, but with a incorrect status, such as 404, 503...
  static const RESPONSE = -3;
  /// When the request is cancelled, dio will throw a error with this type.
  static const CANCEL = -4;

  /// read the DioError.error if it is not null.
  static const DEFAULT = -5;
}


/*
 * 网络请求管理类
 */
class UUNetWork {

  //写一个单例
  //在 Dart 里，带下划线开头的变量是私有变量
  static UUNetWork _instance;

  static UUNetWork getInstance() {
    if (_instance == null) {
      _instance = UUNetWork();
    }
    return _instance;
  }
  Dio dio = new Dio();

  DioManager() {
    // Set default configs
  /*  dio.options.headers = {
      "version":'2.0.9',
      "Authorization":'_token',
      "Content-Type":'application/x-www-form-urlencoded',
    };*/
   // dio.options.baseUrl = "http://xiaoj.ym.ccex";
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    dio.options.responseType = ResponseType.plain;

    dio.interceptors.add(LogInterceptor(responseBody: GlobalConfig.isDebug)); //是否开启请求日志

   // dio.interceptors.add(CookieManager(CookieJar()));//缓存相关类，具体设置见https://github.com/flutterchina/cookie_jar
  }

  //get请求
  get(String url, Map<String, dynamic> other,Function successCallBack,Function errorCallBack) async {
    _requstHttp(url, successCallBack, 'get', other, errorCallBack);
  }

  //post请求
  post(String url,  Map<String, dynamic> other,Function successCallBack,Function errorCallBack) async {
    _requstHttp(url, successCallBack, "post", other, errorCallBack);
  }
  //head请求 + 正常请求
  postHead(String url,  Map<String, dynamic> other,Map<String, dynamic> head,Function successCallBack,Function errorCallBack) async {
    _requstHttpHead(url, successCallBack, "post", other,head, errorCallBack);
  }
  //head请求 + 正常请求
  getHead(String url,  Map<String, dynamic> other, Map<String, dynamic> head,Function successCallBack,Function errorCallBack) async {
    _requstHttpHead(url, successCallBack, "get", other, head, errorCallBack);
  }

  postHeadBoyd(String url, String json, Map<String, dynamic> other,Map<String, dynamic> head,Function successCallBack,Function errorCallBack) async {

    ///-------------------加密代码
    var encryptString = UUAESUtil.encryptString("0CoJUm6Qyw8W8jud",json);

    var httpJson = UUAESUtil.httpJson(encryptString);

    _requstHttpHeadBoyd(url, httpJson,successCallBack, other,head, errorCallBack);
  }

  _requstHttp(String url, Function successCallBack,
      [String method, Map<String, dynamic> params, Function errorCallBack]) async {
    Response response;
    try {
      if (method == 'get') {
        if (params != null && params.isNotEmpty) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, queryParameters: params);
        } else {
          response = await dio.post(url);
        }
      }
    }on DioError catch(error) {
      // 请求错误处理
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      // 请求超时
      if (error.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
      }
      // 一般服务器错误
      else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
      }

      // debug模式才打印
      if (GlobalConfig.isDebug) {
        print('请求异常: ' + error.toString());
        print('请求异常url: ' + url);
        print('请求头: ' + dio.options.headers.toString());
        print('method: ' + dio.options.method);
      }
      _error(errorCallBack, error.message);
      return '';
    }
    // debug模式打印相关数据
    if (GlobalConfig.isDebug) {
      print('请求url: ' + url);
      print('请求头: ' + dio.options.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }
    //String dataStr = json.encode(response.data);
    var decryptString = UUAESUtil.decryptString("0CoJUm6Qyw8W8jud", response.data);
    successCallBack(decryptString);
   // successCallBack(response.data);
    /*  Map<String, dynamic> dataMap = json.decode(dataStr);
    if (dataMap == null || dataMap['state'] == 0) {
      _error(errorCallBack, '错误码：' + dataMap['errorCode'].toString() + '，' + response.data.toString());
    }else if (successCallBack != null) {
      successCallBack(dataMap);
    }*/
  }





  _error(Function errorCallBack, String error) {
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }



  _requstHttpHead(String url, Function successCallBack,
      [String method, Map<String, dynamic> params, Map<String, dynamic> head,Function errorCallBack]) async {
    Response response;
    try {

      UUtils.showLog("传参：$params");

      if (method == 'get') {

        if (params != null && params.isNotEmpty) {
          response = await dio.get(url, queryParameters: params);
          dio.options.headers = head;
        } else {
          response = await dio.get(url);
          dio.options.headers = head;

        }
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, queryParameters: params);
          dio.options.headers = head;
        } else {
          response = await dio.post(url);
          dio.options.headers = head;
        }
      }
    }on DioError catch(error) {
      // 请求错误处理
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      // 请求超时
      if (error.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
      }
      // 一般服务器错误
      else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
      }

      // debug模式才打印
      if (GlobalConfig.isDebug) {
        print('请求异常: ' + error.toString());
        print(error);
        print('请求异常url: ' + url);
        print('请求头: ' + dio.options.headers.toString());
       // print('method: ' + dio.options.method);
      }
      _error(errorCallBack, error.message);
      return '';
    }
    // debug模式打印相关数据
    if (GlobalConfig.isDebug) {
      print('请求url: ' + url);
      print('请求头: ' + dio.options.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }

    //String dataStr = json.encode(response.data);
    var decryptString = UUAESUtil.decryptString("0CoJUm6Qyw8W8jud", response.data);
    successCallBack(decryptString);
  //  successCallBack(response.data);
  /*  Map<String, dynamic> dataMap = json.decode(dataStr);
    if (dataMap == null || dataMap['state'] == 0) {
      _error(errorCallBack, '错误码：' + dataMap['errorCode'].toString() + '，' + response.data.toString());
    }else if (successCallBack != null) {
      successCallBack(dataMap);
    }*/
  }


  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
            //进度
            print("$count $total");
          });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  }

  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

  _requstHttpHeadBoyd(String url, String json1,Function successCallBack,
      [ Map<String, dynamic> params, Map<String, dynamic> head,Function errorCallBack]) async {
    Response response;
    try {

         UUtils.showLog("请求url:$url");
         UUtils.showLog("传入json:$json1");
         UUtils.showLog("传入参数:$params");
         UUtils.showLog("传入head:$head");
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: json1,options: Options(responseType:  ResponseType.plain));
          dio.options.headers = head;
          dio.options.queryParameters = params;
        } else {
          response = await dio.post(url,data: json1,options: Options(responseType:  ResponseType.plain));
          dio.options.queryParameters = params;
          dio.options.headers = head;
        }

    }on DioError catch(error) {
      // 请求错误处理
      Response errorResponse;

      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      // 请求超时
      if (error.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
      }
      // 一般服务器错误
      else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
      }

      // debug模式才打印
      if (GlobalConfig.isDebug) {
        print('请求异常: ' +  error.message);
        print('请求异常url: ' + url);
        print('请求头: ' + dio.options.headers.toString());
       // print('method: ' + dio.options.method);
      }
      _error(errorCallBack, error.message);
      return '';
    }
    // debug模式打印相关数据
    if (GlobalConfig.isDebug) {
      print('请求url: ' + url);
      print('请求头: ' + dio.options.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }
   // String dataStr = json.encode(response.data);
    var dataStr = UUAESUtil.decryptString("0CoJUm6Qyw8W8jud", response.data);
    successCallBack(dataStr);
 /*     Map<String, dynamic> dataMap = json.decode(dataStr);
    if (dataMap == null || dataMap['state'] == 0) {
      _error(errorCallBack, '错误码：' + dataMap['errorCode'].toString() + '，' + response.data.toString());
    }else if (successCallBack != null) {
      successCallBack(dataMap);
    }*/
  }
}

class GlobalConfig {

  static bool isDebug = true;

}

class UUAppMessage{


  static void startPhone(String phone,String error) async{
    String url='tel:'+phone;
    if(await canLaunch(url)) {
      await launch(url);
    } else {
       UUtils.showMsg(error);
    }

  }

  static void startOtherApp(String str,String error) async {

    String url = "flutter://$str"; //这个url就是由scheme和host组成的 ：scheme://host

    if (await canLaunch(url)) {

     await launch(url);

    } else {

      UUtils.showMsg(error);

   }

   }

  void startLaunchURL(String string,String error)async {

    String url = string;

    if (await canLaunch(url)) {

      await launch(url);

    }else {

      UUtils.showMsg(error);

    }

  }



}

///////////////////////////加密 AES

///////////////////更多:http://guoyz.top/2019/05/03/Flutter%E5%8A%A0%E8%A7%A3%E5%AF%86%E4%B9%8B%E6%AE%87/

///
/// AES加解密封装
/// by guoyuanzhuang@gmail.com  2019.01.19
///
class UUAESUtil{

 static String key = '0CoJUm6Qyw8W8jud';
  ///AES+Base64加密
  static encrypt2Base64(String keyStr, String data){
    Uint8List encrypted = encrypt(keyStr, data);
    String content = new Base64Encoder().convert(encrypted);
//    print("Encrypted: $content");
    return content;
  }

  ///AES+Base64解密
  static decrypt2Base64(String keyStr, String data){
    String newData = data.replaceAll(new RegExp("\n"), "");
    Uint8List decrypted = new Base64Decoder().convert(newData);
    String content = decrypt(keyStr, decrypted);
//    print("decrypted: content");
    return content;
  }

  ///AES加密
  static encrypt(String keyStr, String data){
    final key = new Uint8List.fromList(keyStr.codeUnits);
//  设置加密偏移量IV
//  var iv = new Digest("SHA-256").process(utf8.encode(message)).sublist(0, 16);
//  CipherParameters params = new PaddedBlockCipherParameters(
//      new ParametersWithIV(new KeyParameter(key), iv), null);

    CipherParameters params = new PaddedBlockCipherParameters(
        new KeyParameter(key), null);
    BlockCipher encryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
    encryptionCipher.init(true, params);
    Uint8List encrypted = encryptionCipher.process(utf8.encode(data));
//    print("Encrypted: $encrypted");
    return encrypted;
  }

  ///AES解密
  static decrypt(String keyStr, Uint8List data){
    final key = new Uint8List.fromList(keyStr.codeUnits);
    CipherParameters params = new PaddedBlockCipherParameters(
        new KeyParameter(key), null);
    BlockCipher decryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
    decryptionCipher.init(false, params);
    String decrypted = utf8.decode(decryptionCipher.process(data));
//    print("Decrypted: $decrypted");
    return decrypted;
  }


 ///AES加密
 static String encryptString(String keyStr, String msg){


   final key = new Uint8List.fromList(keyStr.codeUnits);
//  设置加密偏移量IV
//  var iv = new Digest("SHA-256").process(utf8.encode(message)).sublist(0, 16);
//  CipherParameters params = new PaddedBlockCipherParameters(
//      new ParametersWithIV(new KeyParameter(key), iv), null);

   CipherParameters params = new PaddedBlockCipherParameters(
       new KeyParameter(key), null);
   BlockCipher encryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
   encryptionCipher.init(true, params);
   Uint8List encrypted = encryptionCipher.process(utf8.encode(msg));
//    print("Encrypted: $encrypted");
  // var string = String.fromCharCodes(encrypted);
   String content = new Base64Encoder().convert(encrypted);
   return content;
 }


 ///AES解密
 static decryptString(String keyStr, String msg){


   String newData = msg.replaceAll(new RegExp("\n"), "");
   Uint8List decrypted1 = new Base64Decoder().convert(newData);

   final key = new Uint8List.fromList(keyStr.codeUnits);
   CipherParameters params = new PaddedBlockCipherParameters(
       new KeyParameter(key), null);
   //BlockCipher decryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
   BlockCipher decryptionCipher = new PaddedBlockCipher("AES/ECB/PKCS7");
   decryptionCipher.init(false, params);
   String decrypted = utf8.decode(decryptionCipher.process(decrypted1));
//    print("Decrypted: $decrypted");
   return decrypted;
 }

 ///加密参数

 static String httpJson(String json){

    return "{\"d\":\"$json\",\"t\":${UUDateUtil.getNowDateMs()}}";

 }

  ///{"d":"NcKSnPiQyPMay6kZNECiDc7W7OGLeyxcXMPdU/g0mPKj31SVHzxcSodB21CHZ8+K","t":"1599546972158"}



}


/*var map2 = Map<String,dynamic>();


    var map3 = Map<String,dynamic>();
   // map3["Content-Type"] = "application/x-www-form-urlencoded";

    UUNetWork.getInstance().getHead("https://www.ubcoin.pro/generatorr/announcement/getAnnouncemen", map2, map3, (data){
      UUtils.showLog("返回数据成功:$data");
    }, (error){
      UUtils.showLog("返回数据失败$error");
    });





    UUSaveData.saveData("eeeeee","888888");

    UUSaveData.getData("eeeeee", (function){

      UUtils.showLog("获取保存的数据:$function");
    });

    ///NcKSnPiQyPMay6kZNECiDc7W7OGLeyxcXMPdU/g0mPKj31SVHzxcSodB21CHZ8+K
    var decryptString = UUAESUtil.decryptString("0CoJUm6Qyw8W8jud", "NcKSnPiQyPMay6kZNECiDc7W7OGLeyxcXMPdU/g0mPKj31SVHzxcSodB21CHZ8+K");

    UUtils.showLog("解密结果:$decryptString");

    var encryptString = UUAESUtil.encryptString("0CoJUm6Qyw8W8jud",decryptString);

    UUtils.showLog("加密结果:$encryptString");
*/


 class UUJsonBeanFormat{


   Map toJson(){
     //dynamic
     return null;

  }


}

// ignore: must_be_immutable
class UUBaseDialog extends Dialog{


  @override
  Widget build(BuildContext context){


    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        body: getView(context),
        backgroundColor: Colors.transparent,
      ),

    );
  }




  Widget getView(BuildContext context){

    return null;
  }

}


class FlutterTextField extends StatefulWidget{


  /*
   *
   * 默认设置的EditText
   *
   * 使用前请手动请导入你的[眼睛图片]素材和[关闭图片]素材
   *
   * 关闭图片文件名: uu_close
   * 睁眼图片文件名: uu_zhenyan
   * 闭眼图片文件名: uu_biyan
   *
   * FlutterTextField(

                  width: double.infinity, //宽度
                  height: UUScreenUtil.xp2dpH(context, 25), //高度
                  textSize: UUScreenUtil.xp2sp(context, 16), //字体大小
                  isShowPwd: true, //是否密码显示
                  hintText: "请输入您的账号",//默认提示文字
                  hintTextColor: 0x666666,//默认提示文字颜色
                  hintTextSize: UUScreenUtil.xp2sp(context, 16),//默认提示文字大小
                  textColor: 0x000000, //字体颜色
                  imgCloseMargin: EdgeInsets.fromLTRB(0, 0, UUScreenUtil.xp2dpW(context, 10), 0), //关闭图片和眼睛图片的边距


                )
   *
   *
   *
   */

  //默认text
   final String text ;
   //默认text大小
   final double textSize ;
   //默认text颜色
   final int textColor ;
   //提示text
   final String hintText;
   //提示text大小
   final double hintTextSize;
   //提示Text颜色
   final int hintTextColor;
   //是否显示底线
   final bool line ;
   //输入类型:密码、数字、文本
   final TextInputType textInputType;
   //内边距
   final EdgeInsets padding;
   //外边距
   final EdgeInsets margin;

   //是否自动获取焦点
   final bool autoFocus;
   //是否是密码输入类型
   final bool isShowPwd;
   //是否可以输入中文
   final bool isZh;
   //默认倒计时最大值
   final int countdown;
   //宽
   final double width;
   //高
   final double height;
   //显示最大数值
   final int maxLength;
   //文本输入回调
   final Function(String str) funMsg;
   //发送验证码时的点击按钮回调
   final Function getVCode;
   ///注意必须返回数值 类型为String
   /// 格式是:
   ///      getVCode:(){
   ///
   ///        你要操作的代码=成功{
   ///
   ///         return null; //返回null代表成功，倒计时开始运行
   ///        }
   ///
   ///        你要操作的代码=失败{
   ///
   ///         return "请求失败,请重试!";//返回文字代表失败，倒计时不运作
   ///
   ///        }
   ///
   ///      }
   ///
   //获取验证码的字体颜色
   int boxTextColor;
   //获取验证码的背景颜色
   int boxBackColor;
   //获取验证码的边框颜色
   int boxLineColor;

   //获取验证码的字体颜色
   int boxFalseTextColor;
   //获取验证码的背景颜色
   int boxFalseBackColor;
   //获取验证码的边框颜色
   int boxFalseLineColor;


   //获取验证码的边框圆角
   double boxRadius;


   //获取验证码的边框宽度(不显示设置为0即可)
   double boxLineWidth;
   //按钮宽
   double boxWidth;
   //按钮高
   double boxHeight;
   //验证码字体的大小
   double boxTextSize;
   //按钮验证码边距
   EdgeInsets boxMargin;
   //图片边距
   EdgeInsets imgCloseMargin;
   //眼睛边距
   EdgeInsets imgEyyMargin;


   FlutterTextField({
     this.width  :100,
     this.height : 40,
      this.text :"",
      this.textSize:12,
      this.textColor:0x10202f,
      this.hintText,
      this.hintTextSize:12,
      this.hintTextColor:0x666666,
      this.line:false,
      this.countdown:60,
      this.maxLength:16,
      this.autoFocus:false,
      this.isShowPwd:false,
      this.textInputType:TextInputType.text,
      this.funMsg,
      this.getVCode,
      this.isZh:false,
      this.padding,
      this.margin,

      this.boxTextColor:0x0533a8,
      this.boxBackColor:0xffffff,
      this.boxLineColor:0x0533a8,
      this.boxFalseTextColor:0x999999,
      this.boxFalseBackColor:0xffffff,
      this.boxFalseLineColor:0x999999,

      this.boxRadius:3,
      this.boxLineWidth:1,
      this.boxWidth:90,
      this.boxHeight:24,
      this.boxMargin,
      this.boxTextSize:10,
     this.imgCloseMargin,
     this.imgEyyMargin,
    });

   @override
   _MyTextFieldState createState() => _MyTextFieldState();

}


class _MyTextFieldState extends State<FlutterTextField> {
  bool _isShowDelete = true; //是否显示删除
  bool _isShowPwd = false;
  bool _isAvailableGetVCode = true; //是否可以获取验证码，默认为`false`
  String _verifyStr = '获取验证码';
  TextEditingController controller;

  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TextEditingController.fromValue(TextEditingValue(text: widget.text));
    controller.addListener(() {
      setState(() {
        _isShowDelete = controller.text.isEmpty;
      });
    });
    _seconds = widget.countdown;
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      _isAvailableGetVCode = false;
      _verifyStr = '已发送(${_seconds}s)';
      UUtils.showLog(_verifyStr);
      if (_seconds == 0) {
        _verifyStr = '重新获取';
        _isAvailableGetVCode = true;
        _seconds = widget.countdown;
        _cancelTimer();
      }
      setState(() {});
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }


  @override
  // ignore: must_call_super
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      height: widget.height,
      width: widget.width,
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          SizedBox(
            child: TextField(
              controller: controller,
              maxLength: widget.maxLength,
              autofocus: widget.autoFocus,
              keyboardType: widget.textInputType,
              onChanged: (s){
                widget.funMsg(s);
              },
              style: TextStyle(color: UUtils.getColor(widget.textColor),fontSize: widget.textSize),
              obscureText: widget.isShowPwd ? !_isShowPwd : false,
              // 数字、手机号限制格式为0到9(白名单)， 密码限制不包含汉字（黑名单）
              inputFormatters: (widget.textInputType == TextInputType.number ||
                  widget.textInputType == TextInputType.phone)
                  ? [WhitelistingTextInputFormatter(RegExp("[0-9]"))]
                  : widget.isZh?/**/null:[BlacklistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]"))],
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: !(widget.line)?InputBorder.none:UnderlineInputBorder(),
                hintStyle:
                TextStyle(color: UUtils.getColor(widget.hintTextColor), fontSize: widget.hintTextSize),
                counterText: '',
                focusedBorder: !(widget.line)?InputBorder.none:UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: UUtils.getColor(0x999999),
                      width: 0.8,
                    )),
                enabledBorder: !(widget.line)?InputBorder.none:UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: UUtils.getColor(0x666666),
                      width: 0.8,
                    )),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /**
               * 控制child是否显示
               *
                  当offstage为true，控件隐藏； 当offstage为false，显示；
                  当Offstage不可见的时候，如果child有动画等，需要手动停掉，Offstage并不会停掉动画等操作。
                  const Offstage({ Key key, this.offstage = true, Widget child })
               */
              Offstage(
                  offstage: _isShowDelete,
                  child: Container(
                  margin: widget.imgCloseMargin,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Image.asset(
                        UUtils.getImagePath('uu_close'),
                        width: 18.0,
                        height: 18.0,
                      ),
                      onTap: () {
                        setState(() {
                          controller.text = "";
                        });
                      },
                    ),
                  )),
              Offstage(
                offstage: !widget.isShowPwd,
                child: Container(
                  margin:widget.imgEyyMargin,
                  child: InkWell(
                    child: Image.asset(
                      _isShowPwd
                          ? UUtils.getImagePath('uu_zhenyan')
                          : UUtils.getImagePath('uu_biyan'),
                      width: 18.0,
                      height: 18.0,
                    ),
                    onTap: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  ),
                ),
              ),
              Offstage(
                  offstage: widget.getVCode == null,
                  child: Container(
                      margin:widget.boxMargin,
                      width: widget.boxWidth,
                      height: widget.boxHeight,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(widget.boxRadius)),
                        color:_isAvailableGetVCode
                            ? UUtils.getColor(widget.boxBackColor)
                            : UUtils.getColor(widget.boxFalseBackColor),
                          border: new Border.all(
                              color: _isAvailableGetVCode
                                  ? UUtils.getColor(widget.boxLineColor)
                                  : UUtils.getColor(widget.boxFalseLineColor),
                              width: widget.boxLineWidth)),
                      child: FlatButton(
                        onPressed: _seconds == widget.countdown
                            ? () {
                          if (widget.getVCode() == null) {
                            _startTimer();
                          }else{
                            setState(() {
                              _verifyStr = widget.getVCode();
                            });
                          }
                        }
                            : null,
                        child: Text(
                          '$_verifyStr',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: widget.boxTextSize,
                            color: _isAvailableGetVCode
                                ? UUtils.getColor(widget.boxTextColor)
                                : UUtils.getColor(widget.boxFalseTextColor),
                          ),
                        ),
                      )))
            ],
          )
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////压缩部分

//mqtt,该类为单例模式!
class MQTTContent{


  // 工厂模式
  factory MQTTContent() =>_getInstance();
  static MQTTContent get instance => _getInstance();
  static MQTTContent _instance;
  MQTTContent._internal() {
    // 初始化
  }
  static MQTTContent _getInstance() {
    if (_instance == null) {
      _instance = new MQTTContent._internal();
    }
    return _instance;
  }

// void onConnected() {
//     // 连接成功
//     print('连接成功');
//   }
//
//   void onDisconnected() {
//     // 连接断开
//     print('连接断开');
//   }
//
//   void onSubscribed(String topic) {
//     // 订阅主题成功
//     print('订阅主题成功: $topic');
//   }
//
//   void onSubscribeFail(String topic) {
//     // 订阅主题失败
//     print('订阅主题失败 $topic');
//   }
//
//   void onUnsubscribed(String topic) {
// // 成功取消订阅
//     print('成功取消订阅: $topic');
//   }
//
//   void pong() {
//     // 收到 PING 响应
//     print('收到 PING 响应');
//   }

   Function onConnected;
   Function onDisconnected;
   Function(String) onUnsubscribed;
   Function(String) onSubscribed;
   Function(String) onSubscribeFail;
   Function pong;
  MqttServerClient client;

 void mqttStart(String url,String clientId,int post,String data,
     )async{
   client =
   new MqttServerClient.withPort(url, clientId, post);
   client.logging(on: true);
   client.keepAlivePeriod = 20;
   client.onConnected = (){
     if(onConnected != null){
       onConnected();
     }
   };
   client.onDisconnected = (){
     if(onDisconnected!= null)
     {onDisconnected();
     }
   };
   client.onUnsubscribed = (data){
     if(onUnsubscribed!= null)
     {
       onUnsubscribed(data);
     }
   };
   client.onSubscribed = (data){
     if(onSubscribed!= null){
       onSubscribed(data);
     }
   };
   client.onSubscribeFail = (data){
     if(onSubscribeFail!= null){
       onSubscribeFail(data);
     }

   };
   client.pongCallback = (){
     if(pong != null){
       pong();
     }
   };

   var connMsg = MqttConnectMessage()
       .withClientIdentifier(clientId)
       .authenticateAs("T|" + clientId, "\"R|" + data + "\"")
       .keepAliveFor(60)
       .withWillTopic('willtopic')
       .withWillMessage('Will message')
       .startClean()
       .withWillQos(MqttQos.atLeastOnce);

   client.connectionMessage = connMsg;

   try {
     await client.connect();
   } catch (e) {
     print('链接异常: $e');
     client.disconnect();
   }

   client.updates.listen((event) {
     ///监听服务器发来的信息

     MqttPublishMessage message = event[0].payload;

     ///服务器返回的数据信息
     final pt =
     MqttPublishPayload.bytesToStringAsString(message.payload.message);
     // print('服务器返回的数据信息:$pt 订阅消息: ${event[0].topic}>');

     // var res = String.fromCharCodes(base64Decode(pt));
     var res = Base64Util.base64Decoder(pt);

     List<int> str = GZipDecoder().decodeBytes(res);

     var res1 = String.fromCharCodes(str);

     print('服务器返回的数据信息-----$res1');
   });

   ///设置public监听，当我们调用 publishMessage 时，会告诉你是都发布成功
   client.published.listen((MqttPublishMessage message) {
     // print('返回数据-----$message');
   });


   client.subscribe("tradingCenter/dealAmountRank/", MqttQos.atLeastOnce);

 }

 //订阅
 void subscribe(String address){
   client.subscribe(address, MqttQos.atLeastOnce);
 }
 //取消订阅
 void unSubscribe(String address){
   client.unsubscribe(address);

 }
 //断开连接
void disconnect(){
  client.disconnect();
}


//连接成功回调
void setOnConnectedListener(Function onConnected){
   this.onConnected = onConnected;
}
//连接断开回调
  void setOnDisconnectedListener(Function onDisconnected){
    this.onDisconnected = onDisconnected;
  }
//订阅主题成功回调
  void setOnUnsubscribedListener(Function onUnsubscribed){
    this.onUnsubscribed = onUnsubscribed;
  }
// 订阅主题失败
  void setOnSubscribedListener(Function onSubscribed){
    this.onSubscribed = onSubscribed;
  }
// 成功取消订阅
  void setOnSubscribeFailListener(Function onSubscribeFail){
    this.onSubscribeFail = onSubscribeFail;
  }
//收到 PING 响应
  void setPongListener(Function pong){
    this.pong = pong;
  }
}





//gzip解压

/// Decompress data with the gzip format decoder.
class GZipDecoder {
  static const int SIGNATURE = 0x8b1f;
  static const int DEFLATE = 8;
  static const int FLAG_TEXT = 0x01;
  static const int FLAG_HCRC = 0x02;
  static const int FLAG_EXTRA = 0x04;
  static const int FLAG_NAME = 0x08;
  static const int FLAG_COMMENT = 0x10;

  String gzip_jieya(String msg){

    var decode = base64.decode(msg);

    var decodeBytes1 = decodeBytes(decode);

    var string = new String.fromCharCodes(decodeBytes1);

    return string;

  }

  String gzip_yasuo(String msg){

   // var encode1 = GZipEncoder().encode(decode);
   // var string = new String.fromCharCodes(encode1);

   // return string;

  }

  List<int> decodeBytes(List<int> data, {bool verify = false}) {

    return decodeBuffer(InputStream(data), verify: verify);
  }

  void decodeStream(InputStreamBase input, dynamic output) {
    _readHeader(input);
    Inflate.stream(input, output);
  }

  List<int> decodeBuffer(InputStreamBase input, {bool verify = false}) {
    _readHeader(input);

    // Inflate
    final buffer = Inflate.buffer(input).getBytes();

    if (verify) {
      var crc = input.readUint32();
      var computedCrc = getCrc32(buffer);
      if (crc != computedCrc) {
        throw ArchiveException('Invalid CRC checksum');
      }

      var size = input.readUint32();
      if (size != buffer.length) {
        throw ArchiveException('Size of decompressed file not correct');
      }
    }

    return buffer;
  }

  void _readHeader(InputStreamBase input) {
    // The GZip format has the following structure:
    // Offset   Length   Contents
    // 0      2 bytes  magic header  0x1f, 0x8b (\037 \213)
    // 2      1 byte   compression method
    //                  0: store (copied)
    //                  1: compress
    //                  2: pack
    //                  3: lzh
    //                  4..7: reserved
    //                  8: deflate
    // 3      1 byte   flags
    //                  bit 0 set: file probably ascii text
    //                  bit 1 set: continuation of multi-part gzip file, part number present
    //                  bit 2 set: extra field present
    //                  bit 3 set: original file name present
    //                  bit 4 set: file comment present
    //                  bit 5 set: file is encrypted, encryption header present
    //                  bit 6,7:   reserved
    // 4      4 bytes  file modification time in Unix format
    // 8      1 byte   extra flags (depend on compression method)
    // 9      1 byte   OS type
    // [
    //        2 bytes  optional part number (second part=1)
    // ]?
    // [
    //        2 bytes  optional extra field length (e)
    //       (e)bytes  optional extra field
    // ]?
    // [
    //          bytes  optional original file name, zero terminated
    // ]?
    // [
    //          bytes  optional file comment, zero terminated
    // ]?
    // [
    //       12 bytes  optional encryption header
    // ]?
    //          bytes  compressed data
    //        4 bytes  crc32
    //        4 bytes  uncompressed input size modulo 2^32

    final signature = input.readUint16();
    if (signature != SIGNATURE) {
      throw ArchiveException('Invalid GZip Signature');
    }

    final compressionMethod = input.readByte();
    if (compressionMethod != DEFLATE) {
      throw ArchiveException('Invalid GZip Compression Methos');
    }

    final flags = input.readByte();
    /*int fileModTime =*/ input.readUint32();
    /*int extraFlags =*/ input.readByte();
    /*int osType =*/ input.readByte();

    if (flags & FLAG_EXTRA != 0) {
      final t = input.readUint16();
      input.readBytes(t);
    }

    if (flags & FLAG_NAME != 0) {
      input.readString();
    }

    if (flags & FLAG_COMMENT != 0) {
      input.readString();
    }

    // just throw away for now
    if (flags & FLAG_HCRC != 0) {
      input.readUint16();
    }
  }
}



//gzip压缩
class GZipEncoder {
  static const int SIGNATURE = 0x8b1f;
  static const int DEFLATE = 8;
  static const int FLAG_TEXT = 0x01;
  static const int FLAG_HCRC = 0x02;
  static const int FLAG_EXTRA = 0x04;
  static const int FLAG_NAME = 0x08;
  static const int FLAG_COMMENT = 0x10;

  // enum OperatingSystem
  static const int OS_FAT = 0;
  static const int OS_AMIGA = 1;
  static const int OS_VMS = 2;
  static const int OS_UNIX = 3;
  static const int OS_VM_CMS = 4;
  static const int OS_ATARI_TOS = 5;
  static const int OS_HPFS = 6;
  static const int OS_MACINTOSH = 7;
  static const int OS_Z_SYSTEM = 8;
  static const int OS_CP_M = 9;
  static const int OS_TOPS_20 = 10;
  static const int OS_NTFS = 11;
  static const int OS_QDOS = 12;
  static const int OS_ACORN_RISCOS = 13;
  static const int OS_UNKNOWN = 255;

  List<int> encode(dynamic data, {int level, dynamic output}) {
    dynamic output_stream = output ?? OutputStream();

    // The GZip format has the following structure:
    // Offset   Length   Contents
    // 0      2 bytes  magic header  0x1f, 0x8b (\037 \213)
    // 2      1 byte   compression method
    //                  0: store (copied)
    //                  1: compress
    //                  2: pack
    //                  3: lzh
    //                  4..7: reserved
    //                  8: deflate
    // 3      1 byte   flags
    //                  bit 0 set: file probably ascii text
    //                  bit 1 set: continuation of multi-part gzip file, part number present
    //                  bit 2 set: extra field present
    //                  bit 3 set: original file name present
    //                  bit 4 set: file comment present
    //                  bit 5 set: file is encrypted, encryption header present
    //                  bit 6,7:   reserved
    // 4      4 bytes  file modification time in Unix format
    // 8      1 byte   extra flags (depend on compression method)
    // 9      1 byte   OS type
    // [
    //        2 bytes  optional part number (second part=1)
    // ]?
    // [
    //        2 bytes  optional extra field length (e)
    //       (e)bytes  optional extra field
    // ]?
    // [
    //          bytes  optional original file name, zero terminated
    // ]?
    // [
    //          bytes  optional file comment, zero terminated
    // ]?
    // [
    //       12 bytes  optional encryption header
    // ]?
    //          bytes  compressed data
    //        4 bytes  crc32
    //        4 bytes  uncompressed input size modulo 2^32

    output_stream.writeUint16(SIGNATURE);
    output_stream.writeByte(DEFLATE);

    var flags = 0;
    var fileModTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var extraFlags = 0;
    var osType = OS_UNKNOWN;

    output_stream.writeByte(flags);
    output_stream.writeUint32(fileModTime);
    output_stream.writeByte(extraFlags);
    output_stream.writeByte(osType);

    Deflate deflate;
    if (data is List<int>) {
      deflate = Deflate(data, level: level, output: output_stream);
    } else {
      deflate = Deflate.buffer(data as InputStreamBase, level: level, output: output_stream);
    }

    if (!(output_stream is OutputStream)) {
      deflate.finish();
    }

    output_stream.writeUint32(deflate.crc32);

    output_stream.writeUint32(data.length);

    if (output_stream is OutputStream) {
      return output_stream.getBytes();
    } else {
      return null;
    }
  }
}

const int LITTLE_ENDIAN = 0;
const int BIG_ENDIAN = 1;


abstract class InputStreamBase {
  ///  The current read position relative to the start of the buffer.
  int get position;

  /// How many bytes are left in the stream.
  int get length;

  /// Is the current position at the end of the stream?
  bool get isEOS;

  /// Reset to the beginning of the stream.
  void reset();

  /// Rewind the read head of the stream by the given number of bytes.
  void rewind([int length = 1]);

  /// Move the read position by [count] bytes.
  void skip(int length);

  /// Read [count] bytes from an [offset] of the current read position, without
  /// moving the read position.
  InputStream peekBytes(int count, [int offset = 0]);

  /// Read a single byte.
  int readByte();

  /// Read [count] bytes from the stream.
  InputStream readBytes(int count);

  /// Read a null-terminated string, or if [len] is provided, that number of
  /// bytes returned as a string.
  String readString({int size, bool utf8});

  /// Read a 16-bit word from the stream.
  int readUint16();

  /// Read a 24-bit word from the stream.
  int readUint24();

  /// Read a 32-bit word from the stream.
  int readUint32();

  /// Read a 64-bit word form the stream.
  int readUint64();

  Uint8List toUint8List();
}

/// A buffer that can be read as a stream of bytes
class InputStream extends InputStreamBase {
  List<int> buffer;
  int offset;
  int start;
  int byteOrder;

  /// Create a InputStream for reading from a List<int>
  InputStream(dynamic data,
      {this.byteOrder = LITTLE_ENDIAN, int start = 0, int length})
      : buffer = data is TypedData
      ? Uint8List.view(data.buffer, data.offsetInBytes, data.lengthInBytes)
      : data is List<int>
      ? data
      : List<int>.from(data as Iterable<dynamic>),
        offset = start,
        start = start {
    _length = length ?? buffer.length;
  }

  /// Create a copy of [other].
  InputStream.from(InputStream other)
      : buffer = other.buffer,
        offset = other.offset,
        start = other.start,
        _length = other._length,
        byteOrder = other.byteOrder;

  ///  The current read position relative to the start of the buffer.
  @override
  int get position => offset - start;

  /// How many bytes are left in the stream.
  @override
  int get length => _length - (offset - start);

  /// Is the current position at the end of the stream?
  @override
  bool get isEOS => offset >= (start + _length);

  /// Reset to the beginning of the stream.
  @override
  void reset() {
    offset = start;
  }

  /// Rewind the read head of the stream by the given number of bytes.
  @override
  void rewind([int length = 1]) {
    offset -= length;
    if (offset < 0) {
      offset = 0;
    }
  }

  /// Access the buffer relative from the current position.
  int operator [](int index) => buffer[offset + index];

  /// Return a InputStream to read a subset of this stream.  It does not
  /// move the read position of this stream.  [position] is specified relative
  /// to the start of the buffer.  If [position] is not specified, the current
  /// read position is used. If [length] is not specified, the remainder of this
  /// stream is used.
  InputStream subset([int position, int length]) {
    if (position == null) {
      position = offset;
    } else {
      position += start;
    }

    if (length == null || length < 0) {
      length = _length - (position - start);
    }

    return InputStream(buffer,
        byteOrder: byteOrder, start: position, length: length);
  }

  /// Returns the position of the given [value] within the buffer, starting
  /// from the current read position with the given [offset].  The position
  /// returned is relative to the start of the buffer, or -1 if the [value]
  /// was not found.
  int indexOf(int value, [int offset = 0]) {
    for (var i = this.offset + offset, end = this.offset + length;
    i < end; ++i) {
      if (buffer[i] == value) {
        return i - start;
      }
    }
    return -1;
  }

  /// Read [count] bytes from an [offset] of the current read position, without
  /// moving the read position.
  @override
  InputStream peekBytes(int count, [int offset = 0]) {
    return subset((this.offset - start) + offset, count);
  }

  /// Move the read position by [count] bytes.
  @override
  void skip(int count) {
    offset += count;
  }

  /// Read a single byte.
  @override
  int readByte() {
    return buffer[offset++];
  }

  /// Read [count] bytes from the stream.
  @override
  InputStream readBytes(int count) {
    final bytes = subset(offset - start, count);
    offset += bytes.length;
    return bytes;
  }

  /// Read a null-terminated string, or if [len] is provided, that number of
  /// bytes returned as a string.
  @override
  String readString({int size, bool utf8 = true}) {
    if (size == null) {
      final codes = <int>[];
      if (isEOS) {
        return '';
      }
      while (!isEOS) {
        final c = readByte();
        if (c == 0) {
          return utf8
              ? Utf8Decoder().convert(codes)
              : String.fromCharCodes(codes);
        }
        codes.add(c);
      }
      throw ArchiveException(
          'EOF reached without finding string terminator');
    }

    final s = readBytes(size);
    final bytes = s.toUint8List();
    final str = utf8
        ? Utf8Decoder().convert(bytes)
        : String.fromCharCodes(bytes);
    return str;
  }

  /// Read a 16-bit word from the stream.
  @override
  int readUint16() {
    final b1 = buffer[offset++] & 0xff;
    final b2 = buffer[offset++] & 0xff;
    if (byteOrder == BIG_ENDIAN) {
      return (b1 << 8) | b2;
    }
    return (b2 << 8) | b1;
  }

  /// Read a 24-bit word from the stream.
  @override
  int readUint24() {
    final b1 = buffer[offset++] & 0xff;
    final b2 = buffer[offset++] & 0xff;
    final b3 = buffer[offset++] & 0xff;
    if (byteOrder == BIG_ENDIAN) {
      return b3 | (b2 << 8) | (b1 << 16);
    }
    return b1 | (b2 << 8) | (b3 << 16);
  }

  /// Read a 32-bit word from the stream.
  @override
  int readUint32() {
    final b1 = buffer[offset++] & 0xff;
    final b2 = buffer[offset++] & 0xff;
    final b3 = buffer[offset++] & 0xff;
    final b4 = buffer[offset++] & 0xff;
    if (byteOrder == BIG_ENDIAN) {
      return (b1 << 24) | (b2 << 16) | (b3 << 8) | b4;
    }
    return (b4 << 24) | (b3 << 16) | (b2 << 8) | b1;
  }

  /// Read a 64-bit word form the stream.
  @override
  int readUint64() {
    final b1 = buffer[offset++] & 0xff;
    final b2 = buffer[offset++] & 0xff;
    final b3 = buffer[offset++] & 0xff;
    final b4 = buffer[offset++] & 0xff;
    final b5 = buffer[offset++] & 0xff;
    final b6 = buffer[offset++] & 0xff;
    final b7 = buffer[offset++] & 0xff;
    final b8 = buffer[offset++] & 0xff;
    if (byteOrder == BIG_ENDIAN) {
      return (b1 << 56) |
      (b2 << 48) |
      (b3 << 40) |
      (b4 << 32) |
      (b5 << 24) |
      (b6 << 16) |
      (b7 << 8) |
      b8;
    }
    return (b8 << 56) |
    (b7 << 48) |
    (b6 << 40) |
    (b5 << 32) |
    (b4 << 24) |
    (b3 << 16) |
    (b2 << 8) |
    b1;
  }

  @override
  Uint8List toUint8List() {
    var len = length;
    if (buffer is Uint8List) {
      final b = buffer as Uint8List;
      if ((offset + len) > b.length) {
        len = b.length - offset;
      }
      final bytes =
      Uint8List.view(b.buffer, b.offsetInBytes + offset, len);
      return bytes;
    }
    var end = offset + len;
    if (end > buffer.length) {
      end = buffer.length;
    }
    return Uint8List.fromList(buffer.sublist(offset, end));
  }

  int _length;
}



abstract class OutputStreamBase {
  int get length;

  /// Write a byte to the output stream.
  void writeByte(int value);

  /// Write a set of bytes to the output stream.
  void writeBytes(List<int> bytes, [int len]);

  /// Write an InputStream to the output stream.
  void writeInputStream(InputStreamBase bytes);

  /// Write a 16-bit word to the output stream.
  void writeUint16(int value);

  /// Write a 32-bit word to the end of the buffer.
  void writeUint32(int value);
}

class OutputStream extends OutputStreamBase {
  int _length;
  final int byteOrder;

  /// Create a byte buffer for writing.
  OutputStream({int size = _BLOCK_SIZE, this.byteOrder = LITTLE_ENDIAN})
      : _buffer = Uint8List(size ?? _BLOCK_SIZE),
        _length = 0;

  @override
  int get length => _length;

  set length(int l) => _length = l;

  /// Get the resulting bytes from the buffer.
  List<int> getBytes() {
    return Uint8List.view(_buffer.buffer, 0, length);
  }

  /// Clear the buffer.
  void clear() {
    _buffer = Uint8List(_BLOCK_SIZE);
    length = 0;
  }

  /// Reset the buffer.
  void reset() {
    length = 0;
  }

  /// Write a byte to the end of the buffer.
  @override
  void writeByte(int value) {
    if (length == _buffer.length) {
      _expandBuffer();
    }
    _buffer[length++] = value & 0xff;
  }

  /// Write a set of bytes to the end of the buffer.
  @override
  void writeBytes(List<int> bytes, [int len]) {
    len ??= bytes.length;

    while (length + len > _buffer.length) {
      _expandBuffer((length + len) - _buffer.length);
    }
    _buffer.setRange(length, length + len, bytes);
    length += len;
  }

  @override
  void writeInputStream(InputStreamBase stream) {
    while (length + stream.length > _buffer.length) {
      _expandBuffer((length + stream.length) - _buffer.length);
    }

    if (stream is InputStream) {
      _buffer.setRange(
          length, length + stream.length, stream.buffer, stream.offset);
    } else {
      var bytes = stream.toUint8List();
      _buffer.setRange(length, length + stream.length, bytes, 0);
    }
    length += stream.length;
  }

  /// Write a 16-bit word to the end of the buffer.
  @override
  void writeUint16(int value) {
    if (byteOrder == BIG_ENDIAN) {
      writeByte((value >> 8) & 0xff);
      writeByte((value) & 0xff);
      return;
    }
    writeByte((value) & 0xff);
    writeByte((value >> 8) & 0xff);
  }

  /// Write a 32-bit word to the end of the buffer.
  @override
  void writeUint32(int value) {
    if (byteOrder == BIG_ENDIAN) {
      writeByte((value >> 24) & 0xff);
      writeByte((value >> 16) & 0xff);
      writeByte((value >> 8) & 0xff);
      writeByte((value) & 0xff);
      return;
    }
    writeByte((value) & 0xff);
    writeByte((value >> 8) & 0xff);
    writeByte((value >> 16) & 0xff);
    writeByte((value >> 24) & 0xff);
  }

  /// Return the subset of the buffer in the range [start:end].
  ///
  /// If [start] or [end] are < 0 then it is relative to the end of the buffer.
  /// If [end] is not specified (or null), then it is the end of the buffer.
  /// This is equivalent to the python list range operator.
  List<int> subset(int start, [int end]) {
    if (start < 0) {
      start = (length) + start;
    }

    if (end == null) {
      end = length;
    } else if (end < 0) {
      end = length + end;
    }

    return Uint8List.view(_buffer.buffer, start, end - start);
  }

  /// Grow the buffer to accommodate additional data.
  void _expandBuffer([int required]) {
    var blockSize = _BLOCK_SIZE;
    if (required != null) {
      if (required > blockSize) {
        blockSize = required;
      }
    }
    final newLength = (_buffer.length + blockSize) * 2;
    final newBuffer = Uint8List(newLength);
    newBuffer.setRange(0, _buffer.length, _buffer);
    _buffer = newBuffer;
  }

  static const _BLOCK_SIZE = 0x8000; // 32k block-size
  Uint8List _buffer;
}



class Deflate {
  // enum CompressionLevel
  static const int DEFAULT_COMPRESSION = 6;
  static const int BEST_COMPRESSION = 9;
  static const int BEST_SPEED = 1;
  static const int NO_COMPRESSION = 0;

  // enum FlushMode
  static const int NO_FLUSH = 0;
  static const int PARTIAL_FLUSH = 1;
  static const int SYNC_FLUSH = 2;
  static const int FULL_FLUSH = 3;
  static const int FINISH = 4;

  int crc32;

  Deflate(List<int> bytes,
      {int level = DEFAULT_COMPRESSION, int flush = FINISH, dynamic output})
      : _input = InputStream(bytes),
        _output = output ?? OutputStream() {
    crc32 = 0;
    _init(level);
    _deflate(flush);
  }

  Deflate.buffer(this._input,
      {int level = DEFAULT_COMPRESSION, int flush = FINISH, dynamic output})
      : _output = output ?? OutputStream() {
    crc32 = 0;
    _init(level);
    _deflate(flush);
  }

  void finish() {
    _flushPending();
  }

  /// Get the resulting compressed bytes.
  List<int> getBytes() {
    _flushPending();
    return _output.getBytes() as List<int>;
  }

  /// Get the resulting compressed bytes without storing the resulting data to
  /// minimize memory usage.
  List<int> takeBytes() {
    _flushPending();
    final bytes = _output.getBytes() as List<int>;
    _output.clear();
    return bytes;
  }

  /// Add more data to be deflated.
  void addBytes(List<int> bytes, {int flush = FINISH}) {
    _input = InputStream(bytes);
    _deflate(flush);
  }

  /// Add more data to be deflated.
  void addBuffer(InputStream buffer, {int flush = FINISH}) {
    _input = buffer;
    _deflate(flush);
  }

  /// Compression level used (1..9)
  int get level => _level;

  /// Initialize the deflate structures for the given parameters.
  void _init(int level,
      {int method = Z_DEFLATED,
        int windowBits = MAX_WBITS,
        int memLevel = DEF_MEM_LEVEL,
        int strategy = Z_DEFAULT_STRATEGY}) {
    if (level == null || level == Z_DEFAULT_COMPRESSION) {
      level = 6;
    }

    _config = _getConfig(level);

    if (memLevel < 1 ||
        memLevel > MAX_MEM_LEVEL ||
        method != Z_DEFLATED ||
        windowBits < 9 ||
        windowBits > 15 ||
        level < 0 ||
        level > 9 ||
        strategy < 0 ||
        strategy > Z_HUFFMAN_ONLY) {
      throw ArchiveException('Invalid Deflate parameter');
    }

    _dynamicLengthTree = Uint16List(HEAP_SIZE * 2);
    _dynamicDistTree = Uint16List((2 * D_CODES + 1) * 2);
    _bitLengthTree = Uint16List((2 * BL_CODES + 1) * 2);

    _windowBits = windowBits;
    _windowSize = 1 << _windowBits;
    _windowMask = _windowSize - 1;

    _hashBits = memLevel + 7;
    _hashSize = 1 << _hashBits;
    _hashMask = _hashSize - 1;
    _hashShift = ((_hashBits + MIN_MATCH - 1) ~/ MIN_MATCH);

    _window = Uint8List(_windowSize * 2);
    _prev = Uint16List(_windowSize);
    _head = Uint16List(_hashSize);

    _litBufferSize = 1 << (memLevel + 6); // 16K elements by default

    // We overlay pending_buf and d_buf+l_buf. This works since the average
    // output size for (length,distance) codes is <= 24 bits.
    _pendingBuffer = Uint8List(_litBufferSize * 4);
    _pendingBufferSize = _litBufferSize * 4;

    _dbuf = _litBufferSize;
    _lbuf = (1 + 2) * _litBufferSize;

    _level = level;

    _strategy = strategy;
    _method = method;

    _pending = 0;
    _pendingOut = 0;

    _status = BUSY_STATE;

    _lastFlush = NO_FLUSH;

    crc32 = 0;

    _trInit();
    _lmInit();
  }

  /// Compress the current input buffer.
  int _deflate(int flush) {
    if (flush > FINISH || flush < 0) {
      throw ArchiveException('Invalid Deflate Parameter');
    }

    _lastFlush = flush;

    // Flush as much pending output as possible
    if (_pending != 0) {
      // Make sure there is something to do and avoid duplicate consecutive
      // flushes. For repeated and useless calls with FINISH, we keep
      // returning Z_STREAM_END instead of Z_BUFF_ERROR.
      _flushPending();
    }

    // Start a block or continue the current one.
    if (!_input.isEOS ||
        _lookAhead != 0 ||
        (flush != NO_FLUSH && _status != FINISH_STATE)) {
      var bstate = -1;
      switch (_config.function) {
        case STORED:
          bstate = _deflateStored(flush);
          break;
        case FAST:
          bstate = _deflateFast(flush);
          break;
        case SLOW:
          bstate = _deflateSlow(flush);
          break;
        default:
          break;
      }

      if (bstate == FINISH_STARTED || bstate == FINISH_DONE) {
        _status = FINISH_STATE;
      }

      if (bstate == NEED_MORE || bstate == FINISH_STARTED) {
        // If flush != Z_NO_FLUSH && avail_out == 0, the next call
        // of deflate should use the same flush parameter to make sure
        // that the flush is complete. So we don't have to output an
        // empty block here, this will be done at next call. This also
        // ensures that for a very small output buffer, we emit at most
        // one empty block.
        return Z_OK;
      }

      if (bstate == BLOCK_DONE) {
        if (flush == PARTIAL_FLUSH) {
          _trAlign();
        } else {
          // FULL_FLUSH or SYNC_FLUSH
          _trStoredBlock(0, 0, false);
          // For a full flush, this empty block will be recognized
          // as a special marker by inflate_sync().
          if (flush == FULL_FLUSH) {
            for (var i = 0; i < _hashSize; i++) {
              // forget history
              _head[i] = 0;
            }
          }
        }

        _flushPending();
      }
    }

    if (flush != FINISH) {
      return Z_OK;
    }

    return Z_STREAM_END;
  }

  void _lmInit() {
    _actualWindowSize = 2 * _windowSize;

    _head[_hashSize - 1] = 0;
    for (var i = 0; i < _hashSize - 1; i++) {
      _head[i] = 0;
    }

    _strStart = 0;
    _blockStart = 0;
    _lookAhead = 0;
    _matchLength = _prevLength = MIN_MATCH - 1;
    _matchAvailable = 0;
    _insertHash = 0;
  }

  /// Initialize the tree data structures for a zlib stream.
  void _trInit() {
    _lDesc.dynamicTree = _dynamicLengthTree;
    _lDesc.staticDesc = _StaticTree.staticLDesc;

    _dDesc.dynamicTree = _dynamicDistTree;
    _dDesc.staticDesc = _StaticTree.staticDDesc;

    _blDesc.dynamicTree = _bitLengthTree;
    _blDesc.staticDesc = _StaticTree.staticBlDesc;

    _bitBuffer = 0;
    _numValidBits = 0;
    _lastEOBLen = 8; // enough lookahead for inflate

    // Initialize the first block of the first file:
    _initBlock();
  }

  void _initBlock() {
    // Initialize the trees.
    for (var i = 0; i < L_CODES; i++) {
      _dynamicLengthTree[i * 2] = 0;
    }
    for (var i = 0; i < D_CODES; i++) {
      _dynamicDistTree[i * 2] = 0;
    }
    for (var i = 0; i < BL_CODES; i++) {
      _bitLengthTree[i * 2] = 0;
    }

    _dynamicLengthTree[END_BLOCK * 2] = 1;
    _optimalLen = _staticLen = 0;
    _lastLit = _matches = 0;
  }

  /// Restore the heap property by moving down the tree starting at node k,
  /// exchanging a node with the smallest of its two sons if necessary, stopping
  /// when the heap property is re-established (each father smaller than its
  /// two sons).
  void _pqdownheap(Uint16List tree, int k) {
    var v = _heap[k];
    var j = k << 1; // left son of k
    while (j <= _heapLen) {
      // Set j to the smallest of the two sons:
      if (j < _heapLen && _smaller(tree, _heap[j + 1], _heap[j], _depth)) {
        j++;
      }
      // Exit if v is smaller than both sons
      if (_smaller(tree, v, _heap[j], _depth)) {
        break;
      }

      // Exchange v with the smallest son
      _heap[k] = _heap[j];
      k = j;
      // And continue down the tree, setting j to the left son of k
      j <<= 1;
    }
    _heap[k] = v;
  }

  static bool _smaller(Uint16List tree, int n, int m, Uint8List depth) {
    return (tree[n * 2] < tree[m * 2] ||
        (tree[n * 2] == tree[m * 2] && depth[n] <= depth[m]));
  }

  /// Scan a literal or distance tree to determine the frequencies of the codes
  /// in the bit length tree.
  void _scanTree(Uint16List tree, int max_code) {
    int n; // iterates over all tree elements
    var prevlen = -1; // last emitted length
    int curlen; // length of current code
    var nextlen = tree[0 * 2 + 1]; // length of next code
    var count = 0; // repeat count of the current code
    var max_count = 7; // max repeat count
    var min_count = 4; // min repeat count

    if (nextlen == 0) {
      max_count = 138;
      min_count = 3;
    }
    tree[(max_code + 1) * 2 + 1] = 0xffff; // guard

    for (n = 0; n <= max_code; n++) {
      curlen = nextlen;
      nextlen = tree[(n + 1) * 2 + 1];
      if (++count < max_count && curlen == nextlen) {
        continue;
      } else if (count < min_count) {
        _bitLengthTree[curlen * 2] = (_bitLengthTree[curlen * 2] + count);
      } else if (curlen != 0) {
        if (curlen != prevlen) {
          _bitLengthTree[curlen * 2]++;
        }
        _bitLengthTree[REP_3_6 * 2]++;
      } else if (count <= 10) {
        _bitLengthTree[REPZ_3_10 * 2]++;
      } else {
        _bitLengthTree[REPZ_11_138 * 2]++;
      }
      count = 0;
      prevlen = curlen;
      if (nextlen == 0) {
        max_count = 138;
        min_count = 3;
      } else if (curlen == nextlen) {
        max_count = 6;
        min_count = 3;
      } else {
        max_count = 7;
        min_count = 4;
      }
    }
  }

  // Construct the Huffman tree for the bit lengths and return the index in
  // bl_order of the last bit length code to send.
  int _buildBitLengthTree() {
    int max_blindex; // index of last bit length code of non zero freq

    // Determine the bit length frequencies for literal and distance trees
    _scanTree(_dynamicLengthTree, _lDesc.maxCode);
    _scanTree(_dynamicDistTree, _dDesc.maxCode);

    // Build the bit length tree:
    _blDesc._buildTree(this);
    // opt_len now includes the length of the tree representations, except
    // the lengths of the bit lengths codes and the 5+5+4 bits for the counts.

    // Determine the number of bit length codes to send. The pkzip format
    // requires that at least 4 bit length codes be sent. (appnote.txt says
    // 3 but the actual value used is 4.)
    for (max_blindex = BL_CODES - 1; max_blindex >= 3; max_blindex--) {
      if (_bitLengthTree[_HuffmanTree.BL_ORDER[max_blindex] * 2 + 1] != 0) {
        break;
      }
    }

    // Update opt_len to include the bit length tree and counts
    _optimalLen += 3 * (max_blindex + 1) + 5 + 5 + 4;

    return max_blindex;
  }

  /// Send the header for a block using dynamic Huffman trees: the counts, the
  /// lengths of the bit length codes, the literal tree and the distance tree.
  /// IN assertion: lcodes >= 257, dcodes >= 1, blcodes >= 4.
  void _sendAllTrees(int lcodes, int dcodes, int blcodes) {
    int rank; // index in bl_order

    _sendBits(lcodes - 257, 5); // not +255 as stated in appnote.txt
    _sendBits(dcodes - 1, 5);
    _sendBits(blcodes - 4, 4); // not -3 as stated in appnote.txt
    for (rank = 0; rank < blcodes; rank++) {
      _sendBits(_bitLengthTree[_HuffmanTree.BL_ORDER[rank] * 2 + 1], 3);
    }
    _sendTree(_dynamicLengthTree, lcodes - 1); // literal tree
    _sendTree(_dynamicDistTree, dcodes - 1); // distance tree
  }

  /// Send a literal or distance tree in compressed form, using the codes in
  /// bl_tree.
  void _sendTree(Uint16List tree, int max_code) {
    int n; // iterates over all tree elements
    var prevlen = -1; // last emitted length
    int curlen; // length of current code
    var nextlen = tree[0 * 2 + 1]; // length of next code
    var count = 0; // repeat count of the current code
    var max_count = 7; // max repeat count
    var min_count = 4; // min repeat count

    if (nextlen == 0) {
      max_count = 138;
      min_count = 3;
    }

    for (n = 0; n <= max_code; n++) {
      curlen = nextlen;
      nextlen = tree[(n + 1) * 2 + 1];
      if (++count < max_count && curlen == nextlen) {
        continue;
      } else if (count < min_count) {
        do {
          _sendCode(curlen, _bitLengthTree);
        } while (--count != 0);
      } else if (curlen != 0) {
        if (curlen != prevlen) {
          _sendCode(curlen, _bitLengthTree);
          count--;
        }
        _sendCode(REP_3_6, _bitLengthTree);
        _sendBits(count - 3, 2);
      } else if (count <= 10) {
        _sendCode(REPZ_3_10, _bitLengthTree);
        _sendBits(count - 3, 3);
      } else {
        _sendCode(REPZ_11_138, _bitLengthTree);
        _sendBits(count - 11, 7);
      }
      count = 0;
      prevlen = curlen;
      if (nextlen == 0) {
        max_count = 138;
        min_count = 3;
      } else if (curlen == nextlen) {
        max_count = 6;
        min_count = 3;
      } else {
        max_count = 7;
        min_count = 4;
      }
    }
  }

  /// Output a byte on the stream.
  /// IN assertion: there is enough room in pending_buf.
  void _putBytes(Uint8List p, int start, int len) {
    if (len == 0) {
      return;
    }
    _pendingBuffer.setRange(_pending, _pending + len, p, start);
    _pending += len;
  }

  void _putByte(int c) {
    _pendingBuffer[_pending++] = c;
  }

  void _putShort(int w) {
    _putByte((w));
    _putByte((_rshift(w, 8)));
  }

  void _sendCode(int c, List<int> tree) {
    _sendBits((tree[c * 2] & 0xffff), (tree[c * 2 + 1] & 0xffff));
  }

  void _sendBits(int value_Renamed, int length) {
    var len = length;
    if (_numValidBits > BUF_SIZE - len) {
      var val = value_Renamed;
      _bitBuffer = (_bitBuffer | (((val << _numValidBits) & 0xffff)));
      _putShort(_bitBuffer);
      _bitBuffer = (_rshift(val, (BUF_SIZE - _numValidBits)));
      _numValidBits += len - BUF_SIZE;
    } else {
      _bitBuffer =
      (_bitBuffer | ((((value_Renamed) << _numValidBits) & 0xffff)));
      _numValidBits += len;
    }
  }

  /// Send one empty static block to give enough lookahead for inflate.
  /// This takes 10 bits, of which 7 may remain in the bit buffer.
  /// The current inflate code requires 9 bits of lookahead. If the
  /// last two codes for the previous block (real code plus EOB) were coded
  /// on 5 bits or less, inflate may have only 5+3 bits of lookahead to decode
  /// the last real code. In this case we send two empty static blocks instead
  /// of one. (There are no problems if the previous block is stored or fixed.)
  /// To simplify the code, we assume the worst case of last real code encoded
  /// on one bit only.
  void _trAlign() {
    _sendBits(STATIC_TREES << 1, 3);
    _sendCode(END_BLOCK, _StaticTree.STATIC_LTREE);

    biFlush();

    // Of the 10 bits for the empty block, we have already sent
    // (10 - bi_valid) bits. The lookahead for the last real code (before
    // the EOB of the previous block) was thus at least one plus the length
    // of the EOB plus what we have just sent of the empty static block.
    if (1 + _lastEOBLen + 10 - _numValidBits < 9) {
      _sendBits(STATIC_TREES << 1, 3);
      _sendCode(END_BLOCK, _StaticTree.STATIC_LTREE);
      biFlush();
    }

    _lastEOBLen = 7;
  }

  /// Save the match info and tally the frequency counts. Return true if
  /// the current block must be flushed.
  bool _trTally(int dist, int lc) {
    _pendingBuffer[_dbuf + _lastLit * 2] = (_rshift(dist, 8));
    _pendingBuffer[_dbuf + _lastLit * 2 + 1] = dist;

    _pendingBuffer[_lbuf + _lastLit] = lc;
    _lastLit++;

    if (dist == 0) {
      // lc is the unmatched char
      _dynamicLengthTree[lc * 2]++;
    } else {
      _matches++;
      // Here, lc is the match length - MIN_MATCH
      dist--; // dist = match distance - 1
      _dynamicLengthTree[(_HuffmanTree.LENGTH_CODE[lc] + LITERALS + 1) * 2]++;
      _dynamicDistTree[_HuffmanTree._dCode(dist) * 2]++;
    }

    if ((_lastLit & 0x1fff) == 0 && _level > 2) {
      // Compute an upper bound for the compressed length
      var out_length = _lastLit * 8;
      var in_length = _strStart - _blockStart;
      int dcode;
      for (dcode = 0; dcode < D_CODES; dcode++) {
        out_length = (out_length +
            _dynamicDistTree[dcode * 2] *
                (5 + _HuffmanTree.EXTRA_D_BITS[dcode]));
      }
      out_length = _rshift(out_length, 3);
      if ((_matches < (_lastLit / 2)) && out_length < in_length / 2) {
        return true;
      }
    }

    return (_lastLit == _litBufferSize - 1);
    // We avoid equality with lit_bufsize because of wraparound at 64K
    // on 16 bit machines and because stored blocks are restricted to
    // 64K-1 bytes.
  }

  /// Send the block data compressed using the given Huffman trees
  void _compressBlock(List<int> ltree, List<int> dtree) {
    int dist; // distance of matched string
    int lc; // match length or unmatched char (if dist == 0)
    var lx = 0; // running index in l_buf
    int code; // the code to send
    int extra; // number of extra bits to send

    if (_lastLit != 0) {
      do {
        dist = ((_pendingBuffer[_dbuf + lx * 2] << 8) & 0xff00) |
        (_pendingBuffer[_dbuf + lx * 2 + 1] & 0xff);
        lc = (_pendingBuffer[_lbuf + lx]) & 0xff;
        lx++;

        if (dist == 0) {
          _sendCode(lc, ltree); // send a literal byte
        } else {
          // Here, lc is the match length - MIN_MATCH
          code = _HuffmanTree.LENGTH_CODE[lc];

          _sendCode(code + LITERALS + 1, ltree); // send the length code
          extra = _HuffmanTree.EXTRA_L_BITS[code];
          if (extra != 0) {
            lc -= _HuffmanTree.BASE_LENGTH[code];
            _sendBits(lc, extra); // send the extra length bits
          }
          dist--; // dist is now the match distance - 1
          code = _HuffmanTree._dCode(dist);

          _sendCode(code, dtree); // send the distance code
          extra = _HuffmanTree.EXTRA_D_BITS[code];
          if (extra != 0) {
            dist -= _HuffmanTree.BASE_DIST[code];
            _sendBits(dist, extra); // send the extra distance bits
          }
        } // literal or match pair ?

        // Check that the overlay between pending_buf and d_buf+l_buf is ok:
      } while (lx < _lastLit);
    }

    _sendCode(END_BLOCK, ltree);
    _lastEOBLen = ltree[END_BLOCK * 2 + 1];
  }

  /// Set the data type to ASCII or BINARY, using a crude approximation:
  /// binary if more than 20% of the bytes are <= 6 or >= 128, ascii otherwise.
  /// IN assertion: the fields freq of dyn_ltree are set and the total of all
  /// frequencies does not exceed 64K (to fit in an int on 16 bit machines).
  void setDataType() {
    var n = 0;
    var ascii_freq = 0;
    var bin_freq = 0;
    while (n < 7) {
      bin_freq += _dynamicLengthTree[n * 2];
      n++;
    }
    while (n < 128) {
      ascii_freq += _dynamicLengthTree[n * 2];
      n++;
    }
    while (n < LITERALS) {
      bin_freq += _dynamicLengthTree[n * 2];
      n++;
    }
    _dataType = (bin_freq > (_rshift(ascii_freq, 2)) ? Z_BINARY : Z_ASCII);
  }

  /// Flush the bit buffer, keeping at most 7 bits in it.
  void biFlush() {
    if (_numValidBits == 16) {
      _putShort(_bitBuffer);
      _bitBuffer = 0;
      _numValidBits = 0;
    } else if (_numValidBits >= 8) {
      _putByte(_bitBuffer);
      _bitBuffer = (_rshift(_bitBuffer, 8));
      _numValidBits -= 8;
    }
  }

  /// Flush the bit buffer and align the output on a byte boundary
  void _biWindup() {
    if (_numValidBits > 8) {
      _putShort(_bitBuffer);
    } else if (_numValidBits > 0) {
      _putByte(_bitBuffer);
    }
    _bitBuffer = 0;
    _numValidBits = 0;
  }

  /// Copy a stored block, storing first the length and its
  /// one's complement if requested.
  void _copyBlock(int buf, int len, bool header) {
    _biWindup(); // align on byte boundary
    _lastEOBLen = 8; // enough lookahead for inflate

    if (header) {
      _putShort(len);
      _putShort((~len + 0x10000) & 0xffff);
    }

    _putBytes(_window, buf, len);
  }

  void _flushBlockOnly(bool eof) {
    _trFlushBlock(
        _blockStart >= 0 ? _blockStart : -1, _strStart - _blockStart, eof);
    _blockStart = _strStart;
    _flushPending();
  }

  /// Copy without compression as much as possible from the input stream, return
  /// the current block state.
  /// This function does not insert strings in the dictionary since
  /// uncompressible data is probably not useful. This function is used
  /// only for the level=0 compression option.
  /// NOTE: this function should be optimized to avoid extra copying from
  /// window to pending_buf.
  int _deflateStored(int flush) {
    // Stored blocks are limited to 0xffff bytes, pending_buf is limited
    // to pending_buf_size, and each stored block has a 5 byte header:
    var maxBlockSize = 0xffff;

    if (maxBlockSize > _pendingBufferSize - 5) {
      maxBlockSize = _pendingBufferSize - 5;
    }

    // Copy as much as possible from input to output:
    while (true) {
      // Fill the window as much as possible:
      if (_lookAhead <= 1) {
        _fillWindow();

        if (_lookAhead == 0 && flush == NO_FLUSH) {
          return NEED_MORE;
        }

        if (_lookAhead == 0) {
          break; // flush the current block
        }
      }

      _strStart += _lookAhead;
      _lookAhead = 0;

      // Emit a stored block if pendingBuffer will be full:
      var maxStart = _blockStart + maxBlockSize;

      if (_strStart >= maxStart) {
        _lookAhead = (_strStart - maxStart);
        _strStart = maxStart;
        _flushBlockOnly(false);
      }

      // Flush if we may have to slide, otherwise block_start may become
      // negative and the data will be gone:
      if (_strStart - _blockStart >= _windowSize - MIN_LOOKAHEAD) {
        _flushBlockOnly(false);
      }
    }

    _flushBlockOnly(flush == FINISH);

    return (flush == FINISH) ? FINISH_DONE : BLOCK_DONE;
  }

  /// Send a stored block
  void _trStoredBlock(int buf, int storedLen, bool eof) {
    _sendBits((STORED_BLOCK << 1) + (eof ? 1 : 0), 3); // send block type
    _copyBlock(buf, storedLen, true); // with header
  }

  /// Determine the best encoding for the current block: dynamic trees, static
  /// trees or store, and output the encoded block to the zip file.
  void _trFlushBlock(int buf, int storedLen, bool eof) {
    int optLenb;
    int staticLenb;
    var max_blindex = 0; // index of last bit length code of non zero freq

    // Build the Huffman trees unless a stored block is forced
    if (_level > 0) {
      // Check if the file is ascii or binary
      if (_dataType == Z_UNKNOWN) {
        setDataType();
      }

      // Construct the literal and distance trees
      _lDesc._buildTree(this);

      _dDesc._buildTree(this);

      // At this point, opt_len and static_len are the total bit lengths of
      // the compressed block data, excluding the tree representations.

      // Build the bit length tree for the above two trees, and get the index
      // in bl_order of the last bit length code to send.
      max_blindex = _buildBitLengthTree();

      // Determine the best encoding. Compute first the block length in bytes
      optLenb = _rshift((_optimalLen + 3 + 7), 3);
      staticLenb = _rshift((_staticLen + 3 + 7), 3);

      if (staticLenb <= optLenb) {
        optLenb = staticLenb;
      }
    } else {
      optLenb = staticLenb = storedLen + 5; // force a stored block
    }

    if (storedLen + 4 <= optLenb && buf != -1) {
      // 4: two words for the lengths
      // The test buf != NULL is only necessary if LIT_BUFSIZE > WSIZE.
      // Otherwise we can't have processed more than WSIZE input bytes since
      // the last block flush, because compression would have been
      // successful. If LIT_BUFSIZE <= WSIZE, it is never too late to
      // transform a block into a stored block.
      _trStoredBlock(buf, storedLen, eof);
    } else if (staticLenb == optLenb) {
      _sendBits((STATIC_TREES << 1) + (eof ? 1 : 0), 3);
      _compressBlock(_StaticTree.STATIC_LTREE, _StaticTree.STATIC_DTREE);
    } else {
      _sendBits((DYN_TREES << 1) + (eof ? 1 : 0), 3);
      _sendAllTrees(_lDesc.maxCode + 1, _dDesc.maxCode + 1, max_blindex + 1);
      _compressBlock(_dynamicLengthTree, _dynamicDistTree);
    }

    // The above check is made mod 2^32, for files larger than 512 MB
    // and uLong implemented on 32 bits.

    _initBlock();

    if (eof) {
      _biWindup();
    }
  }

  /// Fill the window when the lookahead becomes insufficient.
  /// Updates strstart and lookahead.
  /// IN assertion: lookahead < MIN_LOOKAHEAD
  /// OUT assertions: strstart <= window_size-MIN_LOOKAHEAD
  ///    At least one byte has been read, or avail_in == 0; reads are
  ///    performed for at least two bytes (required for the zip translate_eol
  ///    option -- not supported here).
  void _fillWindow() {
    do {
      // Amount of free space at the end of the window.
      var more = (_actualWindowSize - _lookAhead - _strStart);

      // Deal with 64K limit:
      if (more == 0 && _strStart == 0 && _lookAhead == 0) {
        more = _windowSize;
      } else if (_strStart >= _windowSize + _windowSize - MIN_LOOKAHEAD) {
        // If the window is almost full and there is insufficient lookahead,
        // move the upper half to the lower one to make room in the upper half.

        _window.setRange(0, _windowSize, _window, _windowSize);

        _matchStart -= _windowSize;
        _strStart -= _windowSize; // we now have strstart >= MAX_DIST
        _blockStart -= _windowSize;

        // Slide the hash table (could be avoided with 32 bit values
        // at the expense of memory usage). We slide even when level == 0
        // to keep the hash table consistent if we switch back to level > 0
        // later. (Using level 0 permanently is not an optimal usage of
        // zlib, so we don't care about this pathological case.)

        var n = _hashSize;
        var p = n;
        do {
          var m = (_head[--p] & 0xffff);
          _head[p] = (m >= _windowSize ? (m - _windowSize) : 0);
        } while (--n != 0);

        n = _windowSize;
        p = n;
        do {
          var m = (_prev[--p] & 0xffff);
          _prev[p] = (m >= _windowSize ? (m - _windowSize) : 0);
          // If n is not on any hash chain, prev[n] is garbage but
          // its value will never be used.
        } while (--n != 0);

        more += _windowSize;
      }

      if (_input.isEOS) {
        return;
      }

      // If there was no sliding:
      //    strstart <= WSIZE+MAX_DIST-1 && lookahead <= MIN_LOOKAHEAD - 1 &&
      //    more == window_size - lookahead - strstart
      // => more >= window_size - (MIN_LOOKAHEAD-1 + WSIZE + MAX_DIST-1)
      // => more >= window_size - 2*WSIZE + 2
      // In the BIG_MEM or MMAP case (not yet supported),
      //   window_size == input_size + MIN_LOOKAHEAD  &&
      //   strstart + s->lookahead <= input_size => more >= MIN_LOOKAHEAD.
      // Otherwise, window_size == 2*WSIZE so more >= 2.
      // If there was sliding, more >= WSIZE. So in all cases, more >= 2.

      var n = _readBuf(_window, _strStart + _lookAhead, more);
      _lookAhead += n;

      // Initialize the hash value now that we have some input:
      if (_lookAhead >= MIN_MATCH) {
        _insertHash = _window[_strStart] & 0xff;
        _insertHash =
        (((_insertHash) << _hashShift) ^ (_window[_strStart + 1] & 0xff)) &
        _hashMask;
      }

      // If the whole input has less than MIN_MATCH bytes, ins_h is garbage,
      // but this is not important since only literal bytes will be emitted.
    } while (_lookAhead < MIN_LOOKAHEAD && !_input.isEOS);
  }

  /// Compress as much as possible from the input stream, return the current
  /// block state.
  /// This function does not perform lazy evaluation of matches and inserts
  /// strings in the dictionary only for unmatched strings or for short
  /// matches. It is used only for the fast compression options.
  int _deflateFast(int flush) {
    var hash_head = 0; // head of the hash chain
    bool bflush; // set if current block must be flushed

    while (true) {
      // Make sure that we always have enough lookahead, except
      // at the end of the input file. We need MAX_MATCH bytes
      // for the next match, plus MIN_MATCH bytes to insert the
      // string following the next match.
      if (_lookAhead < MIN_LOOKAHEAD) {
        _fillWindow();
        if (_lookAhead < MIN_LOOKAHEAD && flush == NO_FLUSH) {
          return NEED_MORE;
        }
        if (_lookAhead == 0) {
          break; // flush the current block
        }
      }

      // Insert the string window[strstart .. strstart+2] in the
      // dictionary, and set hash_head to the head of the hash chain:
      if (_lookAhead >= MIN_MATCH) {
        _insertHash = (((_insertHash) << _hashShift) ^
        (_window[(_strStart) + (MIN_MATCH - 1)] & 0xff)) &
        _hashMask;

        hash_head = (_head[_insertHash] & 0xffff);
        _prev[_strStart & _windowMask] = _head[_insertHash];
        _head[_insertHash] = _strStart;
      }

      // Find the longest match, discarding those <= prev_length.
      // At this point we have always match_length < MIN_MATCH

      if (hash_head != 0 &&
          ((_strStart - hash_head) & 0xffff) <= _windowSize - MIN_LOOKAHEAD) {
        // To simplify the code, we prevent matches with the string
        // of window index 0 (in particular we have to avoid a match
        // of the string with itself at the start of the input file).
        if (_strategy != Z_HUFFMAN_ONLY) {
          _matchLength = _longestMatch(hash_head);
        }

        // longest_match() sets match_start
      }

      if (_matchLength >= MIN_MATCH) {
        bflush = _trTally(_strStart - _matchStart, _matchLength - MIN_MATCH);

        _lookAhead -= _matchLength;

        // Insert strings in the hash table only if the match length
        // is not too large. This saves time but degrades compression.
        if (_matchLength <= _config.maxLazy && _lookAhead >= MIN_MATCH) {
          _matchLength--; // string at strstart already in hash table
          do {
            _strStart++;

            _insertHash = ((_insertHash << _hashShift) ^
            (_window[(_strStart) + (MIN_MATCH - 1)] & 0xff)) &
            _hashMask;

            hash_head = (_head[_insertHash] & 0xffff);
            _prev[_strStart & _windowMask] = _head[_insertHash];
            _head[_insertHash] = _strStart;

            // strstart never exceeds WSIZE-MAX_MATCH, so there are
            // always MIN_MATCH bytes ahead.
          } while (--_matchLength != 0);
          _strStart++;
        } else {
          _strStart += _matchLength;
          _matchLength = 0;
          _insertHash = _window[_strStart] & 0xff;

          _insertHash = (((_insertHash) << _hashShift) ^
          (_window[_strStart + 1] & 0xff)) &
          _hashMask;
          // If lookahead < MIN_MATCH, ins_h is garbage, but it does not
          // matter since it will be recomputed at next deflate call.
        }
      } else {
        // No match, output a literal byte

        bflush = _trTally(0, _window[_strStart] & 0xff);
        _lookAhead--;
        _strStart++;
      }

      if (bflush) {
        _flushBlockOnly(false);
      }
    }

    _flushBlockOnly(flush == FINISH);

    return flush == FINISH ? FINISH_DONE : BLOCK_DONE;
  }

  /// Same as above, but achieves better compression. We use a lazy
  /// evaluation for matches: a match is finally adopted only if there is
  /// no better match at the next window position.
  int _deflateSlow(int flush) {
    var hash_head = 0; // head of hash chain
    bool bflush; // set if current block must be flushed

    // Process the input block.
    while (true) {
      // Make sure that we always have enough lookahead, except
      // at the end of the input file. We need MAX_MATCH bytes
      // for the next match, plus MIN_MATCH bytes to insert the
      // string following the next match.
      if (_lookAhead < MIN_LOOKAHEAD) {
        _fillWindow();

        if (_lookAhead < MIN_LOOKAHEAD && flush == NO_FLUSH) {
          return NEED_MORE;
        }

        if (_lookAhead == 0) {
          break; // flush the current block
        }
      }

      // Insert the string window[strstart .. strstart+2] in the
      // dictionary, and set hash_head to the head of the hash chain:

      if (_lookAhead >= MIN_MATCH) {
        _insertHash = (((_insertHash) << _hashShift) ^
        (_window[(_strStart) + (MIN_MATCH - 1)] & 0xff)) &
        _hashMask;
        hash_head = (_head[_insertHash] & 0xffff);
        _prev[_strStart & _windowMask] = _head[_insertHash];
        _head[_insertHash] = _strStart;
      }

      // Find the longest match, discarding those <= prev_length.
      _prevLength = _matchLength;
      _prevMatch = _matchStart;
      _matchLength = MIN_MATCH - 1;

      if (hash_head != 0 &&
          _prevLength < _config.maxLazy &&
          ((_strStart - hash_head) & 0xffff) <= _windowSize - MIN_LOOKAHEAD) {
        // To simplify the code, we prevent matches with the string
        // of window index 0 (in particular we have to avoid a match
        // of the string with itself at the start of the input file).

        if (_strategy != Z_HUFFMAN_ONLY) {
          _matchLength = _longestMatch(hash_head);
        }
        // longest_match() sets match_start

        if (_matchLength <= 5 &&
            (_strategy == Z_FILTERED ||
                (_matchLength == MIN_MATCH &&
                    _strStart - _matchStart > 4096))) {
          // If prev_match is also MIN_MATCH, match_start is garbage
          // but we will ignore the current match anyway.
          _matchLength = MIN_MATCH - 1;
        }
      }

      // If there was a match at the previous step and the current
      // match is not better, output the previous match:
      if (_prevLength >= MIN_MATCH && _matchLength <= _prevLength) {
        var max_insert = _strStart + _lookAhead - MIN_MATCH;
        // Do not insert strings in hash table beyond this.

        bflush = _trTally(_strStart - 1 - _prevMatch, _prevLength - MIN_MATCH);

        // Insert in hash table all strings up to the end of the match.
        // strstart-1 and strstart are already inserted. If there is not
        // enough lookahead, the last two strings are not inserted in
        // the hash table.
        _lookAhead -= (_prevLength - 1);
        _prevLength -= 2;

        do {
          if (++_strStart <= max_insert) {
            _insertHash = (((_insertHash) << _hashShift) ^
            (_window[(_strStart) + (MIN_MATCH - 1)] & 0xff)) &
            _hashMask;
            hash_head = (_head[_insertHash] & 0xffff);
            _prev[_strStart & _windowMask] = _head[_insertHash];
            _head[_insertHash] = _strStart;
          }
        } while (--_prevLength != 0);

        _matchAvailable = 0;
        _matchLength = MIN_MATCH - 1;
        _strStart++;

        if (bflush) {
          _flushBlockOnly(false);
        }
      } else if (_matchAvailable != 0) {
        // If there was no match at the previous position, output a
        // single literal. If there was a match but the current match
        // is longer, truncate the previous match to a single literal.

        bflush = _trTally(0, _window[_strStart - 1] & 0xff);

        if (bflush) {
          _flushBlockOnly(false);
        }
        _strStart++;
        _lookAhead--;
      } else {
        // There is no previous match to compare with, wait for
        // the next step to decide.
        _matchAvailable = 1;
        _strStart++;
        _lookAhead--;
      }
    }

    if (_matchAvailable != 0) {
      bflush = _trTally(0, _window[_strStart - 1] & 0xff);
      _matchAvailable = 0;
    }
    _flushBlockOnly(flush == FINISH);

    return flush == FINISH ? FINISH_DONE : BLOCK_DONE;
  }

  int _longestMatch(int cur_match) {
    var chain_length = _config.maxChain; // max hash chain length
    var scan = _strStart; // current string
    int match; // matched string
    int len; // length of current match
    var best_len = _prevLength; // best match length so far
    var limit = _strStart > (_windowSize - MIN_LOOKAHEAD)
        ? _strStart - (_windowSize - MIN_LOOKAHEAD)
        : 0;
    var nice_match = _config.niceLength;

    // Stop when cur_match becomes <= limit. To simplify the code,
    // we prevent matches with the string of window index 0.

    var wmask = _windowMask;

    var strend = _strStart + MAX_MATCH;
    var scan_end1 = _window[scan + best_len - 1];
    var scan_end = _window[scan + best_len];

    // The code is optimized for HASH_BITS >= 8 and MAX_MATCH-2 multiple of 16.
    // It is easy to get rid of this optimization if necessary.

    // Do not waste too much time if we already have a good match:
    if (_prevLength >= _config.goodLength) {
      chain_length >>= 2;
    }

    // Do not look for matches beyond the end of the input. This is necessary
    // to make deflate deterministic.
    if (nice_match > _lookAhead) {
      nice_match = _lookAhead;
    }

    do {
      match = cur_match;

      // Skip to next match if the match length cannot increase
      // or if the match length is less than 2:
      if (_window[match + best_len] != scan_end ||
          _window[match + best_len - 1] != scan_end1 ||
          _window[match] != _window[scan] ||
          _window[++match] != _window[scan + 1]) {
        continue;
      }

      // The check at best_len-1 can be removed because it will be made
      // again later. (This heuristic is not always a win.)
      // It is not necessary to compare scan[2] and match[2] since they
      // are always equal when the other bytes match, given that
      // the hash keys are equal and that HASH_BITS >= 8.
      scan += 2;
      match++;

      // We check for insufficient lookahead only every 8th comparison;
      // the 256th check will be made at strstart+258.
      do {} while (_window[++scan] == _window[++match] &&
          _window[++scan] == _window[++match] &&
          _window[++scan] == _window[++match] &&
          _window[++scan] == _window[++match] &&
          _window[++scan] == _window[++match] &&
          _window[++scan] == _window[++match] &&
          _window[++scan] == _window[++match] &&
          _window[++scan] == _window[++match] &&
          scan < strend);

      len = MAX_MATCH - (strend - scan);
      scan = strend - MAX_MATCH;

      if (len > best_len) {
        _matchStart = cur_match;
        best_len = len;
        if (len >= nice_match) {
          break;
        }
        scan_end1 = _window[scan + best_len - 1];
        scan_end = _window[scan + best_len];
      }
    } while ((cur_match = (_prev[cur_match & wmask] & 0xffff)) > limit &&
        --chain_length != 0);

    if (best_len <= _lookAhead) {
      return best_len;
    }

    return _lookAhead;
  }

  /// Read a buffer from the current input stream, update the adler32
  /// and total number of bytes read.  All deflate() input goes through
  /// this function so some applications may wish to modify it to avoid
  /// allocating a large strm->next_in buffer and copying from it.
  /// (See also flush_pending()).
  int total = 0;
  int _readBuf(Uint8List buf, int start, int size) {
    if (size == 0 || _input.isEOS) {
      return 0;
    }

    final data = _input.readBytes(size);
    var len = data.length;
    if (len == 0) {
      return 0;
    }

    final bytes = data.toUint8List();
    if (len > bytes.length) {
      len = bytes.length;
    }
    buf.setRange(start, start + len, bytes);
    total += len;
    crc32 = getCrc32(bytes, crc32);

    return len;
  }

  /// Flush as much pending output as possible. All deflate() output goes
  /// through this function so some applications may wish to modify it
  /// to avoid allocating a large strm->next_out buffer and copying into it.
  void _flushPending() {
    final len = _pending;
    _output.writeBytes(_pendingBuffer, len);

    _pendingOut += len;
    _pending -= len;
    if (_pending == 0) {
      _pendingOut = 0;
    }
  }

  _DeflaterConfig _getConfig(int level) {
    switch (level) {
    //                             good  lazy  nice  chain
      case 0:
        return _DeflaterConfig(0, 0, 0, 0, STORED);
      case 1:
        return _DeflaterConfig(4, 4, 8, 4, FAST);
      case 2:
        return _DeflaterConfig(4, 5, 16, 8, FAST);
      case 3:
        return _DeflaterConfig(4, 6, 32, 32, FAST);

      case 4:
        return _DeflaterConfig(4, 4, 16, 16, SLOW);
      case 5:
        return _DeflaterConfig(8, 16, 32, 32, SLOW);
      case 6:
        return _DeflaterConfig(8, 16, 128, 128, SLOW);
      case 7:
        return _DeflaterConfig(8, 32, 128, 256, SLOW);
      case 8:
        return _DeflaterConfig(32, 128, 258, 1024, SLOW);
      case 9:
        return _DeflaterConfig(32, 258, 258, 4096, SLOW);
    }
    return null;
  }

  static const int MAX_MEM_LEVEL = 9;

  static const int Z_DEFAULT_COMPRESSION = -1;

  /// 32K LZ77 window
  static const int MAX_WBITS = 15;
  static const int DEF_MEM_LEVEL = 8;

  static const int STORED = 0;
  static const int FAST = 1;
  static const int SLOW = 2;
  static _DeflaterConfig _config;

  /// block not completed, need more input or more output
  static const int NEED_MORE = 0;

  /// block flush performed
  static const int BLOCK_DONE = 1;

  /// finish started, need only more output at next deflate
  static const int FINISH_STARTED = 2;

  /// finish done, accept no more input or output
  static const int FINISH_DONE = 3;

  static const int Z_FILTERED = 1;
  static const int Z_HUFFMAN_ONLY = 2;
  static const int Z_DEFAULT_STRATEGY = 0;

  static const int Z_OK = 0;
  static const int Z_STREAM_END = 1;
  static const int Z_NEED_DICT = 2;
  static const int Z_ERRNO = -1;
  static const int Z_STREAM_ERROR = -2;
  static const int Z_DATA_ERROR = -3;
  static const int Z_MEM_ERROR = -4;
  static const int Z_BUF_ERROR = -5;
  static const int Z_VERSION_ERROR = -6;

  static const int INIT_STATE = 42;
  static const int BUSY_STATE = 113;
  static const int FINISH_STATE = 666;

  /// The deflate compression method
  static const int Z_DEFLATED = 8;

  static const int STORED_BLOCK = 0;
  static const int STATIC_TREES = 1;
  static const int DYN_TREES = 2;

  // The three kinds of block type
  static const int Z_BINARY = 0;
  static const int Z_ASCII = 1;
  static const int Z_UNKNOWN = 2;

  static const int BUF_SIZE = 8 * 2;

  /// repeat previous bit length 3-6 times (2 bits of repeat count)
  static const int REP_3_6 = 16;

  /// repeat a zero length 3-10 times  (3 bits of repeat count)
  static const int REPZ_3_10 = 17;

  /// repeat a zero length 11-138 times  (7 bits of repeat count)
  static const int REPZ_11_138 = 18;

  static const int MIN_MATCH = 3;
  static const int MAX_MATCH = 258;
  static const int MIN_LOOKAHEAD = (MAX_MATCH + MIN_MATCH + 1);

  static const int MAX_BITS = 15;
  static const int D_CODES = 30;
  static const int BL_CODES = 19;
  static const int LENGTH_CODES = 29;
  static const int LITERALS = 256;
  static const int L_CODES = (LITERALS + 1 + LENGTH_CODES);
  static const int HEAP_SIZE = (2 * L_CODES + 1);

  static const int END_BLOCK = 256;

  InputStreamBase _input;
  final dynamic _output;

  int _status;

  /// output still pending
  Uint8List _pendingBuffer;

  /// size of pending_buf
  int _pendingBufferSize;

  /// next pending byte to output to the stream
  int _pendingOut; // ignore: unused_field
  /// nb of bytes in the pending buffer
  int _pending;

  /// UNKNOWN, BINARY or ASCII
  int _dataType;

  /// STORED (for zip only) or DEFLATED
  int _method; // ignore: unused_field
  /// value of flush param for previous deflate call
  int _lastFlush; // ignore: unused_field

  /// LZ77 window size (32K by default)
  int _windowSize;

  /// log2(w_size)  (8..16)
  int _windowBits;

  /// w_size - 1
  int _windowMask;

  /// Sliding window. Input bytes are read into the second half of the window,
  /// and move to the first half later to keep a dictionary of at least wSize
  /// bytes. With this organization, matches are limited to a distance of
  /// wSize-MAX_MATCH bytes, but this ensures that IO is always
  /// performed with a length multiple of the block size. Also, it limits
  /// the window size to 64K, which is quite useful on MSDOS.
  /// To do: use the user input buffer as sliding window.
  Uint8List _window;

  /// Actual size of window: 2*wSize, except when the user input buffer
  /// is directly used as sliding window.
  int _actualWindowSize;

  /// Link to older string with same hash index. To limit the size of this
  /// array to 64K, this link is maintained only for the last 32K strings.
  /// An index in this array is thus a window index modulo 32K.
  Uint16List _prev;

  /// Heads of the hash chains or NIL.
  Uint16List _head;

  /// hash index of string to be inserted
  int _insertHash;

  /// number of elements in hash table
  int _hashSize;

  /// log2(hash_size)
  int _hashBits;

  /// hash_size-1
  int _hashMask;

  /// Number of bits by which ins_h must be shifted at each input
  /// step. It must be such that after MIN_MATCH steps, the oldest
  /// byte no longer takes part in the hash key, that is:
  /// hash_shift * MIN_MATCH >= hash_bits
  int _hashShift;

  /// Window position at the beginning of the current output block. Gets
  /// negative when the window is moved backwards.
  int _blockStart;

  /// length of best match
  int _matchLength;

  /// previous match
  int _prevMatch;

  /// set if previous match exists
  int _matchAvailable;

  /// start of string to insert
  int _strStart;

  /// start of matching string
  int _matchStart = 0;

  /// number of valid bytes ahead in window
  int _lookAhead;

  /// Length of the best match at previous step. Matches not greater than this
  /// are discarded. This is used in the lazy match evaluation.
  int _prevLength;

  // Insert strings in the hash table only if the match length is not
  // greater than this length. This saves time but degrades compression.
  // max_insert_length is used only for compression levels <= 3.

  /// compression level (1..9)
  int _level;

  /// favor or force Huffman coding
  int _strategy;

  /// literal and length tree
  Uint16List _dynamicLengthTree;

  /// distance tree
  Uint16List _dynamicDistTree;

  /// Huffman tree for bit lengths
  Uint16List _bitLengthTree;

  /// desc for literal tree
  final _lDesc = _HuffmanTree();

  /// desc for distance tree
  final _dDesc = _HuffmanTree();

  /// desc for bit length tree
  final _blDesc = _HuffmanTree();

  /// number of codes at each bit length for an optimal tree
  final _bitLengthCount = Uint16List(MAX_BITS + 1);

  /// heap used to build the Huffman trees
  final _heap = Uint32List(2 * L_CODES + 1);

  /// number of elements in the heap
  int _heapLen;

  /// element of largest frequency
  int _heapMax;
  // The sons of heap[n] are heap[2*n] and heap[2*n+1]. heap[0] is not used.
  // The same heap array is used to build all trees.

  /// Depth of each subtree used as tie breaker for trees of equal frequency
  final _depth = Uint8List(2 * L_CODES + 1);

  /// index for literals or lengths
  int _lbuf;

  /// Size of match buffer for literals/lengths.  There are 4 reasons for
  /// limiting lit_bufsize to 64K:
  ///   - frequencies can be kept in 16 bit counters
  ///   - if compression is not successful for the first block, all input
  ///     data is still in the window so we can still emit a stored block even
  ///     when input comes from standard input.  (This can also be done for
  ///     all blocks if lit_bufsize is not greater than 32K.)
  ///   - if compression is not successful for a file smaller than 64K, we can
  ///     even emit a stored file instead of a stored block (saving 5 bytes).
  ///     This is applicable only for zip (not gzip or zlib).
  ///   - creating Huffman trees less frequently may not provide fast
  ///     adaptation to changes in the input data statistics. (Take for
  ///     example a binary file with poorly compressible code followed by
  ///     a highly compressible string table.) Smaller buffer sizes give
  ///     fast adaptation but have of course the overhead of transmitting
  ///     trees more frequently.
  ///   - I can't count above 4
  int _litBufferSize;

  /// running index in l_buf
  int _lastLit;

  // Buffer for distances. To simplify the code, d_buf and l_buf have
  // the same number of elements. To use different lengths, an extra flag
  // array would be necessary.

  /// index of pendig_buf
  int _dbuf;

  /// bit length of current block with optimal trees
  int _optimalLen;

  /// bit length of current block with static trees
  int _staticLen;

  /// number of string matches in current block
  int _matches;

  /// bit length of EOB code for last block
  int _lastEOBLen;

  /// Output buffer. bits are inserted starting at the bottom (least
  /// significant bits).
  int _bitBuffer;

  /// Number of valid bits in bi_buf.  All bits above the last valid bit
  /// are always zero.
  int _numValidBits;
}

class _DeflaterConfig {
  /// Use a faster search when the previous match is longer than this
  int goodLength;

  /// Attempt to find a better match only when the current match is strictly
  /// smaller than this value. This mechanism is used only for compression
  /// levels >= 4.
  int maxLazy;

  /// Stop searching when current match exceeds this
  int niceLength;

  /// To speed up deflation, hash chains are never searched beyond this
  /// length. A higher limit improves compression ratio but degrades the speed.
  int maxChain;

  /// STORED, FAST, or SLOW
  int function;

  _DeflaterConfig(this.goodLength, this.maxLazy, this.niceLength, this.maxChain,
      this.function);
}

class _HuffmanTree {
  static const int MAX_BITS = 15;
  //static const int BL_CODES = 19;
  //static const int D_CODES = 30;
  static const int LITERALS = 256;
  static const int LENGTH_CODES = 29;
  static const int L_CODES = (LITERALS + 1 + LENGTH_CODES);
  static const int HEAP_SIZE = (2 * L_CODES + 1);

  /// Bit length codes must not exceed MAX_BL_BITS bits
  //static const int MAX_BL_BITS = 7;

  /// end of block literal code
  //static const int END_BLOCK = 256;

  /// repeat previous bit length 3-6 times (2 bits of repeat count)
  //static const int REP_3_6 = 16;

  /// repeat a zero length 3-10 times  (3 bits of repeat count)
  //static const int REPZ_3_10 = 17;

  /// repeat a zero length 11-138 times  (7 bits of repeat count)
  //static const int REPZ_11_138 = 18;

  /// extra bits for each length code
  static const List<int> EXTRA_L_BITS = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    1,
    2,
    2,
    2,
    2,
    3,
    3,
    3,
    3,
    4,
    4,
    4,
    4,
    5,
    5,
    5,
    5,
    0
  ];

  /// extra bits for each distance code
  static const List<int> EXTRA_D_BITS = [
    0,
    0,
    0,
    0,
    1,
    1,
    2,
    2,
    3,
    3,
    4,
    4,
    5,
    5,
    6,
    6,
    7,
    7,
    8,
    8,
    9,
    9,
    10,
    10,
    11,
    11,
    12,
    12,
    13,
    13
  ];

  /// extra bits for each bit length code
  static const List<int> EXTRA_BL_BITS = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    2,
    3,
    7
  ];

  static const List<int> BL_ORDER = [
    16,
    17,
    18,
    0,
    8,
    7,
    9,
    6,
    10,
    5,
    11,
    4,
    12,
    3,
    13,
    2,
    14,
    1,
    15
  ];

  /// The lengths of the bit length codes are sent in order of decreasing
  /// probability, to avoid transmitting the lengths for unused bit
  /// length codes.
  //static const int BUF_SIZE = 8 * 2;

  /// see definition of array dist_code below
  //static const int DIST_CODE_LEN = 512;

  static const List<int> _DIST_CODE = [
    0,
    1,
    2,
    3,
    4,
    4,
    5,
    5,
    6,
    6,
    6,
    6,
    7,
    7,
    7,
    7,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    10,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    11,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    12,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    13,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    0,
    0,
    16,
    17,
    18,
    18,
    19,
    19,
    20,
    20,
    20,
    20,
    21,
    21,
    21,
    21,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    28,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29,
    29
  ];

  static const List<int> LENGTH_CODE = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    8,
    9,
    9,
    10,
    10,
    11,
    11,
    12,
    12,
    12,
    12,
    13,
    13,
    13,
    13,
    14,
    14,
    14,
    14,
    15,
    15,
    15,
    15,
    16,
    16,
    16,
    16,
    16,
    16,
    16,
    16,
    17,
    17,
    17,
    17,
    17,
    17,
    17,
    17,
    18,
    18,
    18,
    18,
    18,
    18,
    18,
    18,
    19,
    19,
    19,
    19,
    19,
    19,
    19,
    19,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    20,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    23,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    24,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    25,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    26,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    27,
    28
  ];

  static const List<int> BASE_LENGTH = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    10,
    12,
    14,
    16,
    20,
    24,
    28,
    32,
    40,
    48,
    56,
    64,
    80,
    96,
    112,
    128,
    160,
    192,
    224,
    0
  ];

  static const List<int> BASE_DIST = [
    0,
    1,
    2,
    3,
    4,
    6,
    8,
    12,
    16,
    24,
    32,
    48,
    64,
    96,
    128,
    192,
    256,
    384,
    512,
    768,
    1024,
    1536,
    2048,
    3072,
    4096,
    6144,
    8192,
    12288,
    16384,
    24576
  ];

  /// the dynamic tree
  Uint16List dynamicTree;

  /// largest code with non zero frequency
  int maxCode;

  /// the corresponding static tree
  _StaticTree staticDesc;

  /// Compute the optimal bit lengths for a tree and update the total bit length
  /// for the current block.
  /// IN assertion: the fields freq and dad are set, heap[heap_max] and
  ///    above are the tree nodes sorted by increasing frequency.
  /// OUT assertions: the field len is set to the optimal bit length, the
  ///     array bl_count contains the frequencies for each bit length.
  ///     The length opt_len is updated; static_len is also updated if stree is
  ///     not null.
  void _genBitlen(Deflate s) {
    final tree = dynamicTree;
    final stree = staticDesc.staticTree;
    final extra = staticDesc.extraBits;
    final base_Renamed = staticDesc.extraBase;
    final max_length = staticDesc.maxLength;
    int h; // heap index
    int n, m; // iterate over the tree elements
    int bits; // bit length
    int xbits; // extra bits
    int f; // frequency
    var overflow = 0; // number of elements with bit length too large

    for (bits = 0; bits <= MAX_BITS; bits++) {
      s._bitLengthCount[bits] = 0;
    }

    // In a first pass, compute the optimal bit lengths (which may
    // overflow in the case of the bit length tree).
    tree[s._heap[s._heapMax] * 2 + 1] = 0; // root of the heap

    for (h = s._heapMax + 1; h < HEAP_SIZE; h++) {
      n = s._heap[h];
      bits = tree[tree[n * 2 + 1] * 2 + 1] + 1;
      if (bits > max_length) {
        bits = max_length;
        overflow++;
      }
      tree[n * 2 + 1] = bits;
      // We overwrite tree[n*2+1] which is no longer needed

      if (n > maxCode) {
        continue; // not a leaf node
      }

      s._bitLengthCount[bits]++;
      xbits = 0;
      if (n >= base_Renamed) {
        xbits = extra[n - base_Renamed];
      }
      f = tree[n * 2];
      s._optimalLen += f * (bits + xbits);
      if (stree != null) {
        s._staticLen += f * (stree[n * 2 + 1] + xbits);
      }
    }
    if (overflow == 0) {
      return;
    }

    // This happens for example on obj2 and pic of the Calgary corpus
    // Find the first bit length which could increase:
    do {
      bits = max_length - 1;
      while (s._bitLengthCount[bits] == 0) {
        bits--;
      }
      s._bitLengthCount[bits]--; // move one leaf down the tree
      // move one overflow item as its brother
      s._bitLengthCount[bits + 1] = (s._bitLengthCount[bits + 1] + 2);
      s._bitLengthCount[max_length]--;
      // The brother of the overflow item also moves one step up,
      // but this does not affect bl_count[max_length]
      overflow -= 2;
    } while (overflow > 0);

    for (bits = max_length; bits != 0; bits--) {
      n = s._bitLengthCount[bits];
      while (n != 0) {
        m = s._heap[--h];
        if (m > maxCode) {
          continue;
        }
        if (tree[m * 2 + 1] != bits) {
          s._optimalLen =
          (s._optimalLen + (bits - tree[m * 2 + 1]) * tree[m * 2]);
          tree[m * 2 + 1] = bits;
        }
        n--;
      }
    }
  }

  /// Construct one Huffman tree and assigns the code bit strings and lengths.
  /// Update the total bit length for the current block.
  /// IN assertion: the field freq is set for all tree elements.
  /// OUT assertions: the fields len and code are set to the optimal bit length
  ///     and corresponding code. The length opt_len is updated; static_len is
  ///     also updated if stree is not null. The field max_code is set.
  void _buildTree(Deflate s) {
    final tree = dynamicTree;
    final stree = staticDesc.staticTree;
    final elems = staticDesc.numElements;
    int n, m; // iterate over heap elements
    var max_code = -1; // largest code with non zero frequency
    int node; // node being created

    // Construct the initial heap, with least frequent element in
    // heap[1]. The sons of heap[n] are heap[2*n] and heap[2*n+1].
    // heap[0] is not used.
    s._heapLen = 0;
    s._heapMax = HEAP_SIZE;

    for (n = 0; n < elems; n++) {
      if (tree[n * 2] != 0) {
        s._heap[++s._heapLen] = max_code = n;
        s._depth[n] = 0;
      } else {
        tree[n * 2 + 1] = 0;
      }
    }

    // The pkzip format requires that at least one distance code exists,
    // and that at least one bit should be sent even if there is only one
    // possible code. So to avoid special checks later on we force at least
    // two codes of non zero frequency.
    while (s._heapLen < 2) {
      node = s._heap[++s._heapLen] = (max_code < 2 ? ++max_code : 0);
      tree[node * 2] = 1;
      s._depth[node] = 0;
      s._optimalLen--;
      if (stree != null) {
        s._staticLen -= stree[node * 2 + 1];
      }
      // node is 0 or 1 so it does not have extra bits
    }
    maxCode = max_code;

    // The elements heap[heap_len/2+1 .. heap_len] are leaves of the tree,
    // establish sub-heaps of increasing lengths:

    for (n = s._heapLen ~/ 2; n >= 1; n--) {
      s._pqdownheap(tree, n);
    }

    // Construct the Huffman tree by repeatedly combining the least two
    // frequent nodes.

    node = elems; // next node of the tree
    do {
      // n = node of least frequency
      n = s._heap[1];
      s._heap[1] = s._heap[s._heapLen--];
      s._pqdownheap(tree, 1);
      m = s._heap[1]; // m = node of next least frequency

      s._heap[--s._heapMax] = n; // keep the nodes sorted by frequency
      s._heap[--s._heapMax] = m;

      // Create a node father of n and m
      tree[node * 2] = (tree[n * 2] + tree[m * 2]);
      s._depth[node] = (_max(s._depth[n], s._depth[m]) + 1);
      tree[n * 2 + 1] = tree[m * 2 + 1] = node;

      // and insert the node in the heap
      s._heap[1] = node++;
      s._pqdownheap(tree, 1);
    } while (s._heapLen >= 2);

    s._heap[--s._heapMax] = s._heap[1];

    // At this point, the fields freq and dad are set. We can now
    // generate the bit lengths.

    _genBitlen(s);

    // The field len is now set, we can generate the bit codes
    _genCodes(tree, max_code, s._bitLengthCount);
  }

  static int _max(int a, int b) => a > b ? a : b;

  /// Generate the codes for a given tree and bit counts (which need not be
  /// optimal).
  /// IN assertion: the array bl_count contains the bit length statistics for
  /// the given tree and the field len is set for all tree elements.
  /// OUT assertion: the field code is set for all tree elements of non
  ///     zero code length.
  static void _genCodes(Uint16List tree, int max_code, Uint16List bl_count) {
    final next_code = Uint16List(MAX_BITS + 1);
    var code = 0; // running code value
    int bits; // bit index
    int n; // code index

    // The distribution counts are first used to generate the code values
    // without bit reversal.
    for (bits = 1; bits <= MAX_BITS; bits++) {
      next_code[bits] = code = ((code + bl_count[bits - 1]) << 1);
    }

    for (n = 0; n <= max_code; n++) {
      final len = tree[n * 2 + 1];
      if (len == 0) {
        continue;
      }

      // Now reverse the bits
      tree[n * 2] = (_reverseBits(next_code[len]++, len));
    }
  }

  /// Reverse the first len bits of a code, using straightforward code (a faster
  /// method would use a table)
  /// IN assertion: 1 <= len <= 15
  static int _reverseBits(int code, int len) {
    var res = 0;
    do {
      res |= code & 1;
      code = _rshift(code, 1);
      res <<= 1;
    } while (--len > 0);
    return _rshift(res, 1);
  }

  /// Mapping from a distance to a distance code. dist is the distance - 1 and
  /// must not have side effects. _dist_code[256] and _dist_code[257] are never
  /// used.
  static int _dCode(int dist) {
    return ((dist) < 256
        ? _DIST_CODE[dist]
        : _DIST_CODE[256 + (_rshift((dist), 7))]);
  }
}

class _StaticTree {
  static const int MAX_BITS = 15;

  static const int BL_CODES = 19;
  static const int D_CODES = 30;
  static const int LITERALS = 256;
  static const int LENGTH_CODES = 29;
  static const int L_CODES = (LITERALS + 1 + LENGTH_CODES);

  // Bit length codes must not exceed MAX_BL_BITS bits
  static const int MAX_BL_BITS = 7;

  static const List<int> STATIC_LTREE = [
    12,
    8,
    140,
    8,
    76,
    8,
    204,
    8,
    44,
    8,
    172,
    8,
    108,
    8,
    236,
    8,
    28,
    8,
    156,
    8,
    92,
    8,
    220,
    8,
    60,
    8,
    188,
    8,
    124,
    8,
    252,
    8,
    2,
    8,
    130,
    8,
    66,
    8,
    194,
    8,
    34,
    8,
    162,
    8,
    98,
    8,
    226,
    8,
    18,
    8,
    146,
    8,
    82,
    8,
    210,
    8,
    50,
    8,
    178,
    8,
    114,
    8,
    242,
    8,
    10,
    8,
    138,
    8,
    74,
    8,
    202,
    8,
    42,
    8,
    170,
    8,
    106,
    8,
    234,
    8,
    26,
    8,
    154,
    8,
    90,
    8,
    218,
    8,
    58,
    8,
    186,
    8,
    122,
    8,
    250,
    8,
    6,
    8,
    134,
    8,
    70,
    8,
    198,
    8,
    38,
    8,
    166,
    8,
    102,
    8,
    230,
    8,
    22,
    8,
    150,
    8,
    86,
    8,
    214,
    8,
    54,
    8,
    182,
    8,
    118,
    8,
    246,
    8,
    14,
    8,
    142,
    8,
    78,
    8,
    206,
    8,
    46,
    8,
    174,
    8,
    110,
    8,
    238,
    8,
    30,
    8,
    158,
    8,
    94,
    8,
    222,
    8,
    62,
    8,
    190,
    8,
    126,
    8,
    254,
    8,
    1,
    8,
    129,
    8,
    65,
    8,
    193,
    8,
    33,
    8,
    161,
    8,
    97,
    8,
    225,
    8,
    17,
    8,
    145,
    8,
    81,
    8,
    209,
    8,
    49,
    8,
    177,
    8,
    113,
    8,
    241,
    8,
    9,
    8,
    137,
    8,
    73,
    8,
    201,
    8,
    41,
    8,
    169,
    8,
    105,
    8,
    233,
    8,
    25,
    8,
    153,
    8,
    89,
    8,
    217,
    8,
    57,
    8,
    185,
    8,
    121,
    8,
    249,
    8,
    5,
    8,
    133,
    8,
    69,
    8,
    197,
    8,
    37,
    8,
    165,
    8,
    101,
    8,
    229,
    8,
    21,
    8,
    149,
    8,
    85,
    8,
    213,
    8,
    53,
    8,
    181,
    8,
    117,
    8,
    245,
    8,
    13,
    8,
    141,
    8,
    77,
    8,
    205,
    8,
    45,
    8,
    173,
    8,
    109,
    8,
    237,
    8,
    29,
    8,
    157,
    8,
    93,
    8,
    221,
    8,
    61,
    8,
    189,
    8,
    125,
    8,
    253,
    8,
    19,
    9,
    275,
    9,
    147,
    9,
    403,
    9,
    83,
    9,
    339,
    9,
    211,
    9,
    467,
    9,
    51,
    9,
    307,
    9,
    179,
    9,
    435,
    9,
    115,
    9,
    371,
    9,
    243,
    9,
    499,
    9,
    11,
    9,
    267,
    9,
    139,
    9,
    395,
    9,
    75,
    9,
    331,
    9,
    203,
    9,
    459,
    9,
    43,
    9,
    299,
    9,
    171,
    9,
    427,
    9,
    107,
    9,
    363,
    9,
    235,
    9,
    491,
    9,
    27,
    9,
    283,
    9,
    155,
    9,
    411,
    9,
    91,
    9,
    347,
    9,
    219,
    9,
    475,
    9,
    59,
    9,
    315,
    9,
    187,
    9,
    443,
    9,
    123,
    9,
    379,
    9,
    251,
    9,
    507,
    9,
    7,
    9,
    263,
    9,
    135,
    9,
    391,
    9,
    71,
    9,
    327,
    9,
    199,
    9,
    455,
    9,
    39,
    9,
    295,
    9,
    167,
    9,
    423,
    9,
    103,
    9,
    359,
    9,
    231,
    9,
    487,
    9,
    23,
    9,
    279,
    9,
    151,
    9,
    407,
    9,
    87,
    9,
    343,
    9,
    215,
    9,
    471,
    9,
    55,
    9,
    311,
    9,
    183,
    9,
    439,
    9,
    119,
    9,
    375,
    9,
    247,
    9,
    503,
    9,
    15,
    9,
    271,
    9,
    143,
    9,
    399,
    9,
    79,
    9,
    335,
    9,
    207,
    9,
    463,
    9,
    47,
    9,
    303,
    9,
    175,
    9,
    431,
    9,
    111,
    9,
    367,
    9,
    239,
    9,
    495,
    9,
    31,
    9,
    287,
    9,
    159,
    9,
    415,
    9,
    95,
    9,
    351,
    9,
    223,
    9,
    479,
    9,
    63,
    9,
    319,
    9,
    191,
    9,
    447,
    9,
    127,
    9,
    383,
    9,
    255,
    9,
    511,
    9,
    0,
    7,
    64,
    7,
    32,
    7,
    96,
    7,
    16,
    7,
    80,
    7,
    48,
    7,
    112,
    7,
    8,
    7,
    72,
    7,
    40,
    7,
    104,
    7,
    24,
    7,
    88,
    7,
    56,
    7,
    120,
    7,
    4,
    7,
    68,
    7,
    36,
    7,
    100,
    7,
    20,
    7,
    84,
    7,
    52,
    7,
    116,
    7,
    3,
    8,
    131,
    8,
    67,
    8,
    195,
    8,
    35,
    8,
    163,
    8,
    99,
    8,
    227,
    8
  ];

  static const List<int> STATIC_DTREE = [
    0,
    5,
    16,
    5,
    8,
    5,
    24,
    5,
    4,
    5,
    20,
    5,
    12,
    5,
    28,
    5,
    2,
    5,
    18,
    5,
    10,
    5,
    26,
    5,
    6,
    5,
    22,
    5,
    14,
    5,
    30,
    5,
    1,
    5,
    17,
    5,
    9,
    5,
    25,
    5,
    5,
    5,
    21,
    5,
    13,
    5,
    29,
    5,
    3,
    5,
    19,
    5,
    11,
    5,
    27,
    5,
    7,
    5,
    23,
    5
  ];

  static final staticLDesc = _StaticTree(
      STATIC_LTREE, _HuffmanTree.EXTRA_L_BITS, LITERALS + 1, L_CODES, MAX_BITS);

  static final staticDDesc = _StaticTree(
      STATIC_DTREE, _HuffmanTree.EXTRA_D_BITS, 0, D_CODES, MAX_BITS);

  static final staticBlDesc = _StaticTree(
      null, _HuffmanTree.EXTRA_BL_BITS, 0, BL_CODES, MAX_BL_BITS);

  List<int> staticTree; // static tree or null
  List<int> extraBits; // extra bits for each code or null
  int extraBase; // base index for extra_bits
  int numElements; // max number of elements in the tree
  int maxLength; // max bit length for the codes

  _StaticTree(this.staticTree, this.extraBits, this.extraBase, this.numElements,
      this.maxLength);
}
/// Performs an unsigned bitwise right shift with the specified number
int _rshift(int number, int bits) {
  if (number >= 0) {
    return number >> bits;
  } else {
    final nbits = (~bits + 0x10000) & 0xffff;
    return (number >> bits) + (2 << nbits);
  }
}
class ArchiveException extends FormatException {
  ArchiveException(String message, [dynamic source, int offset])
      : super(message, source, offset);
}




/// Get the CRC-32 checksum of the given int.
int CRC32(int crc, int b) => _CRC32_TABLE[(crc ^ b) & 0xff] ^ (crc >> 8);

/// Get the CRC-32 checksum of the given array. You can append bytes to an
/// already computed crc by specifying the previous [crc] value.
int getCrc32(List<int> array, [int crc = 0]) {
  var len = array.length;
  crc = crc ^ 0xffffffff;
  var ip = 0;
  while (len >= 8) {
    crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    len -= 8;
  }
  if (len > 0) {
    do {
      crc = _CRC32_TABLE[(crc ^ array[ip++]) & 0xff] ^ (crc >> 8);
    } while (--len > 0);
  }
  return crc ^ 0xffffffff;
}

/// A class to compute Crc-32 checksums.
class Crc32 extends crypto.Hash {
  int _hash = 0;

  /// Get the value of the hash directly. This returns the same value as [close].
  int get hash => _hash;

  @override
  int get blockSize => 4;

  Crc32();

  Crc32 newInstance() => Crc32();

  @override
  ByteConversionSink startChunkedConversion(Sink<crypto.Digest> sink) =>
      _Crc32Sink(sink);

  void add(List<int> data) {
    _hash = getCrc32(data, _hash);
  }

  List<int> close() {
    return [
      ((_hash >> 24) & 0xFF),
      ((_hash >> 16) & 0xFF),
      ((_hash >> 8) & 0xFF),
      (_hash & 0xFF)
    ];
  }
}

/// A [ByteConversionSink] that computes Crc-32 checksums.
class _Crc32Sink extends ByteConversionSinkBase {
  final Sink<crypto.Digest> _inner;

  var _hash = 1;

  /// Whether [close] has been called.
  var _isClosed = false;

  _Crc32Sink(this._inner);

  @override
  void add(List<int> data) {
    if (_isClosed) throw StateError('Hash.add() called after close().');
    _hash = getCrc32(data, _hash);
  }

  @override
  void close() {
    if (_isClosed) return;
    _isClosed = true;

    _inner.add(crypto.Digest([
      ((_hash >> 24) & 0xFF),
      ((_hash >> 16) & 0xFF),
      ((_hash >> 8) & 0xFF),
      (_hash & 0xFF)
    ]));
  }
}

// Precomputed CRC table for faster calculations.
const List<int> _CRC32_TABLE = [
  0,
  1996959894,
  3993919788,
  2567524794,
  124634137,
  1886057615,
  3915621685,
  2657392035,
  249268274,
  2044508324,
  3772115230,
  2547177864,
  162941995,
  2125561021,
  3887607047,
  2428444049,
  498536548,
  1789927666,
  4089016648,
  2227061214,
  450548861,
  1843258603,
  4107580753,
  2211677639,
  325883990,
  1684777152,
  4251122042,
  2321926636,
  335633487,
  1661365465,
  4195302755,
  2366115317,
  997073096,
  1281953886,
  3579855332,
  2724688242,
  1006888145,
  1258607687,
  3524101629,
  2768942443,
  901097722,
  1119000684,
  3686517206,
  2898065728,
  853044451,
  1172266101,
  3705015759,
  2882616665,
  651767980,
  1373503546,
  3369554304,
  3218104598,
  565507253,
  1454621731,
  3485111705,
  3099436303,
  671266974,
  1594198024,
  3322730930,
  2970347812,
  795835527,
  1483230225,
  3244367275,
  3060149565,
  1994146192,
  31158534,
  2563907772,
  4023717930,
  1907459465,
  112637215,
  2680153253,
  3904427059,
  2013776290,
  251722036,
  2517215374,
  3775830040,
  2137656763,
  141376813,
  2439277719,
  3865271297,
  1802195444,
  476864866,
  2238001368,
  4066508878,
  1812370925,
  453092731,
  2181625025,
  4111451223,
  1706088902,
  314042704,
  2344532202,
  4240017532,
  1658658271,
  366619977,
  2362670323,
  4224994405,
  1303535960,
  984961486,
  2747007092,
  3569037538,
  1256170817,
  1037604311,
  2765210733,
  3554079995,
  1131014506,
  879679996,
  2909243462,
  3663771856,
  1141124467,
  855842277,
  2852801631,
  3708648649,
  1342533948,
  654459306,
  3188396048,
  3373015174,
  1466479909,
  544179635,
  3110523913,
  3462522015,
  1591671054,
  702138776,
  2966460450,
  3352799412,
  1504918807,
  783551873,
  3082640443,
  3233442989,
  3988292384,
  2596254646,
  62317068,
  1957810842,
  3939845945,
  2647816111,
  81470997,
  1943803523,
  3814918930,
  2489596804,
  225274430,
  2053790376,
  3826175755,
  2466906013,
  167816743,
  2097651377,
  4027552580,
  2265490386,
  503444072,
  1762050814,
  4150417245,
  2154129355,
  426522225,
  1852507879,
  4275313526,
  2312317920,
  282753626,
  1742555852,
  4189708143,
  2394877945,
  397917763,
  1622183637,
  3604390888,
  2714866558,
  953729732,
  1340076626,
  3518719985,
  2797360999,
  1068828381,
  1219638859,
  3624741850,
  2936675148,
  906185462,
  1090812512,
  3747672003,
  2825379669,
  829329135,
  1181335161,
  3412177804,
  3160834842,
  628085408,
  1382605366,
  3423369109,
  3138078467,
  570562233,
  1426400815,
  3317316542,
  2998733608,
  733239954,
  1555261956,
  3268935591,
  3050360625,
  752459403,
  1541320221,
  2607071920,
  3965973030,
  1969922972,
  40735498,
  2617837225,
  3943577151,
  1913087877,
  83908371,
  2512341634,
  3803740692,
  2075208622,
  213261112,
  2463272603,
  3855990285,
  2094854071,
  198958881,
  2262029012,
  4057260610,
  1759359992,
  534414190,
  2176718541,
  4139329115,
  1873836001,
  414664567,
  2282248934,
  4279200368,
  1711684554,
  285281116,
  2405801727,
  4167216745,
  1634467795,
  376229701,
  2685067896,
  3608007406,
  1308918612,
  956543938,
  2808555105,
  3495958263,
  1231636301,
  1047427035,
  2932959818,
  3654703836,
  1088359270,
  936918000,
  2847714899,
  3736837829,
  1202900863,
  817233897,
  3183342108,
  3401237130,
  1404277552,
  615818150,
  3134207493,
  3453421203,
  1423857449,
  601450431,
  3009837614,
  3294710456,
  1567103746,
  711928724,
  3020668471,
  3272380065,
  1510334235,
  755167117
];

class Inflate {
  InputStreamBase input;
  dynamic output;

  Inflate(List<int> bytes, [int uncompressedSize])
      : input = InputStream(bytes),
        output = OutputStream(size: uncompressedSize) {
    _inflate();
  }

  Inflate.buffer(this.input, [int uncompressedSize])
      : output = OutputStream(size: uncompressedSize) {
    _inflate();
  }

  Inflate.stream([this.input, dynamic output_stream])
      : output = output_stream ?? OutputStream() {
    _inflate();
  }

  void streamInput(List<int> bytes) {
    if (input is InputStream) {
      var i = input as InputStream;
      if (input != null) {
        i.offset = _blockPos;
      }
      final inputLen = (input == null ? 0 : input.length);
      final newLen = inputLen + bytes.length;
      final newBytes = Uint8List(newLen);
      if (input != null) {
        newBytes.setRange(0, input.length, i.buffer, i.offset);
      }
      newBytes.setRange(inputLen, newLen, bytes, 0);
      input = InputStream(newBytes);
    } else {
      input = InputStream(bytes);
    }
  }

  List<int> inflateNext() {
    _bitBuffer = 0;
    _bitBufferLen = 0;
    if (output is OutputStream) {
      output.clear();
    }
    if (input == null || input.isEOS) {
      return null;
    }

    try {
      if (input is InputStream) {
        var i = input as InputStream;
        _blockPos = i.offset;
      }
      _parseBlock();
      // If it didn't finish reading the block, it will have thrown an exception
      _blockPos = 0;
    } catch (e) {
      return null;
    }

    if (output is OutputStream) {
      return output.getBytes() as List<int>;
    }
    return null;
  }

  /// Get the decompressed data.
  List<int> getBytes() {
    return output.getBytes() as List<int>;
  }

  void _inflate() {
    _bitBuffer = 0;
    _bitBufferLen = 0;
    if (input == null) {
      return;
    }

    while (!input.isEOS) {
      final more = _parseBlock();
      if (!more) {
        break;
      }
    }
  }

  /// Parse deflated block.  Returns true if there is more to read, false
  /// if we're done.
  bool _parseBlock() {
    if (input.isEOS) {
      return false;
    }

    // Each block has a 3-bit header
    final hdr = _readBits(3);

    // BFINAL (is this the final block)?
    final bfinal = (hdr & 0x1) != 0;

    // BTYPE (the type of block)
    final btype = hdr >> 1;
    switch (btype) {
      case _BLOCK_UNCOMPRESSED:
        _parseUncompressedBlock();
        break;
      case _BLOCK_FIXED_HUFFMAN:
        _parseFixedHuffmanBlock();
        break;
      case _BLOCK_DYNAMIC_HUFFMAN:
        _parseDynamicHuffmanBlock();
        break;
      default:
      // reserved or other
        throw ArchiveException('unknown BTYPE: $btype');
    }

    // Continue while not the final block
    return !bfinal;
  }

  /// Read a number of bits from the input stream.
  int _readBits(int length) {
    if (length == 0) {
      return 0;
    }

    // not enough buffer
    while (_bitBufferLen < length) {
      if (input.isEOS) {
        throw ArchiveException('input buffer is broken');
      }

      // input byte
      final octet = input.readByte();

      // concat octet
      _bitBuffer |= octet << _bitBufferLen;
      _bitBufferLen += 8;
    }

    // output byte
    final octet = _bitBuffer & ((1 << length) - 1);
    _bitBuffer >>= length;
    _bitBufferLen -= length;

    return octet;
  }

  /// Read huffman code using [table].
  int _readCodeByTable(HuffmanTable table) {
    final codeTable = table.table;
    final maxCodeLength = table.maxCodeLength;

    // Not enough buffer
    while (_bitBufferLen < maxCodeLength) {
      if (input.isEOS) {
        break;
      }

      final octet = input.readByte();

      _bitBuffer |= octet << _bitBufferLen;
      _bitBufferLen += 8;
    }

    // read max length
    final codeWithLength = codeTable[_bitBuffer & ((1 << maxCodeLength) - 1)];
    final codeLength = codeWithLength >> 16;

    _bitBuffer >>= codeLength;
    _bitBufferLen -= codeLength;

    return codeWithLength & 0xffff;
  }

  void _parseUncompressedBlock() {
    // skip buffered header bits
    _bitBuffer = 0;
    _bitBufferLen = 0;

    final len = _readBits(16);
    final nlen = _readBits(16) ^ 0xffff;

    // Make sure the block size checksum is valid.
    if (len != 0 && len != nlen) {
      throw ArchiveException('Invalid uncompressed block header');
    }

    // check size
    if (len > input.length) {
      throw ArchiveException('Input buffer is broken');
    }

    output.writeInputStream(input.readBytes(len));
  }

  void _parseFixedHuffmanBlock() {
    _decodeHuffman(_fixedLiteralLengthTable, _fixedDistanceTable);
  }

  void _parseDynamicHuffmanBlock() {
    // number of literal and length codes.
    final numLitLengthCodes = _readBits(5) + 257;
    // number of distance codes.
    final numDistanceCodes = _readBits(5) + 1;
    // number of code lengths.
    final numCodeLengths = _readBits(4) + 4;

    // decode code lengths
    final codeLengths = Uint8List(_ORDER.length);
    for (var i = 0; i < numCodeLengths; ++i) {
      codeLengths[_ORDER[i]] = _readBits(3);
    }

    final codeLengthsTable = HuffmanTable(codeLengths);

    // literal and length code
    final litlenLengths = Uint8List(numLitLengthCodes);

    // distance code
    final distLengths = Uint8List(numDistanceCodes);

    final litlen =
    _decode(numLitLengthCodes, codeLengthsTable, litlenLengths);

    final dist = _decode(numDistanceCodes, codeLengthsTable, distLengths);

    _decodeHuffman(HuffmanTable(litlen), HuffmanTable(dist));
  }

  void _decodeHuffman(HuffmanTable litlen, HuffmanTable dist) {
    while (true) {
      final code = _readCodeByTable(litlen);

      if (code < 0 || code > 285) {
        throw ArchiveException('Invalid Huffman Code $code');
      }

      // 256 - End of Huffman block
      if (code == 256) {
        break;
      }

      // [0, 255] - Literal
      if (code < 256) {
        output.writeByte(code & 0xff);
        continue;
      }

      // [257, 285] Dictionary Lookup
      // length code
      final ti = code - 257;

      var codeLength =
          _LENGTH_CODE_TABLE[ti] + _readBits(_LENGTH_EXTRA_TABLE[ti]);

      // distance code
      final distCode = _readCodeByTable(dist);
      if (distCode >= 0 && distCode <= 29) {
        final distance =
            _DIST_CODE_TABLE[distCode] + _readBits(_DIST_EXTRA_TABLE[distCode]);

        // lz77 decode
        while (codeLength > distance) {
          output.writeBytes(output.subset(-distance));
          codeLength -= distance;
        }

        if (codeLength == distance) {
          output.writeBytes(output.subset(-distance));
        } else {
          output.writeBytes(output.subset(-distance, codeLength - distance));
        }
      } else {
        throw ArchiveException('Illegal unused distance symbol');
      }
    }

    while (_bitBufferLen >= 8) {
      _bitBufferLen -= 8;
      input.rewind(1);
    }
  }

  List<int> _decode(int num, HuffmanTable table, List<int> lengths) {
    var prev = 0;
    var i = 0;
    while (i < num) {
      final code = _readCodeByTable(table);
      switch (code) {
        case 16:
        // Repeat last code
          var repeat = 3 + _readBits(2);
          while (repeat-- > 0) {
            lengths[i++] = prev;
          }
          break;
        case 17:
        // Repeat 0
          var repeat = 3 + _readBits(3);
          while (repeat-- > 0) {
            lengths[i++] = 0;
          }
          prev = 0;
          break;
        case 18:
        // Repeat lots of 0s.
          var repeat = 11 + _readBits(7);
          while (repeat-- > 0) {
            lengths[i++] = 0;
          }
          prev = 0;
          break;
        default: // [0, 15]
        // Literal bitlength for this code.
          if (code < 0 || code > 15) {
            throw ArchiveException('Invalid Huffman Code: $code');
          }
          lengths[i++] = code;
          prev = code;
          break;
      }
    }

    return lengths;
  }

  int _bitBuffer = 0;
  int _bitBufferLen = 0;
  int _blockPos = 0;

  // enum BlockType
  static const int _BLOCK_UNCOMPRESSED = 0;
  static const int _BLOCK_FIXED_HUFFMAN = 1;
  static const int _BLOCK_DYNAMIC_HUFFMAN = 2;

  /// Fixed huffman length code table
  static const List<int> _FIXED_LITERAL_LENGTHS = [
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8
  ];
  final HuffmanTable _fixedLiteralLengthTable =
  HuffmanTable(_FIXED_LITERAL_LENGTHS);

  /// Fixed huffman distance code table
  static const List<int> _FIXED_DISTANCE_TABLE = [
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5
  ];
  final HuffmanTable _fixedDistanceTable =
  HuffmanTable(_FIXED_DISTANCE_TABLE);

  /// Max backward length for LZ77.
  static const int _MAX_BACKWARD_LENGTH = 32768; // ignore: unused_field

  /// Max copy length for LZ77.
  static const int _MAX_COPY_LENGTH = 258; // ignore: unused_field

  /// Huffman order
  static const List<int> _ORDER = [
    16,
    17,
    18,
    0,
    8,
    7,
    9,
    6,
    10,
    5,
    11,
    4,
    12,
    3,
    13,
    2,
    14,
    1,
    15
  ];

  /// Huffman length code table.
  static const List<int> _LENGTH_CODE_TABLE = [
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    13,
    15,
    17,
    19,
    23,
    27,
    31,
    35,
    43,
    51,
    59,
    67,
    83,
    99,
    115,
    131,
    163,
    195,
    227,
    258
  ];

  /// Huffman length extra-bits table.
  static const List<int> _LENGTH_EXTRA_TABLE = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    1,
    2,
    2,
    2,
    2,
    3,
    3,
    3,
    3,
    4,
    4,
    4,
    4,
    5,
    5,
    5,
    5,
    0,
    0,
    0
  ];

  /// Huffman dist code table.
  static const List<int> _DIST_CODE_TABLE = [
    1,
    2,
    3,
    4,
    5,
    7,
    9,
    13,
    17,
    25,
    33,
    49,
    65,
    97,
    129,
    193,
    257,
    385,
    513,
    769,
    1025,
    1537,
    2049,
    3073,
    4097,
    6145,
    8193,
    12289,
    16385,
    24577
  ];

  /// Huffman dist extra-bits table.
  static const List<int> _DIST_EXTRA_TABLE = [
    0,
    0,
    0,
    0,
    1,
    1,
    2,
    2,
    3,
    3,
    4,
    4,
    5,
    5,
    6,
    6,
    7,
    7,
    8,
    8,
    9,
    9,
    10,
    10,
    11,
    11,
    12,
    12,
    13,
    13
  ];
}
/// Build huffman table from length list.
class HuffmanTable {
  Uint32List table;
  int maxCodeLength = 0;
  int minCodeLength = 0x7fffffff;

  HuffmanTable(List<int> lengths) {
    final listSize = lengths.length;

    for (var i = 0; i < listSize; ++i) {
      if (lengths[i] > maxCodeLength) {
        maxCodeLength = lengths[i];
      }
      if (lengths[i] < minCodeLength) {
        minCodeLength = lengths[i];
      }
    }

    final size = 1 << maxCodeLength;
    table = Uint32List(size);

    for (var bitLength = 1, code = 0, skip = 2; bitLength <= maxCodeLength;) {
      for (var i = 0; i < listSize; ++i) {
        if (lengths[i] == bitLength) {
          var reversed = 0;
          var rtemp = code;
          for (var j = 0; j < bitLength; ++j) {
            reversed = (reversed << 1) | (rtemp & 1);
            rtemp >>= 1;
          }

          for (var j = reversed; j < size; j += skip) {
            table[j] = (bitLength << 16) | i;
          }

          ++code;
        }
      }

      ++bitLength;
      code <<= 1;
      skip <<= 1;
    }
  }
}
class Base64Util {
  static final List<String> _base64Char = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "+", "/",
  ];

  static List<int> base64Decoder(String str) {
    /**
     * 由于后台说sun公司的某些旧的包处理出来的base64字符串包含换行符，所以先将其删除
     */
    str = str.replaceAll("\n", "");
    List<int> list = List();
    /**
     * 由于需要将传入的字符串按4字节分组，需要先判断其长度是否为4的整数倍
     */
    if (str.length % 4 == 0) {
      /**
       * 循环取字符串的字符，每次取4个
       */
      for (int i = 0; i < str.length; i += 4) {
        String char1 = str.substring(i, i + 1);
        String char2 = str.substring(i + 1, i + 2);
        String char3 = str.substring(i + 2, i + 3);
        String char4 = str.substring(i + 3, i + 4);

        /**
         * 将取出的字符按照字码表进行转换成数字，当为等于号时，则不进行处理，因为等于号是填充符
         */
        int code1 = _base64Char.indexOf(char1);
        int code2 = _base64Char.indexOf(char2);
        int code3;
        if ("=" != char3) {
          code3 = _base64Char.indexOf(char3);
        }
        int code4;
        if ("=" != char4) {
          code4 = _base64Char.indexOf(char4);
        }

        /**
         * 将转换后的数字进行分割处理，当对应字符为等于号，则不进行分割处理
         */
        /**
         * 将第一个字节与0x3F，得到低6位，然后左移2位，腾出低2位的位置
         * 然后将第二个字节与0x30，清除高2位和低4位，再右移4位，
         * 与前一个高6位相加，得到第一个新字节
         */
        int decode1 = ((code1 & 0x3F) << 2) + ((code2 & 0x30) >> 4);
        /**
         * 将第二个字节与0x0F，得到低4位，然后左移4位，腾出低4位的位置
         * 然后将第三个字节与0x3C，清除高2位和低2位，再右移2位，
         * 与前一个高4位相加，得到第二个新字节
         */
        int decode2;
        if ("=" != char3) {
          decode2 = ((code2 & 0x0F) << 4) + ((code3 & 0x3C) >> 2);
        }
        /**
         * 将第三个字节与0x03，得到低2位，然后左移6位，腾出低6位的位置
         * 然后直接与第四个字节相加，得到第三个新字节
         */
        int decode3;
        if ("=" != char4) {
          decode3 = ((code3 & 0x03) << 6) + code4;
        }

        list.add(decode1);
        if ("=" != char3) {
          list.add(decode2);
        }
        if ("=" != char4) {
          list.add(decode3);
        }
      }
    }
    return list;
  }

  static String base64Encoder(List<int> list) {
    StringBuffer sb = StringBuffer();
    /**
     * 由于需要将传入的数组按3字节分组，所以先处理3的最大整数倍的长度的内容
     */
    int remainder = list.length % 3;
    int size = list.length - remainder;
    /**
     * 循环取数组里的字节，每次取3个
     */
    for (int i = 0; i < size; i += 3) {
      int code1 = list[i];
      int code2 = list[i + 1];
      int code3 = list[i + 2];
      /**
       * 首先将第一字节右移2位，得到左6位，与上0x3F，高2位置0，得到第一个6位
       * 然后在编码表里进行转码，得到新组的第一字节
       */
      int encode1 = (code1 >> 2) & 0x3F;
      /**
       * 接着将第一字节与0x03，即00000011，得到低2位，然后左移4位，
       * 然后将第二字节右移4位，做加法运算，得到第二个6位，转码得到新组的第二字节
       */
      int encode2 = ((code1 & 0x03) << 4) + ((code2 >> 4) & 0x0F);
      /**
       * 将第二字节与0x0F，即00001111，得到低4位，然后左移2位，
       * 然后将第三字节右移6位，得到高2位，做加法运算，得到第三个6位，转码得到新组的第三字节
       */
      int encode3 = ((code2 & 0x0F) << 2) + ((code3 >> 6) & 0x03);
      /**
       * 最后将第三字节与上0x3F，清除高2位，得到低6位，即第四个6位，转码得到新组的第四字节
       */
      int encode4 = code3 & 0x3F;

      String char1 = _base64Char[encode1];
      String char2 = _base64Char[encode2];
      String char3 = _base64Char[encode3];
      String char4 = _base64Char[encode4];

      sb.write(char1);
      sb.write(char2);
      sb.write(char3);
      sb.write(char4);
    }
    /**
     * 当原文不是3的整数倍时，则需要继续处理多出的1或2个字节
     */
    if (remainder != 0) {
      /**
       * 既然多出内容，那么至少多一个，所以第一字节直接取
       * 对第二字节需要判断
       */
      int code1 = list[size];
      int code2 = 0;
      if (remainder == 2) {
        code2 = list[size + 1];
      }
      /**
       * 新组第一二字节可直接取6位然后转码
       */
      int encode1 = (code1 >> 2) & 0x3F;
      int encode2 = ((code1 & 0x03) << 4) + ((code2 >> 4) & 0x0F);
      String char1 = _base64Char[encode1];
      String char2 = _base64Char[encode2];
      /**
       * 如果原文只多出1字节，那么新组第三字节肯定为0，那么按照规则，空字符用 '=' 代替
       * 如果多出2字节，则还继续进行取6位、转码的运算，
       */
      int encode3;
      String char3 = "=";
      if (remainder == 2) {
        encode3 = (code2 & 0x0F) << 2;
        char3 = _base64Char[encode3];
      }
      /**
       * 由于最多多出2字节，所以新组第四字节肯定没有值可以取，也就是空字符，所以直接转换为 '='
       */
      String char4 = "=";

      sb.write(char1);
      sb.write(char2);
      sb.write(char3);
      sb.write(char4);
    }

    return sb.toString();
  }
}