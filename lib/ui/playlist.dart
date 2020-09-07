import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/models/Playlistmodel.dart';
import 'package:music_player/ui/constants/colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'
    as mi;

import 'package:provider/provider.dart';

class Playlist extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    Size _mediaData = MediaQuery.of(context).size;
    return ChangeNotifierProvider<PlaylistProvider>(
      create: (context) => PlaylistProvider(),
      child: Builder(
        builder: (context) {
          return Scaffold(
             body: Consumer<PlaylistProvider>(
               builder: (context, provider,child){
                 return Container(
                   padding: EdgeInsets.all(20.0),
                   color: kbgColor,
                   child: Column(
                     mainAxisSize: MainAxisSize.max,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children:  [
                       Row( 
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                         ClayContainer(
                           color: kbgColor,
                            borderRadius: 10,
                            child: Icon(mi.MdiIcons.magnify),
                            height: _mediaData.width / 10 * 1,
                            width: _mediaData.width / 10 * 1,
                         ),
                         ],
                          
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClayText(
                      
                        'Playlists',
                        color: Colors.black,
                        size: 30.0,
                        style: TextStyle(fontWeight: FontWeight.w300),
                        ),

                        ],),
                        SizedBox(
                          height: 25.0,
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: ClayContainer(
                              color: kbgColor,
                              borderRadius: 20,
                              depth: 50,
                              height: _mediaData.height / 10 * 2.5,
                              width: _mediaData.width / 10 * 7.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                
                                children:[
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ClayContainer(
                                     color: kbgColor,
                                     borderRadius: 10,
                                     child: Icon(
                                      mi.MdiIcons.heart,
                                      color: Colors.pink,
                                    ),
                                    height: _mediaData.width / 10 * 1,
                                    width: _mediaData.width / 10 * 1,
                                     ),
                                  ),
                                SizedBox(
                                    height: 40.0,
                                  ),
                                  ClayText(
                                    'Favourites',
                                    color: Colors.black,
                                    size: 18,
                                  ),
                        

                                ],
                              ),
                              ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 25.0,
                    ),
                      Row(
                        children: [
                           ClayText(
                          'Recommended',
                          color: Colors.black,
                          size: 30,
                          style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],                 
                       ),
                       SizedBox(
                         height: 25.0,
                       ),
                       Row(
                         children: [
                           Expanded(
                             child:Row(
                               children: [
                                 ClayContainer(
                                 color: kbgColor,
                                 borderRadius: 20,
                                 height: _mediaData.width / 10 * 5,
                                 width: _mediaData.width / 10 * 3.3,

                                 ),
                               SizedBox(width: 25.0,),
                                 ClayContainer(
                                 color: kbgColor,
                                 borderRadius: 20,
                                 height: _mediaData.width / 10 * 5,
                                 width: _mediaData.width / 10 * 3.3,
                                 ),
                              ],
                             ),),                      
                         ],
                       ),
                       SizedBox(
                         height: 40.0,
                       ),
                       Row(
                         children: [
                           Expanded(
                            child: ClayContainer(
                               color: kbgColor,
                               borderRadius: 10,
                               height: _mediaData.width / 10 * 1.2,
                               width: _mediaData.width / 10 * 2,
                              child: Row(
                                children: [
                                  ClayContainer(
                                    color: Colors.pink,
                                    depth: 100,
                                    
                                    height: _mediaData.width / 10 * 0.8,
                                    width:  _mediaData.width / 10 * 0.9,
                                    ),
                                  Column(
                                    children: [
                                     Padding(
                                       padding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 5.0), 
                                        child: ClayText(
                                         'My Audience',
                                         style: TextStyle(fontWeight: FontWeight.w300),
                                          color: Colors.black,
                                          size: 15,
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                       child: ClayText(
                                         'Artist - Derbyaba Album',
                                         style: TextStyle(fontWeight: FontWeight.w400),
                                         color: Colors.grey[600],
                                       ),
                                     ),
                                    ],
                                  ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 45.0),
                                      child: ClayContainer(
                                       child: Icon(
                                        mi.MdiIcons.pause,
                                        color: Colors.white,
                                        size: 35,
                                       ),
                                       depth: 50,
                                 color: Colors.pinkAccent[400],
                                 parentColor: kbgColor,
                                 height: _mediaData.width / 10 * 1.0,
                                 width: _mediaData.width / 10 * 1.0,
                                 borderRadius: 30,
                          ),
                                    ),
                                  
                                ],
                              ),
                             ),
                           )
                         ],

                       ),
                     ],
                     
                   ),
                  
                 );
               }

             ),

          );

        }
        ),

      );

  }
}