import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

  Widget bottomPane(descTextStyle, nameTextStyle){
    return Container(
        child: CustomScrollView(
          // controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.blue[300],
              automaticallyImplyLeading: false,
              primary: false,
              floating: true,
              pinned: true,
              elevation: 8,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40)
                )
              ),
              
              leading: Icon(Icons.arrow_drop_up,color: Colors.white,size: 24,),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text('You are Online',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white,
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                      fontSize: 23)
                    ),),
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, idx) =>  Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      
                                        Icon(Icons.beenhere , color: Colors.blue[300]),
                                        Text('95.0%', style: descTextStyle,),
                                        Text('Acceptance', style: nameTextStyle,),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.stars,
                                      color: Colors.blue[300]),
                                      Text('4.75', style: descTextStyle,),
                                      Text('Rating', style: nameTextStyle,),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.event_busy, color: Colors.blue[300]),
                                      Text('2.0%', style: descTextStyle,),
                                      Text('Cancellation',style: nameTextStyle,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ]
                      )
                    ),
                    childCount: 1
              ),
            )
            ]
        )
    );
  }

Widget onlinePane(_tween, _controller, _height, TextStyle descTextStyle, TextStyle nameTextStyle) {

  return SizedBox.expand(
              child: SlideTransition(
                position: _tween.animate(_controller),
                child: DraggableScrollableSheet(
                  minChildSize: 0.1, // 0.1 times of available height, sheet can't go below this on dragging
                  maxChildSize: 0.4, // 0.7 times of available height, sheet can't go above this on dragging
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
                          child: bottomPane(descTextStyle, nameTextStyle),
                        );
                      },
                    );
                  },
                ),
              ),
    );
}