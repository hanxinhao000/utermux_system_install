

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http_server/http_server.dart';
import 'package:utermux_system_install/utils/UUtils.dart';

class MainActivity extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(


        accentColor: Colors.blue
      ),
      home: MainActivityState(),

    );
  }
}

class MainActivityState extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return MainActivityView();
  }



}

class MainActivityView extends State<MainActivityState> {

  String loading = "0%";
  String vision = "v32";
  String msg = "开始日志:";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text("本地下载服务器($vision)"),
      ),

      body:Container(
        
        margin: EdgeInsets.fromLTRB(UUScreenUtil.xp2dpW(context, 20), 0, UUScreenUtil.xp2dpW(context, 20), 0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
              margin: EdgeInsets.fromLTRB(0, UUScreenUtil.xp2dpH(context, 20), 0, 0),
              child:  Stack(
                children: <Widget>[
                  Align(
                    child: Text("Utermux系统本地服务器($vision)",style: TextStyle(fontSize: UUScreenUtil.xp2sp(context, 16),color: UUtils.getColor(0x10202f)),),
                    alignment: Alignment.center,
                  )
                ],

              ),
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, UUScreenUtil.xp2dpH(context, 20), 0, 0),
                child:  Stack(
                  children: <Widget>[
                    Align(

                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Image.asset("assets/github.png",width: UUScreenUtil.xp2dpW(context, 20),height: UUScreenUtil.xp2dpH(context, 20),),
                         Container(
                           margin: EdgeInsets.fromLTRB(UUScreenUtil.xp2dpW(context, 20), 0, 0, 0),
                           child:  Text("GITHUB地址",style: TextStyle(fontSize: UUScreenUtil.xp2sp(context, 14),color: UUtils.getColor(0x10202f)),),

                         )

                        ],

                      ),
                      alignment: Alignment.center,
                    )
                  ],

                ),
              ),
              onTap: (){

                jumpllq();

              },

            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, UUScreenUtil.xp2dpH(context, 20), 0, 0),
              child:  Stack(
                children: <Widget>[
                  Align(
                    child: Text("服务器准备状态",style: TextStyle(fontSize: UUScreenUtil.xp2sp(context, 14),color: UUtils.getColor(0x10202f)),),
                    alignment: Alignment.center,
                  )
                ],

              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, UUScreenUtil.xp2dpH(context, 20), 0, 0),
              child:  Stack(
                children: <Widget>[
                  Align(
                    child: Text("${loading}",style: TextStyle(fontSize: UUScreenUtil.xp2sp(context, 25),color: UUtils.getColor(0x10202f)),),
                    alignment: Alignment.center,
                  )
                ],

              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(0, UUScreenUtil.xp2dpH(context, 20), 0, UUScreenUtil.xp2dpH(context, 30)),
              child:  Stack(
                children: <Widget>[
                  Align(
                    child: Text("日志",style: TextStyle(fontSize: UUScreenUtil.xp2sp(context, 10),color: UUtils.getColor(0x10202f)),),
                    alignment: Alignment.center,
                  )
                ],

              ),
            ),

            Expanded(

             child: Container(

               margin: EdgeInsets.fromLTRB(0, 0, 0, UUScreenUtil.xp2dpH(context, 30)),

               child:  UUtils.scrollViewIOS2Android(<Widget>[

                 Text(msg,style: TextStyle(fontSize: UUScreenUtil.xp2sp(context, 10),color: UUtils.getColor(0x10202f)),),




               ]),

             ),

            )



          ],

        ),
        
      ),

    );
  }

  @override
  void initState() {
    writerFiles();
    //开启服务器
    main();
  }

  void writerFiles() async{


    UUtils.getIosApplicationDocumentsDirectory((path) async{


      UUtils.sleepThread(2000, () async {

        File _sdFilePath = File("$path/utermux/");

        File _sdFilePathAarch64 = File("$path/utermux/bootstrap-aarch64-v32.zip");
        File _sdFilePathArm = File("$path/utermux/bootstrap-arm-v32.zip");
        File _sdFilePathI686 = File("$path/utermux/bootstrap-i686-v32.zip");
        File _sdFilePathX86_64 = File("$path/utermux/bootstrap-x86_64-v32.zip");

        try {
          var exists = await _sdFilePath.exists();

          if (!exists) {
            setState(() {

              msg +="创建目录${_sdFilePath.path}\n";
            });
            UUtils.mkdir(_sdFilePath);
          }

          setState(() {
            loading = "25%";
            msg +="写出文件:${_sdFilePathAarch64.path}\n";
          });

          if(!(await _sdFilePathAarch64.exists())){
        UUtils.assetsWriterFile("assets/bootstrap_aarch64_v32.zip", _sdFilePathAarch64);
        setState(() {
        msg +="写出文件:${_sdFilePathArm.path}\n";

        });
        }else{

        setState(() {
        msg +="文件已存在:${_sdFilePathAarch64.path}\n";
        });

        }
        setState(() {
        loading = "50%";
        });
        if(!(await _sdFilePathArm.exists())){
        UUtils.assetsWriterFile("assets/bootstrap-arm-v32.zip", _sdFilePathArm);
        setState(() {

        msg +="写出文件:${_sdFilePathI686.path}\n";
        });
        }else{
        setState(() {
        msg +="文件已存在:${_sdFilePathI686.path}\n";

        });

        }
        setState(() {
        loading = "75%";

        });
        if(!(await _sdFilePathI686.exists())){
        UUtils.assetsWriterFile("assets/bootstrap-i686-v32.zip", _sdFilePathI686);
        setState(() {

        msg +="写出文件:${_sdFilePathX86_64.path}\n";
        });
        }else{
        setState(() {

        msg +="文件已存在:${_sdFilePathX86_64.path}\n";

        });
        }
        setState(() {
        loading = "100%";

        });
        if(!(await _sdFilePathX86_64.exists())){
        UUtils.assetsWriterFile("assets/bootstrap-x86_64-v32.zip", _sdFilePathX86_64);
        setState(() {

        msg +="写出文件:${_sdFilePathX86_64.path}\n";
        });
        }else{
        setState(() {
        msg +="文件已存在:${_sdFilePathX86_64.path}\n";

        });
        }

        setState(() {
        loading = "准备完成\n请打开Utermux开始使用";
        msg +="所有操作均已完成\n";
        msg +="服务器已开启\n";
        });

        }catch(e){
        UUtils.showLog(e);
        setState(() {
        msg +="操作失败,失败信息:$e\n请反馈或重新安装\n";
        });
        }



      });






    });


  }

  //跳转到浏览器
  void jumpllq(){



    UUtils.launchUrl("https://github.com/hanxinhao000/utermux_system_install", (){

      setState(() {

        UUtils.showMsg("无效的url");

      });
    });
    


  }


  VirtualDirectory virDir;

  void directoryHandler(dir, request) {
    //获取文件的路径
    var indexUri = new Uri.file(dir.path).resolve('index.html');
    //返回指定的文件
    virDir.serveFile(new File(indexUri.toFilePath()), request);
  }

  main() {
    UUtils.getIosApplicationDocumentsDirectory((path){
      virDir = new VirtualDirectory(path)
        ..allowDirectoryListing = true;
      // ..errorPageHandler = errorPageHandler;
    });

    //用指定的文件覆盖默认返回的目录清单


    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 19955).then((server){
      server.listen((request){
        virDir.serveRequest(request);
      });
    });
  }

  //404错误的处理方法
  void errorPageHandler(HttpRequest request) {
    request.response
    //设置状态码，如果没有设置则默认HttpStatus.OK
      ..statusCode = HttpStatus.NOT_FOUND
      ..write('没有找到相关内容')
      ..close();
  }
}