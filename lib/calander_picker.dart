library calander_picker;


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calander_picker/src/util.dart';


enum CalenderMonthMode{
  word,
  number
}


//typedef  ValueChanged<T> = void Function(T value);



class CalenderPicker extends StatefulWidget {


  final DateTime initialDate; // first date to display

  final double height;
  final double width;
  final Color focusBorderColor;
  final CalenderMonthMode monthType;
  final double borderWidth;
  final ValueChanged onValueChanged;
  final double fontSize;
  final FontWeight fontWeight;




  CalenderPicker({Key key, @required this.initialDate, this.height,
    this.width, this.focusBorderColor,@required this.monthType,
    this.onValueChanged, this.borderWidth, this.fontSize, this.fontWeight,}):
        assert(initialDate !=null, "initial can not be null"),
        assert(initialDate.year >= 1960, "minimum year is 1960"),
        assert(monthType !=null,"Calender month type can not be  null"),
        super(key: key);


  @override
  _CalenderState createState() => _CalenderState();



}

class _CalenderState extends State<CalenderPicker> {


  List<String> days;
  List<String> years;
  FixedExtentScrollController dayScroll;
  FixedExtentScrollController yearScroll;
  FixedExtentScrollController monthScroll;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    years = [];

    for(int i =1960; i <= DateTime.now().year; i++ ){

      years.add(i.toString());
    }

    var index = (years.length -1) - (DateTime.now().toUtc().year - widget.initialDate.year);


    loadDay(30);

    dayScroll = FixedExtentScrollController(
      initialItem:widget.initialDate.day -1 ,

    );
    monthScroll = FixedExtentScrollController(
      initialItem:widget.initialDate.month -1,

    );
    yearScroll = FixedExtentScrollController(
      initialItem: index,

    );


  }

  loadDay(int totalDaysInMonths){
    days =[];
    for(int i =1; i <= totalDaysInMonths; i++ ){
      days.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          cuperContainer(
            list: widget.monthType == CalenderMonthMode.word ? monthsInWord : monthsInNumber,
            scroll: monthScroll,
            onValueChanged:(v){
              _dayListener();
              _valueChange();
            }

          ),
          SizedBox(width: 20,),
          cuperContainer(
            list: days,
              scroll: dayScroll,
              onValueChanged:(v){
                _valueChange();
              }
          ),
          SizedBox(width: 20,),
          cuperContainer(
            list: years,
              scroll: yearScroll,
              onValueChanged:(v){
              _dayListener();
              _valueChange();
              }
          )




        ],
      ),
    );
  }


  _dayListener(){

    int year = int.parse(years[yearScroll.selectedItem]);
    int month = int.parse(monthsInNumber[monthScroll.selectedItem]);

    int lastday = DateTime(year,  month+ 1, 0).toUtc().day;

    // check if
    int prev_month =days.length;

    loadDay(lastday);

    if(prev_month > days.length ){
      dayScroll.jumpToItem(days.length -1);
    }

    setState(() {

    });

  }

  _valueChange(){

//years[yearScroll.selectedItem],
//       monthsInNumber[monthScroll.selectedItem],
//         days[dayScroll.selectedItem]

    widget.onValueChanged(DateTime(
        int.parse(years[yearScroll.selectedItem]),
        int.parse(monthsInNumber[monthScroll.selectedItem]),
        int.parse(days[dayScroll.selectedItem])));


  }


  Widget cuperContainer({List<String> list,ValueChanged onValueChanged,FixedExtentScrollController scroll })=>Container(
    width: widget.width ?? 90,
    height: widget.height ?? 130,
    child: CupertinoPicker(
      itemExtent: 40,
      diameterRatio: 40,
      looping: false,
      onSelectedItemChanged: onValueChanged,
      squeeze: 1,
      selectionOverlay: Container(
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  width:widget.borderWidth ?? 1,
                  color:widget.focusBorderColor ?? Colors.black
              ),
              bottom: BorderSide(
                  width: widget.borderWidth ?? 1,
                  color:widget.focusBorderColor ?? Colors.black
              ),
            )
        ),
      ),
      scrollController:scroll,
      children:List.generate(list.length, (index) => _textContainer(text: list[index])),
    ),
  );

  Widget _textContainer({String text})=>Container(
    alignment: Alignment.center,
    child: Text(
      text,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontWeight:widget.fontWeight ?? FontWeight.w400,
          fontSize:  widget.fontSize ?? 18
        )
    ),
  );
}
