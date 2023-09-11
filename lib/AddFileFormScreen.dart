import 'dart:ui';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/CircularInputField.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MaterialButton.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/City.dart';
import 'package:qkp/Model/File.dart';
import 'package:qkp/Model/FileSector.dart';
import 'package:qkp/Model/FileType.dart';
import 'package:qkp/Model/Phase.dart';
import 'package:qkp/Model/Society.dart';
import 'package:qkp/Model/Symbol.dart';
import 'package:qkp/Model/Town.dart';
import 'package:qkp/Model/Unit.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'Model/User.dart';

class AddPropertyFormWidget extends StatefulWidget {
  @override
  _AddPropertyFormWidgetState createState() => _AddPropertyFormWidgetState();
}

class _AddPropertyFormWidgetState extends State<AddPropertyFormWidget> {
  String fileName;
  String fileDetails = '';
  String symbol;
  String city;
  City selectedCity;
  String subType;
  String town;
  String unit;
  String society;
  String area;
  String fileId;
  String qty;
  String price;
  List data;
  List<City> cities = [];
  List<City> prcities = [];
  List<String> subTypeList = ['Residential', 'Commercial'];
  List<Town> towns = [];
  User user;
  List<Symbol> symbols = [];
  List<File> filesList = [];
  List<Units> unitList = [];
  List<Society> societyList = [];
  List<FileType> fileTypeList = [];
  List<FileSector> fileSectorList = [];
  String selectedFileType = null;
  String selectedFileSector = null;
  bool ignoreSymbol = false;

  int fileIndex = -1;
  bool isButtonDisabled = false;
  bool isLoading = false;
  bool isDisabled = false;
  String fileIdentifier;
  List<Phase> phases = [];
  String phase;

  Future<bool> getPageData() async {
    data = new List();

    var res = await fileDropDownService();
    print(res);
    var citiesMap = res["Files"]["cities"];
    var symbolsMap = res["Files"]["symbol"];
    var townsMap = res["Files"]["file_city_town"];
    var fileMap = res["Files"]["files_data"];
    var unitMap = res["Files"]["units_data"];
    var societyMap = res["Files"]["societies"];
    var fileSectorMap = res["Files"]["file_sector"];
    var fileTypeMap = res["Files"]["file_type"];

    cities.clear();
    towns.clear();
    symbols.clear();
    societyList.clear();
    filesList.clear();
    // citiesDummy.clear();
    phases.clear();
    unitList.clear();
    data.clear();
    fileSectorList.clear();
    fileTypeList.clear();

    for (int i = 0; i < societyMap.length; i++) {
      Society society = new Society();
      society.fromJson(societyMap[i]);
      setState(() {
        societyList.add(society);
      });
    }
    for (int i = 0; i < citiesMap.length; i++) {
      City city = new City();
      city.fromJson(citiesMap[i]);
      setState(() {
        cities.add(city);
      });
    }
    for (int i = 0; i < unitMap.length; i++) {
      Units units = new Units();
      units.fromJson(unitMap[i]);
      setState(() {
        unitList.add(units);
      });
    }

    for (int i = 0; i < symbolsMap.length; i++) {
      Symbol symbol = new Symbol();
      symbol.fromJson(symbolsMap[i]);
      setState(() {
        symbols.add(symbol);
      });
    }

    for (int i = 0; i < townsMap.length; i++) {
      Town town = new Town();
      town.fromJson(townsMap[i]);
      setState(() {
        towns.add(town);
      });
    }

    for (int i = 0; i < fileMap.length; i++) {
      File file = new File();
      await file.fromJson(fileMap[i]);
      setState(() {
        filesList.add(file);
      });
    }
    for (int i = 0; i < fileTypeMap.length; i++) {
      fileTypeList.add(FileType.fromJson(fileTypeMap[i]));
    }

    for (int i = 0; i < fileSectorMap.length; i++) {
      fileSectorList.add(FileSector.fromJson(fileSectorMap[i]));
    }

    // setState(() async {
    // citiesDummy.addAll(cities);
    user = await getUser();
    // });
  }

  addFile() async {
    var request = <String, dynamic>{
      // "name": fileName,
      "detail": fileDetails,
      "qkp_file_symbol_id": symbol,
      // "file_type": "Plot",
      // "file_sub_type": subType,
      // "town": town,
      // "city": city,
      // "unit_id": unit,
      // "unit": area,
      "owner_id": user.id,
      // "phase": phase,
      // "price": price,
      "quantity": qty,
      "file_id": fileId
    };
    if (qty.length < 1) {
      showToast("details cannot be empty");
      return;
    } else if (fileId.length < 1) {
      showToast("please select some file");
      return;
    } else if (symbol.length < 1) {
      showToast("please select correct file");
    }
    // Navigator.pop(context);
    disable();
    var res = await addFileService(request);
    enable();
    if (res["ResponseCode"] == 1) {
      showToast("Successfully added file");
      clearForm();
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
    }
  }

