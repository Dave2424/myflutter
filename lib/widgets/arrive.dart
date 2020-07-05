import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget arrivePane(_tween, _controller, _height, TextStyle descTextStyle, TextStyle nameTextStyle) {
  return SizedBox.expand(
              child: SlideTransition(
                position: _tween.animate(_controller),
                child: DraggableScrollableSheet(
                  minChildSize: 0.1, // 0.1 times of available height, sheet can't go below this on dragging
                  maxChildSize: 0.5, // 0.7 times of available height, sheet can't go above this on dragging
                  initialChildSize: 0.37, // 0.1 times of available height, sheet start at this size when opened for first time
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
              // elevation: 8,
              centerTitle: true,
              
               bottom: PreferredSize(                       // Add this code
                preferredSize: Size.fromHeight(35.0),  
                child: Container(
                  margin: EdgeInsets.only(bottom: 3),
                  padding: EdgeInsets.all(7),
                  child: 
                Text('Patient: James smith', style: TextStyle(fontSize: 18,color: Colors.black45),) ,
                )                          // Add this code
              ), 
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                )
              ),
                title:  Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.arrow_drop_up, color: Colors.black45, size: 20,),
                        new Spacer(),
                        Column(
                          children: <Widget>[ 
                            Container(
                              child: Row(
                                  children: <Widget>[
                                      Text('2 min',  style: TextStyle(fontSize: 18,color: Colors.black54),),    
                                      SizedBox(width: 7),      
                                      SizedBox(
                                        width: 40,
                                            child: CircleAvatar(
                                                backgroundImage: AssetImage("assets/doctor.png"),
                                              )
                                      ),
                                      SizedBox(width: 7),      
                                      Text('0.5 mi', style: TextStyle(fontSize: 18, color: Colors.black54),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        new Spacer(),
                        Icon(Icons.local_phone, color: Colors.black45, size: 20,),

                      ],
                    )
                  ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, idx) =>  Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  width: 40,
                                      child: GestureDetector(
                                        onTap: (){},
                                        child:  CircleAvatar(
                                          backgroundColor: Colors.grey[100],
                                          child:  Icon(Icons.speaker_notes, size: 30, color: Colors.black54,),
                                        ),
                                      )
                              ),
                              SizedBox( height: 5),
                              Text('Chat', style: TextStyle(fontSize: 18),)
                            ],
                          ),
                          SizedBox(width: 7),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  width: 40,
                                      child: GestureDetector(
                                        onTap: (){
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[100],
                                          child:  Icon(Icons.insert_comment, size: 30, color: Colors.black54,),
                                        ),
                                      )
                                      
                              ),
                              SizedBox(height: 5),
                              Text('Message', style: TextStyle(fontSize: 18),)
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  width: 40,
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[100],
                                          child: Icon(Icons.clear, size: 30, color: Colors.black54,),
                                        ),
                                      )
                              ),
                              SizedBox( height: 5),
                              Text('Cancel Trip', style: TextStyle(fontSize: 18),)
                            ],
                          ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () => {},
                                  color: Colors.blue[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.blue[400])
                                  ),
                                  child: Row( 
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                    Container( padding: EdgeInsets.all(10),
                                      child: 
                                        Text("Arrived", style: TextStyle(color: Colors.white, fontSize: 18),),
                                    ),
                                    ],
                                  ),
                                ),)
                            ],
                          ),                          
                        ],
                      )

                    ), 
                    childCount: 1
              )
            ),
          ]
        )
    );
}
                    