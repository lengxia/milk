import 'package:flutter/material.dart';
import 'package:milk/utils/image_utils.dart';
import 'package:milk/views/chats/chat_screen.dart';
import 'package:milk/widgets/app_bar.dart';
import 'package:milk/widgets/my_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupChatList extends StatefulWidget{

  @override
  State createState() {
    return _GropuChatListState();
  }
}
class _GropuChatListState extends State<GroupChatList>{

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List _list = [];
  int _page=1;
  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Future _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      _page = 1;
      _list = List.generate(10, (i) => 'newItem：$i');
      _refreshController.refreshCompleted(resetFooterState: true);
      resets();
    });

  }
  resets(){
    if(mounted){
      setState((){});
    }
  }


  void _onLoading() async {
    await Future.delayed(Duration(seconds: 2), () {
      if(_page>=2){
        _refreshController.loadNoData();
        resets();
      }else{
        _list.addAll(List.generate(10, (i) => 'newItem：$i'));
        _page ++;
        _refreshController.loadComplete();
        resets();

      }

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        new AppBar(
          title: new Text("聊天"),
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.0,
            actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
            )
          ],
        ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (c, index){
            return GroupChatListBodyItem();
          },
          itemCount: _list.length,
        ),
      ),
    );
  }

}

class GroupChatListBodyItem extends StatelessWidget {
  GroupChatListBodyItem({
    this.name:"dsa",
    this.lastMessage:"dsa",
    this.timestamp:"dsa",
    this.messages:"dsa",
    this.myName:"dsa",
    this.myPhone:"dsa",
    this.shePhone:"dsa",
    this.shePortrait:"dsa",
    this.myPortrait:"dsa",
  });
  final String name;
  final String lastMessage;
  final String timestamp;
  final String messages;
  final String myName;
  final String myPhone;
  final String shePhone;
  final String shePortrait;
  final String myPortrait;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return  QQChatList();
              },
            ));
          },
          child: new Container(
              margin: const EdgeInsets.only(top: 8.0),
              decoration: new BoxDecoration(),
              padding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: new Row(
                children: <Widget>[
                  new CircleAvatar(
                      backgroundImage: ImageUtils.getAssetImage('state/zwxx')
                  ),
                  new Flexible(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text("  " + name, textScaleFactor: 1.2),
                                new Text((timestamp),
                                    textAlign: TextAlign.right,
                                    style: new TextStyle(
                                        color: Theme.of(context).hintColor)),
                              ]),
                          new Container(
                              padding: new EdgeInsets.only(top: 2.0),
                              child: new Text("  " + lastMessage,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      color: Theme.of(context).hintColor))),
                        ],
                      ))
                ],
              ))),
    );
  }
}