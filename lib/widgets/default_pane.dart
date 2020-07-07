import 'package:flutter/material.dart';

class Default extends StatefulWidget {
  @override
  _DefaultState createState() => _DefaultState();
}

class _DefaultState extends State<Default> with TickerProviderStateMixin {

  // _DefaultState({this._tween, this._controller, _this._height, this.descTextStyle, this.nameTextStyle});

  AnimationController _controller, _iconController;
  BorderRadiusTween borderRadius;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  double _height = 0.3, min = 0.1, initial = 0.4, max = 1;



final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 2,
  );

    final nameTextStyle = TextStyle(
    color: Colors.black54,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 2,
  );
    final topTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
  );


  @override
  void initState() {
    super.initState();
      // getsomePoints();
    // _getUserLocation();
    _controller = AnimationController(vsync: this, duration: _duration);
    _iconController = AnimationController(vsync: this, duration: _duration);
    borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(10.0),
      end: BorderRadius.circular(0.0),
    );

      _controller.forward();//changing the state of the footer show


  }


  @override
  Widget build(BuildContext context) {
    return textPane();
  }

Widget textPane() {

  return SizedBox.expand(
              child: SlideTransition(
                position: _tween.animate(_controller),
                child: DraggableScrollableSheet(
                  minChildSize: 0.1, // 0.1 times of available height, sheet can't go below this on dragging
                  maxChildSize: 0.6, // 0.7 times of available height, sheet can't go above this on dragging
                  initialChildSize: _height, // 0.1 times of available height, sheet start at this size when opened for first time 0.3
                  builder: (BuildContext context, ScrollController controller) {
                    // if (controller.hasClients) {
                    //   var dimension = controller.position.viewportDimension;
                    //   _height ??= dimension / 0.2;
                    // }
                    return AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return textBox();
                        // return testing();
                      },
                    );
                  },
                ),
              ),
    );
}

  Widget textBox() {
    return Container(
      color: Colors.white,
        child: CustomScrollView(
          // controller: controller,
        
          slivers: <Widget>[
            SliverAppBar(
              title: Text("Where do you want a doctor?"),
              backgroundColor:Colors.blue[400],
              automaticallyImplyLeading: false,
              primary: false,
              floating: true,
              
              pinned: true,
              elevation: 8,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, idx) =>  Container(
                      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      // color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          TextField(
                            textInputAction: TextInputAction.search,
                            // controller:  locationController,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueAccent,
                            ),
                            decoration:  InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon: Icon(Icons.search, size: 26,),
                                hintText: "Search address",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 32.0),
                                    borderRadius: BorderRadius.circular(13.0),
                                      ),
                                  ),
                            onTap: () {
                              setState(() {
                                _height = 0.5;
                                print('tttttttttttttttttttttttttttttttt-------------------------------$_height');
                              });
                            },
                          ),
                        ],
                      ),
                      

            ),
            childCount: 1),
            )
          ],
        )
    );
  }

}



