
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milk/resources/resources.dart';
import 'package:milk/views/chats/expanded_viewport.dart';
import 'package:milk/widgets/my_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
   实现聊天列表+加载更多功能,类似于qq那种加载效果
   聊天列表最大的难点就是在列表不满一屏时,要把它往上压。目前来说,flutter没有提供这类sliver能把剩余空间(上和下)给占有,类似于Expanded,
   SliverFillRemaing并没有起作用。
   ExpandedViewport是我自定义Viewport,用来解决当不满一屏时reverseListView要居于顶部的问题(只适用于少数情况),原理就是第一次
   布局先探测一下他们的布局情况,第二次布局假如不满一屏,就在SliverExpanded后面的所有slivers调整主轴偏距。
 */
class QQChatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QQChatListState();
  }
}

const String myUrl =
    "https://avatars1.githubusercontent.com/u/19425362?s=400&u=1a30f9fdf71cc9a51e20729b2fa1410c710d0f2f&v=4";

class _QQChatListState extends State<QQChatList> {
  RefreshController _refreshController = RefreshController();
  ScrollController _scrollController = ScrollController();
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();
  TextEditingController _textController = TextEditingController();
  List<_MessageItem> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("XXXXX",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        leading:GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 20,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Icon(
            Icons.group,
            color: Colors.grey,
            size: 24,
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SmartRefresher(
                enablePullDown: false,
                onLoading: () async {
                  await Future.delayed(Duration(milliseconds: 1000));
                  _sendMessage(true,text: "hello");
                  _sendMessage(false,text: "hello !");
                  _sendMessage(false,text: "can you be my grilfriend !");
                  _refreshController.loadComplete();
                },
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowAlways,
                  builder: (context, mode) {
                    if (mode == LoadStatus.loading) {
                      return Container(
                        height: 60.0,
                        child: Container(
                          height: 20.0,
                          width: 20.0,
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    } else
                      return Container();
                  },
                ),
                enablePullUp: true,
                child: Scrollable(
                  controller: _scrollController,
                  axisDirection: AxisDirection.up,
                  viewportBuilder: (context, offset) {
                    return ExpandedViewport(
                      offset: offset,
                      axisDirection: AxisDirection.up,
                      slivers: <Widget>[
                        SliverExpanded(),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                  (c, i) => data[i],
                              childCount: data.length),
                        )
                      ],
                    );
                  },
                ),
                controller: _refreshController,
              ),
            ),
            Container(
              color: Colors.white,
              height: 56.0,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () async {
                        File imageFile = await ImagePicker.pickImage();
                        int random = new Random().nextInt(100000);
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Text("上传原图中〜请稍候！"),
                        ));
                      }
                  ),
                  Expanded(
                    child: Container(
                      child: CupertinoTextField(
                        controller: _textController,
                        placeholder: "输入你想发送的信息",
                        onSubmitted: (s) {
                          _sendMessage(true,text:s);
                        },
                      ),
                      margin: EdgeInsets.all(10.0),
                    ),
                  ),
                  RaisedButton(
                    child: Text("发送"),
                    color: Theme.of(context).backgroundColor,
                    onPressed: () {
                      _sendMessage(true,text:_textController.text);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
  void _sendMessage(bool isMe,{String text,String imageUrl,author:"未知",url:myUrl}){
    data.insert(0,_MessageItem(
      content: text,
      isMe: isMe,
      author: author,
      url: url,
    ));
    setState(() {});
    _scrollController.jumpTo(0.0);
    _textController.clear();
  }
}


class _MessageItem extends StatelessWidget {
  final String content;
  final String author;
  final bool isMe;
  final String url;

  _MessageItem({this.content, this.author, this.isMe, this.url});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Wrap(
        textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(url),
            radius: 20.0,
          ),
          Container(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 25.0,
                width: 222.0,
                alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                child: Text(
                  author,
                  style: TextStyle(color: Colors.grey, fontSize: 16,decoration: TextDecoration.none,),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  minWidth: 20.0,
                  minHeight: 20.0,
                  maxWidth: 222.0,
                ),
                alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  content,
                  style:TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: Dimens.font_sp14,
                      color: Colours.text,
                      // https://github.com/flutter/flutter/issues/40248
                      textBaseline: TextBaseline.alphabetic
                  ),
                ),
                padding: EdgeInsets.all(10.0),
              )
            ],
          )
        ],
      ),
    );
  }
}