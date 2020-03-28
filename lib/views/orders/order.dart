import 'package:flutter/material.dart';
import 'package:milk/widgets/order_item.dart';
import 'package:milk/widgets/order_tag_item.dart';
import 'package:milk/widgets/refresh_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class OrderPage extends StatefulWidget{

  @override
  State createState() {
    return _OrderPageState();
  }
}
class _OrderPageState extends State<OrderPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  int _page=1;
  List _list = [];


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
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer:
        CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = MoreWidget(true);//CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else if(mode==LoadStatus.noMore){
              body =MoreWidget(false);// Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (c, index){
            return index % 5 == 0 ? OrderTagItem(date: '2019年2月5日', orderTotal: 4) : OrderItem(key: Key('order_item_$index'), index: index, tabIndex: 0,);
          },
          itemCount: _list.length,
        ),
      ),
    );
  }


}