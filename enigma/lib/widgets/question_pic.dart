import 'package:cached_network_image/cached_network_image.dart';
import 'package:enigma/providers/auth.dart';
import 'package:enigma/providers/hint.dart';
import 'package:enigma/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

const hintUrl = 'https://enigma6-backend.herokuapp.com/api/auth/hintClicked/';
String hintText;
AnimationController rotationController;

Future<HintResponse> getHint(String uid) async{
  final response = await http.post(
    hintUrl,
    headers: {'Authorization': 'Bearer $uid'}
  );
  final extractedResponse = hintResponseFromJson(response.body);
  return extractedResponse;
}

// ignore: must_be_immutable
class QuestionPic extends StatefulWidget {
  final String imgUrl;
  final String questionNumber;
  QuestionPic(this.imgUrl, this.questionNumber,);
  @override
  _QuestionPicState createState() => _QuestionPicState();
}

bool hintClicked = false;

class _QuestionPicState extends State<QuestionPic> with SingleTickerProviderStateMixin{

  @override
  void initState() {
		rotationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  final token = Provider.of<Auth>(context).uIdToken;
    SizeConfig().init(context);
    return Stack(
      children: <Widget>[
          Center(
              child: CachedNetworkImage(
                imageUrl: "http://via.placeholder.com/200x150",
                imageBuilder: (context, imageProvider) => Container(
                  height: SizeConfig.screenHeight/3,
                  width: SizeConfig.screenWidth/1.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal*4),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
          ),
        Positioned(
          left: SizeConfig.blockSizeHorizontal*5.32,
          bottom: SizeConfig.blockSizeVertical*27,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(SizeConfig.blockSizeHorizontal*4))),
            child: Container(
              height: SizeConfig.blockSizeHorizontal*12,
              width: SizeConfig.blockSizeHorizontal*12,
              //padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*4.5, SizeConfig.blockSizeVertical*0.8, 0, 0),
              child: Center(
                child: Text(widget.questionNumber!= null ? widget.questionNumber : " ", style: TextStyle(
                  fontFamily: 'Saira',
                  fontSize: SizeConfig.blockSizeVertical*3,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500
                ),),
              ),
              //color: Colors.yellow[500],
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(SizeConfig.blockSizeHorizontal*4))
              ),
            )
          ),
        ),
        Positioned(
          left: SizeConfig.blockSizeHorizontal*5.32,
          top: SizeConfig.blockSizeVertical*27,
          child: GestureDetector(
            onTap: hintClicked == true ? null : () async {
              final result = await getHint(token);
              setState(() {
                hintClicked = true;
                hintText = result.payload.hint;
                print(hintText);
              });
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal*4),
                  bottomRight: hintClicked ? Radius.circular(SizeConfig.blockSizeHorizontal*4) : Radius.circular(0)
                  )
                ),
              child: !hintClicked ?
               Container(
                height: SizeConfig.blockSizeHorizontal*12,
                width: SizeConfig.blockSizeHorizontal*11,
                padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*3,SizeConfig.blockSizeHorizontal*3,SizeConfig.blockSizeHorizontal*3,SizeConfig.blockSizeHorizontal*3),
                child: Image.asset('assets/images/key.png', fit: BoxFit.scaleDown,),
                //color: Colors.yellow[500],
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal*4))
                ),
              )
              :
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal*4), bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal*4))
                ),
                height: SizeConfig.blockSizeHorizontal*12,
                width: SizeConfig.screenWidth/1.2,
                padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*3,SizeConfig.blockSizeHorizontal*3,SizeConfig.blockSizeHorizontal*3,SizeConfig.blockSizeHorizontal*3),
                child: Text(hintText != null ? hintText : " ", style: TextStyle(
                fontFamily: 'Saira',
                fontSize: SizeConfig.blockSizeVertical*2,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500
              ),),
              )
            ),
          ),
        )
      ],
    );
  }
}