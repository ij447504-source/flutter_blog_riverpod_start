import 'package:flutter/material.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_body.dart';
import 'package:flutter_blog/ui/widgets/custom_navigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListPage extends ConsumerWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    SessionUser sessionUser = ref.read(sessionProvider);//값이 있으면 로그인된것 


    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigation(scaffoldKey),
      appBar: AppBar(
        title: Text("Blog ${sessionUser.username ?? "로긴안됨"}"),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
        },
        child: PostListBody(),
      ),
    );
  }
}