  filterSector() {
    print("society" + society);
    List<FileSector> tempSector = [];
    tempSector.addAll(fileSectorList.where((element) =>
        element.societyId ==
        societyList.where((element) => element.id == society).first.id));
    fileSectorList.clear();
    setState(() {
      fileSectorList.addAll(tempSector);
    });
  }

  clearForm() {
    setState(() {
      city = null;
      society = null;
      unit = null;
      symbol = null;
      town = null;
      fileId = null;
      phase = null;
      fileDetails = "";
      qty = "";
      subType = null;
      subTypeList = ['Residential', 'Commercial'];
      selectedFileSector = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPageData();
    super.initState();
  }

  Future<bool> filter() async {
    for (int i = 0; i < filesList.length; i++) {
      // print("name=>"+filesList[i].name);
      if (symbol == filesList[i].qkpFileSymbolId) {
        setState(() {
          setState(() {
            fileId = filesList[i].id;
          });
        });
        break;
      }
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme
          ? darkTheme["primaryBackgroundColor"]
          : lightTheme["primaryBackgroundColor"],
      appBar: AppBar(
        title: Text("Add File"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                getPageData();
                clearForm();
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: isDarkTheme
              ? darkTheme["primaryBackgroundColor"]
              : lightTheme["primaryBackgroundColor"],
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("Select Society",style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.w600),),
              // Container(
              //   alignment: Alignment.center,
              //   decoration: new BoxDecoration(
              //     borderRadius:
              //     BorderRadius.circular(60.0),
              //     color: Colors.white,
              //   ),
              //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //   margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
              //   child: DropdownButton<String>(
              //     isExpanded: true,
              //     value: society,
              //     underline: SizedBox(),
              //     hint: Text("Society"),
              //     onChanged: (_) async {
              //       ProgressDialog  pr = ProgressDialog(context);
              //       pr.show();
              //       var pgData =  await getPageData();
              //       clearForm();
              //       pr.hide();
              //
              //       print(_);
              //       setState(() {
              //         society = _;
              //       });
              //       var filt = await filter();
              //       // filterFromDropDowns(_, "society");
              //       filterSector();
              //     },
              //     style: TextStyle(color: darkTheme["primaryBackgroundColor"]),
              //     items: societyList.map((Society val) {
              //       var i = societyList.indexOf(val);
              //       print(i.toString());
              //
              //       return new DropdownMenuItem<String>(
              //         value: val.id,
              //         child: new Text(val.societyTitle),
              //       );
              //     }).toList(),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text("Select Sector",style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.w600),),
              // Container(
              //   alignment: Alignment.center,
              //   decoration: new BoxDecoration(
              //     borderRadius:
              //     BorderRadius.circular(60.0),
              //     color: Colors.white,
              //   ),
              //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //   margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
              //   child: DropdownButton<String>(
              //     isExpanded: true,
              //     value: selectedFileSector,
              //     underline: SizedBox(),
              //     hint: Text("Sector"),
              //     onChanged: (_) async {
              //       ProgressDialog  pr = ProgressDialog(context);
              //       // pr.show();
              //       // var pgData =  await getPageData();
              //       // clearForm();
              //       // pr.hide();
              //
              //       print(_);
              //       setState(() {
              //         selectedFileSector = _;
              //       });
              //       // var filt = await filter();
              //       // filterFromDropDowns(_, "society");
              //     },
              //     style: TextStyle(color: darkTheme["primaryBackgroundColor"]),
              //     items: fileSectorList.map((FileSector val) {
              //       // var i = societyList.indexOf(val);
              //       // print(i.toString());
              //
              //       return new DropdownMenuItem<String>(
              //         value: val.id,
              //         child: new Text(val.sectorName),
              //       );
              //     }).toList(),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text("File Type",style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.w600),),
              // Container(
              //   alignment: Alignment.center,
              //   decoration: new BoxDecoration(
              //     borderRadius:
              //     BorderRadius.circular(60.0),
              //     color: Colors.white,
              //   ),
              //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //   margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
              //   child: DropdownButton<String>(
              //     isExpanded: true,
              //     value: selectedFileType,
              //     underline: SizedBox(),
              //     hint: Text("File Type"),
              //     onChanged: (_) async {
              //       ProgressDialog  pr = ProgressDialog(context);
              //       // pr.show();
              //       // var pgData =  await getPageData();
              //       // clearForm();
              //       // pr.hide();
              //
              //       print(_);
              //       setState(() {
              //         selectedFileType = _;
              //       });
              //       // var filt = await filter();
              //       // filterFromDropDowns(_, "society");
              //     },
              //     style: TextStyle(color: darkTheme["primaryBackgroundColor"]),
              //     items: fileTypeList.map((FileType val) {
              //       // var i = societyList.indexOf(val);
              //       // print(i.toString());
              //
              //       return new DropdownMenuItem<String>(
              //         value: val.id,
              //         child: new Text(val.typeName),
              //       );
              //     }).toList(),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text("City",style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.w600),),
              // Container(
              //   alignment: Alignment.center,
              //   decoration: new BoxDecoration(
              //     borderRadius:
              //     BorderRadius.circular(60.0),
              //     color: Colors.white,
              //   ),
              //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //   margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
              //   child: DropdownButton<String>(
              //     focusColor: Colors.white,
              //     dropdownColor: darkTheme["primaryWhite"],
              //     isExpanded: true,
              //     hint: Text("Select City"),
              //     style: TextStyle(color: darkTheme["primaryBackgroundColor"]),
              //     underline: SizedBox(),
              //   //  style:TextStyle(color: darkTheme["primaryWhite"]),
              //     value: city,
              //     items: cities.map((City city) {
              //       return new DropdownMenuItem<String>(
              //         value: city.id,
              //         child: new Text(city.name),
              //       );
              //     }).toList(),
              //     onChanged: (_) {
              //       print(_);
              //       setState(() {
              //         city = _;
              //       });
              //       filter();
              //      // filterFromDropDowns(_, "city");
              //     },
              //   ),
              // ),
              //
              // SizedBox(
              //   height: 10,
              // ),
              // Text("Sub Type",style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.w600),),
              // Container(
              //   alignment: Alignment.center,
              //   decoration: new BoxDecoration(
              //     borderRadius:
              //     BorderRadius.circular(60.0),
              //     color: Colors.white,
              //   ),
              //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //   margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
              //   child: DropdownButton<String>(
              //     style: TextStyle(color: darkTheme["primaryBackgroundColor"]),
              //     underline: SizedBox(),
              //     isExpanded: true,
              //     value: subType,
              //     hint: Text("Select Sub Type"),
              //     items: subTypeList.map((String val) {
              //       return new DropdownMenuItem<String>(
              //         value: val,
              //         child: new Text(val),
              //       );
              //     }).toList(),
              //     onChanged: (_) {
              //       print(_);
              //       setState(() {
              //         subType = _;
              //       });
              //       filter();
              //       //filterFromDropDowns(_, "subType");
              //     },
              //   ),
              // ),
              // SizedBox(height: 10),
              //
              // Text("Unit",style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.w600)),
              // Container(
              //   alignment: Alignment.center,
              //   decoration: new BoxDecoration(
              //     borderRadius:
              //     BorderRadius.circular(60.0),
              //     color: Colors.white,
              //   ),
              //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //   margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
              //   child: DropdownButton<String>(
              //     style: TextStyle(color: darkTheme["primaryBackgroundColor"]),
              //     underline: SizedBox(),
              //     isExpanded: true,
              //     value: unit,
              //     hint: Text("Select Unit"),
              //     items: unitList.map((Units val) {
              //       return new DropdownMenuItem<String>(
              //         value: val.id,
              //         child: new Text(val.name + " (" + val.area + ")"),
              //       );
              //     }).toList(),
              //     onChanged: (_) {
              //       print("->->"+_);
              //       setState(() {
              //         unit = _;
              //       });
              //       filter();
              //       //filterFromDropDowns(_, "unit");
              //     },
              //   ),
              // ),
              // SizedBox(height: 10,),
              // Text("Phases",style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.w600)),
              // Container(
              //   alignment: Alignment.center,
              //   decoration: new BoxDecoration(
              //     borderRadius:
              //     BorderRadius.circular(60.0),
              //     color: Colors.white,
              //   ),
              //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //   margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
              //   child: DropdownButton<String>(
              //     style: TextStyle(color: darkTheme["primaryBackgroundColor"]),
              //     underline: SizedBox(),
              //     isExpanded: true,
              //     value: phase,
              //     hint: Text("Select Phase"),
              //     items: phases.map((Phase val) {
              //       return new DropdownMenuItem<String>(
              //         value: val.id,
              //         child: new Text(val.phase),
              //       );
              //     }).toList(),
              //     onChanged: (_) {
              //       print("phase => "+_);
              //       setState(() {
              //         phase = _;
              //       });
              //       filter();
              //     },
              //   ),
              // ),
              //
              //
              //
              // SizedBox(
              //   height: 10,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Symbol",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  Container(
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                    child: DropdownButton<String>(
                      style:
                          TextStyle(color: darkTheme["primaryBackgroundColor"]),
                      underline: SizedBox(),
                      isExpanded: true,
                      value: symbol,
                      hint: Text("Select File Symbol"),
                      items: symbols.map((Symbol symbol) {
                        return new DropdownMenuItem<String>(
                          value: symbol.id.toString(),
                          child: new Text(symbol.symbol),
                        );
                      }).toList(),
                      onChanged: (_) {
                        print(_);
                        setState(() {
                          symbol = _;
                        });
                        filter();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                      visible: false,
                      child: Text("Town",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))),
                  /* Visibility(
                    visible: false,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(60.0),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: IgnorePointer(
                        ignoring: true,
                        child: DropdownButton<String>(
                          style: TextStyle(color: darkTheme["primaryBackgroundColor"]),
                          underline: SizedBox(),
                          isExpanded: true,
                          value: town,
                          hint: Text("Select Town"),
                          items: towns.map((Town town) {
                            // print(town.toJson());
                            return new DropdownMenuItem<String>(
                              value: town.id,
                              child: new Text(town.town != null ? town.town : ""),
                            );
                          }).toList(),
                          onChanged: (_) {
                            print(_);
                            setState(() {
                              town = _;
                            });
                          },
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),

              SizedBox(
                height: 2,
              ),
              Text("Select File",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(60.0),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: IgnorePointer(
                  ignoring: true,
                  child: DropdownButton<String>(
                    style:
                        TextStyle(color: darkTheme["primaryBackgroundColor"]),
                    underline: SizedBox(),
                    isExpanded: true,
                    value: fileId,
                    hint: Text("Files"),
                    items: filesList.map((File val) {
                      var i = filesList.indexOf(val);
                      print(i.toString());
                      return new DropdownMenuItem<String>(
                        value: val.id,
                        child: new Text(val.name),
                      );
                    }).toList(),
                    onChanged: (_) {
                      print(_);
                      setState(() {
                        // fileIndex = -1;
                        fileId = _;
                        // fileId = f[0];
                        // fileName = _;
                        // print(f.toString());
                        // fileName = f[0];
                        // int index = int.parse(f[1]);
                        // // fileName = f[0];
                        // city = filesList[index].city;
                        // symbol = filesList[index].qkpFileSymbolId;
                        // unit = filesList[index].qkpUnitId;
                        // subType = filesList[index].fileSubType;
                      });
                    },
                  ),
                ),
              ),
              // MaterialInputField(
              //   label: "File Name",
              //   // leftIcon: Icon(Icons.short_text_sharp),
              //   rightIcon: Icon(Icons.short_text_sharp),
              //   onChanged: (val) {
              //     setState(() {
              //       fileName = val;
              //     });
              //   },
              // ),

              // SizedBox(height: 10),
              SizedBox(
                height: 10,
              ),
              Text("Details",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 7,
              ),
              CircularInputField(
                hintText: 'Details (more info if necessary)',
                onChanged: (val) {
                  fileDetails = val;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text("Quantity",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 10,
              ),
              CircularInputField(
                hintText: "Quantity",
                // textInputType: TextInputType.number,
                // leftIcon: Icon(Icons.short_text_sharp),

                onChanged: (val) {
                  qty = val;
                },
              ),
              SizedBox(
                height: 12,
              ),
              Center(
                child: SizedBox(
                  width: 140,
                  child: ElevatedButton(
                      /*  isDisable: isDisabled,
                      isLoading: isLoading, */
                      onPressed: () async {
                        addFile();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              darkTheme['secondaryColor']),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: darkTheme["redText"]),
                            ),
                            // primary: darkTheme["secondaryColor"],
                          )),
                      child: Text("Add File",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700))),
                ),
              ),

              /* SizedBox(
                height: 20,
              ),
              MaterialButtonWidget(
                onPressed: () async {
                  addFile();
                },
                name: "Add File",
                isDisable: isDisabled,
                isLoading: isLoading,
              ) */
            ],
          ),
        ),
      ),
    );
  }

  disable() {
    setState(() {
      isLoading = true;
      isDisabled = true;
    });
  }

  enable() {
    setState(() {
      isLoading = false;
      isDisabled = false;
    });
  }
}
