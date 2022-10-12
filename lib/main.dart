import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //设置全局的下拉刷新属性
    return RefreshConfiguration(
      headerBuilder: () => const ClassicHeader(),// 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
      footerBuilder:  () => const ClassicFooter(),// 配置默认底部指示器
      headerTriggerDistance: 60.0,  // 头部触发刷新的越界距离
      footerTriggerDistance: 100, //底部触发刷新的越界距离,距离底部多少开始刷新
      springDescription: const SpringDescription(stiffness: 170, damping: 16, mass: 1.9), //弹性参数，劲度系数、阻尼、质量
      maxOverScrollExtent :100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
      maxUnderScrollExtent: 0, // 底部最大可以拖动的范围，0默认底部不能往上拖拽
      enableScrollWhenRefreshCompleted: true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
      enableLoadingWhenFailed : true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
      hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
      enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
      child: MaterialApp(
        title: 'Flutter Refresh Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              toolbarHeight: 44,
            )
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//使用默认的全局效果
class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: true); //为true默认触发下拉刷新

  int count = 0;

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      count = 10;
    });
    _refreshController.refreshCompleted(); //标识刷新完成
  }

  Future loadMore() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      count += 10;
    });
    _refreshController.loadComplete(); //标识加载更多完成
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        actions: [
          MaterialButton(
            minWidth: 44,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => const DetailPage()));
            },
            child: const Text("全局refresh", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: onRefresh,
        onLoading: loadMore,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
            );
          },
          itemCount: count,
          itemExtent: 80,
        ),
      )
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

//变更局部刷新效果
class _DetailPageState extends State<DetailPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false); //为 false 默认不出发刷新

  int count = 0;

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      count = 10;
    });
    _refreshController.refreshCompleted();
  }

  Future loadMore() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      count += 10;
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DetailPage"),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        header: const WaterDropHeader(), //当前页面更换一个下拉刷新效果，选一个瀑布流吧
        onRefresh: onRefresh,
        onLoading: loadMore,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
            );
          },
          itemCount: count,
          itemExtent: 80,
        ),
      )
    );
  }
}


