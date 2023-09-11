
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/City.dart';

class SearchDropDownExampleWidget extends StatefulWidget {
  @override
  _SearchDropDownExampleWidgetState createState() => _SearchDropDownExampleWidgetState();
}

class _SearchDropDownExampleWidgetState extends State<SearchDropDownExampleWidget> {
  @override
  Widget build(BuildContext context) {

    var cities;
    var selectedCity;
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10,),
          DropdownSearch<City>(
            mode: Mode.DIALOG,
            items: cities,
            // popupBackgroundColor: Colors.grey,
            label: "Select city",
            onChanged: (_){
              print("=>"+_.id);
              setState(() {
                selectedCity  = _;
              });
            },

            selectedItem: selectedCity,
            showSearchBox: true,
            searchBoxDecoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              fillColor: Colors.red,
              hoverColor: Colors.red,
              focusColor: Colors.red,
              labelText: "Search a city",
            ),
            popupTitle: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'City',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            popupShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
