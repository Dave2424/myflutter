import 'package:flutter/material.dart';


Widget textPane(_tween, _controller, _height, TextStyle descTextStyle, TextStyle nameTextStyle) {

  return SizedBox.expand(
              child: SlideTransition(
                position: _tween.animate(_controller),
                child: DraggableScrollableSheet(
                  minChildSize: 0.1, // 0.1 times of available height, sheet can't go below this on dragging
                  maxChildSize: 0.5, // 0.7 times of available height, sheet can't go above this on dragging
                  initialChildSize: 0.3, // 0.1 times of available height, sheet start at this size when opened for first time
                  builder: (BuildContext context, ScrollController controller) {
                    if (controller.hasClients) {
                      var dimension = controller.position.viewportDimension;
                      _height ??= dimension / 0.2;
                    }
                    return AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return ClipRRect(
                          // borderRadius: borderRadius.evaluate(CurvedAnimation(parent: _controller, curve: Curves.ease)),
                          // child: Container(
                          //   // color: Colors.white,
                          //   child: OnlinePane(controller),
                          //   // child: DefaultPane(controller),
                          // ),
                          child: textBox(),                          
                          // child: bottomPane(descTextStyle, nameTextStyle),


                        );
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
              backgroundColor: new Color(0xFF0062ac),
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
                                  )
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
