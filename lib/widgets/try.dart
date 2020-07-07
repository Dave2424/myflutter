import 'package:flutter/material.dart';

class Try extends StatefulWidget {
  @override
  _TryState createState() => _TryState();
}

class _TryState extends State<Try> {
  final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontFamily: 'Lato',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 1,
  );
  ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          TransitionAppBar(
            extent: 400,     
            avatar: Text('This is nmy title'),
            title: Container(
              // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))
                    ),
                  // borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Icon(Icons.search),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    cursorColor: Colors.black,
                    autofocus: false,
                    style: descTextStyle,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 1),
                        hintText: "Search address",
                        border: InputBorder.none,
                        disabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.transparent),
                          borderRadius: new BorderRadius.circular(2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.transparent),
                          borderRadius: new BorderRadius.circular(2),
                        )),
                        onSubmitted: (value) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        onTap: () {
                          _controller.animateTo(200.0,
                                  curve: Curves.linear, duration: Duration (milliseconds: 100));
                        },
                        
                  ),
                )
              ]),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
                color: Colors.white,
                child: ListTile(
                  title: Text("${index}a"),
                ));
          }, childCount: 25))
        ],
      ),
    );
  } 
}

class TransitionAppBar extends StatelessWidget {
  final Widget avatar;
  final Widget title;
  final double extent;

  TransitionAppBar({this.avatar, this.title, this.extent = 250, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
        avatar: avatar,
        title: title,
        extent: extent > 300 ? extent : 300
      ),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final _avatarMarginTween = EdgeInsetsTween(
      begin: EdgeInsets.only(bottom: 70, left: 30),
      end: EdgeInsets.only(left: 0.0, top: 30.0));
  // final _avatarAlignTween =
  //     AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topCenter);

  final Widget avatar;
  final Widget title;
  final double extent;

  _TransitionAppBarDelegate({this.avatar, this.title, this.extent = 250})
      : assert(avatar != null),
        assert(extent == null || extent >= 300),
        assert(title != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // double tempVal = 30 * maxExtent / 100;
    // final progress =  shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    // print("Objechjkf === ${progress} ${shrinkOffset}");
    // final avatarMargin = _avatarMarginTween.lerp(progress);
    // final avatarAlign = _avatarAlignTween.lerp(progress);

    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 700),
          height: shrinkOffset * 2,
          constraints: BoxConstraints(maxHeight: minExtent),
          color: Colors.blue[400],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: title,
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => (maxExtent * 45) / 100;

  @override
  bool shouldRebuild(_TransitionAppBarDelegate oldDelegate) {
    return avatar != oldDelegate.avatar || title != oldDelegate.title;
  }
} 
