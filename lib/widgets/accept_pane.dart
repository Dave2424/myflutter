import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget acceptPane(_tween, _controller, _height, TextStyle descTextStyle, TextStyle nameTextStyle) {
  return SizedBox.expand(
              child: SlideTransition(
                position: _tween.animate(_controller),
                child: DraggableScrollableSheet(
                  minChildSize: 0.1, // 0.1 times of available height, sheet can't go below this on dragging
                  maxChildSize: 0.5, // 0.7 times of available height, sheet can't go above this on dragging
                  initialChildSize: 0.4, // 0.1 times of available height, sheet start at this size when opened for first time
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

Widget bottomPane(TextStyle descTextStyle, TextStyle nameTextStyle) {

    return Container(
        child: CustomScrollView(
          // controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              primary: false,
              floating: true,
              pinned: true,
              elevation: 8,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                )
              ),
                title:  Center(
                    child: Text('25 min',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.black,
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                      fontSize: 23)
                    ),),
                  ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, idx) =>  Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 0, left: 10, right: 10,bottom: 3),
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('NGN 12.50', style: TextStyle(fontSize: 20,color: Colors.black38),),
                                  Text('12.50 Km', style: TextStyle(fontSize: 20,color:Colors.black38),),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.star_half, size: 16, color: Colors.black38),
                                        Text('3.5', style: TextStyle(fontSize: 25,color: Colors.black38),)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              margin: EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.my_location, size: 16, color: Colors.blue[800]),
                                        SizedBox(width: 10,),
                                        Text('1 Ash Park, Pembroke Dock, SA72', style: TextStyle(fontSize: 18,color: Colors.black54),)
                                      ],
                                    ),

                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.location_on, size: 16, color: Colors.green),
                                        SizedBox(width: 10,),
                                        Text('54 Hollybank Rd, Southampton', style: TextStyle(fontSize: 18,color: Colors.black54),)
                                      ],
                                    ),

                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    // child: RaisedButton.icon(onPressed: null, icon: null, label: null)
                                        padding: EdgeInsets.all(10.0),
                                    child: 
                                      RaisedButton(
                                        onPressed: () => {},
                                        color: Colors.blue[400],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          side: BorderSide(color: Colors.blue[400])
                                        ),
                                        child: Row( // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            SizedBox(width: 80,),
                                              Text("TAP TO ACCEPT", style: TextStyle(color: Colors.white, fontSize: 18),),
                                              SizedBox(width: 53,), 
                                                SizedBox(
                                                  width: 40,
                                                  child: FloatingActionButton(
                                                      backgroundColor: Colors.blue[200],
                                                      child: Text('15', style: TextStyle(fontSize: 23),),
                                                      )
                                                      )
                                          ],
                                        ),
                                      ),
                                  )
                                ],
                              ),
                            )
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