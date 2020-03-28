import 'package:flutter/material.dart';

import 'package:milk/resources/colors.dart';
import 'package:milk/routers/fluro_navigator.dart';
import 'package:milk/views/chats/group_chat_list.dart';
import 'package:milk/views/login/login_page.dart';
import 'package:milk/widgets/load_image.dart';

import 'orders/order.dart';
class AppPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}
class _MyHomePageState extends State<AppPage> with SingleTickerProviderStateMixin{
  var _appBarTitles = ['动态', '任务', '消息', '我的'];
  int _currentIndex=0;
  final _pageController = PageController();
  var _pageList;

  @override
  void initState() {
    super.initState();
    initData();
  }
  void initData() {
    _pageList = [
      LoginPage(),
      OrderPage(),
      GroupChatList(),
      LoginPage(),
    ];
  }
  @override
  void dispose() {
    super.dispose();
  }

  Widget MaterialSearchInput(String placeholder){
    return new InkWell(
      onTap:   () {
        NavigatorUtils.push(context, "add");
      },
      child: new FormField(
        builder: (FormFieldState field) {
          return new InputDecorator(
            decoration: new InputDecoration(
              labelText: placeholder,
              border: InputBorder.none,
              errorText: field.errorText,
            ),
            child: null
          );
        },
      ),
    );
  }
  Widget buildSearchInput(BuildContext context) {
    return new Container(
      height: 40.0,
      decoration: BoxDecoration(
          color: Colours.bg_color,
          borderRadius: BorderRadius.circular(4.0)),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(right: 10.0, top: 3.0, left: 10.0),
            child: new Icon(Icons.search,
                size: 24.0, color: Theme.of(context).accentColor),
          ),
          new Expanded(
            child: MaterialSearchInput("搜索")
          ),
        ],
      ),
    );
  }
  renderAppBar(BuildContext context,Widget widget,int index){
    if (index == 1 ) {
      return AppBar(
        centerTitle: true,
        title: buildSearchInput(context),
        actions: <Widget>[
          IconButton(
            tooltip: '添加商品',
            onPressed: () {
              NavigatorUtils.push(context, "add");
              },
            icon: LoadAssetImage(
              'goods/add',
              key: const Key('add'),
              width: 24.0,
              height: 24.0,
            ),
          )
        ],
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: renderAppBar(context,widget,_currentIndex),
      body: PageView.builder(
        itemBuilder: (ctx, index) => _pageList[index],
        itemCount: _pageList.length,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(_appBarTitles[0]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text(_appBarTitles[1]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            title: Text(_appBarTitles[2]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_split),
            title: Text(_appBarTitles[3]),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}