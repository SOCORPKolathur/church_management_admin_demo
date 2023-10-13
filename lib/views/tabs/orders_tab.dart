import 'dart:html';
import 'dart:typed_data';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;
import 'dart:convert';
import '../../constants.dart';
import '../../models/orders_model.dart';
import '../../models/response.dart';
import '../../services/orders_firecrud.dart';
import '../../widgets/kText.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int currentTabIndex = 0;
  TextEditingController orderStatusController = TextEditingController(text: "Select Status");
  List<OrdersModel> newBookingsList = [];
  List<OrdersModel> deliveredList = [];
  List<OrdersModel> canceledList = [];
  List<OrdersModel> ordersList1 = [];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: KText(
                text: "ORDERS",
                style: GoogleFonts.openSans(
                    fontSize: width/52.53846153846154,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            StreamBuilder(
              stream: OrdersFireCrud.fetchOrders(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<OrdersModel> orders = snapshot.data!;
                  if (orders.length != ordersList1.length) {
                    orders.forEach((element) {
                      ordersList1.add(element);
                    });
                  }
                  newBookingsList.clear();
                  deliveredList.clear();
                  canceledList.clear();
                  ordersList1.forEach((element) {
                    switch (element.status!.toUpperCase()) {
                      case "ORDERED":
                        newBookingsList.add(element);
                        break;
                      case "DELIVERED":
                        deliveredList.add(element);
                        break;
                      case "CANCELED":
                        canceledList.add(element);
                        break;
                    }
                  });
                  return Container(
                    width: width/1.241818181818182,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Orders (${orders.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          height: height/10.85,
                          width: double.infinity,
                          child: TabBar(
                            onTap: (int index) {
                              setState(() {
                                currentTabIndex = index;
                              });
                            },
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            splashBorderRadius: BorderRadius.circular(30),
                            automaticIndicatorColorAdjustment: true,
                            dividerColor: Colors.transparent,
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: Constants().primaryAppColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelColor: Colors.black,
                            tabs: [
                              Tab(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "New Orders",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 0
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: width/97.57142857142857,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Delivered",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 1
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: width/97.57142857142857,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Canceled",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 2
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: width/97.57142857142857,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: orders.isNotEmpty ? orders.length * height/3.255 : height/3.255,
                          width: double.infinity,
                          child: TabBarView(
                            dragStartBehavior:DragStartBehavior.down,
                            controller: _tabController,
                            children: [
                              tabViewWidget(newBookingsList,true),
                              tabViewWidget(deliveredList,false),
                              tabViewWidget(canceledList,false),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget tabViewWidget(List<OrdersModel> orders, bool isNewBooking) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          )),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  SizedBox(
                    width: width/39.02857142857143,
                    child: KText(
                      text: "SL.",
                      style: GoogleFonts.poppins(
                        fontSize: width/105.0769230769231,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width/6.83,
                    child: KText(
                      text: "OrderID",
                      style: GoogleFonts.poppins(
                        fontSize: width/105.0769230769231,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width/15.17777777777778,
                    child: KText(
                      text: "Date",
                      style: GoogleFonts.poppins(
                        fontSize: width/105.0769230769231,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width/6.83,
                    child: KText(
                      text: "Username",
                      style: GoogleFonts.poppins(
                        fontSize: width/105.0769230769231,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width/9.106666666666667,
                    child: KText(
                      text: "Amount",
                      style: GoogleFonts.poppins(
                        fontSize: width/105.0769230769231,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width/9.106666666666667,
                    child: KText(
                      text: "Phone",
                      style: GoogleFonts.poppins(
                        fontSize: width/105.0769230769231,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width/9.106666666666667,
                    child: KText(
                      text: "Actions",
                      style: GoogleFonts.poppins(
                        fontSize: width/105.0769230769231,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: height/65.1),
          Expanded(
            child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    height: height/10.85,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Color(0xfff1f1f1),
                          width: 0.5,
                        ),
                        bottom: BorderSide(
                          color: Color(0xfff1f1f1),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width/39.02857142857143,
                            child: KText(
                              text: (i + 1).toString(),
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/6.83,
                            child: KText(
                              text: orders[i].orderId!,
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/15.17777777777778,
                            child: KText(
                              text: orders[i].date!,
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/6.83,
                            child: KText(
                              text: orders[i].userName!,
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/9.106666666666667,
                            child: KText(
                              text: orders[i].amount!.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/9.106666666666667,
                            child: KText(
                              text: orders[i].phone!,
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: width/9.106666666666667,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      viewProductsPopUp(orders[i],orders[i].products);
                                    },
                                    child: Container(
                                      height: height/26.04,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff2baae4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.white,
                                                size: width/91.06666666666667,
                                              ),
                                              KText(
                                                text: "View Order",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/136.6,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isNewBooking,
                                    child: InkWell(
                                      onTap: () async {
                                        bool result = await updateOrderPopUp(orders[i]);
                                        if(result){
                                          orders[i].status = orderStatusController.text;
                                          Response response = await OrdersFireCrud.updateRecord(orders[i]);
                                          if(response.code == 200){
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.success,
                                                text:
                                                "Updated successfully!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor
                                                    .withOpacity(0.8));
                                          }else{
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text:
                                                "Failed to Update",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor
                                                    .withOpacity(0.8));
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: height/26.04,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffff9700),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.update,
                                                  color: Colors.white,
                                                  size: width/91.06666666666667,
                                                ),
                                                KText(
                                                  text: "Update",
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize: width/136.6,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  updateOrderPopUp(OrdersModel order){
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (context,setState) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                  height: size.height * 0.4,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Constants().primaryAppColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: KText(
                                text: "Update Order Status",
                                style: GoogleFonts.openSans(
                                  fontSize: width/85.375,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/15.17777777777778,
                                    child: KText(
                                      text: "Order ID : ",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.57142857142857,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/85.375),
                                  Text(
                                    order.orderId!,
                                    style: GoogleFonts.openSans(
                                      fontSize: width/97.57142857142857,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/15.17777777777778,
                                    child: KText(
                                      text: "Status",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.57142857142857,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/85.375),
                                  Container(
                                    height: height/16.275,
                                    width: width/6.83,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: Offset(2, 3),
                                        )
                                      ],
                                    ),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    underline: Container(),
                                    value: orderStatusController.text,
                                    icon:
                                    const Icon(Icons.keyboard_arrow_down),
                                    items: ["Select Status", "Ordered", "Delivered","Canceled"]
                                        .map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        orderStatusController.text = newValue!;
                                      });
                                    },
                                  ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,false);
                                    },
                                    child: Container(
                                      height: height/16.275,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 6),
                                        child: Center(
                                          child: KText(
                                            text: "Cancel",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/85.375,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/273.2),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,true);
                                    },
                                    child: Container(
                                      height: height/16.275,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 6),
                                        child: Center(
                                          child: KText(
                                            text: "Apply",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/85.375,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  viewProductsPopUp(OrdersModel order,List<Products>? products) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: size.height * 0.8,
                width: size.width * 0.6,
                decoration: BoxDecoration(
                  color: Constants().primaryAppColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.07,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: KText(
                              text: "Order Details",
                              style: GoogleFonts.openSans(
                                fontSize: width/85.375,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: height/18.6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "CLOSE",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            )),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text:"Order Details : ",
                              style: GoogleFonts.poppins(
                                decoration: TextDecoration.underline,
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: height*0.01),
                            SizedBox(
                              height: size.height * 0.2,
                              width: size.width * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      KText(
                                        text:"Order ID :  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      KText(
                                        text: order.orderId!,
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      KText(
                                        text:"Username :  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      KText(
                                        text: order.userName!,
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      KText(
                                        text:"Phone :  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      KText(
                                        text: order.phone!,
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      KText(
                                        text:"Method :  ",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      KText(
                                        text: order.method!,
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: height*0.01),
                            KText(
                              text:"Products Details : ",
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(height: height*0.01),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width/39.02857142857143,
                                      child: KText(
                                        text: "SL.",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/7.588888888888889,
                                      child: KText(
                                        text: "Product Name",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/10.50769230769231,
                                      child: KText(
                                        text: "Rate",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/9.106666666666667,
                                      child: KText(
                                        text: "Qty",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/9.106666666666667,
                                      child: KText(
                                        text: "Value",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: height/65.1),
                            Expanded(
                              child: ListView.builder(
                                itemCount: products!.length,
                                itemBuilder: (ctx, i) {
                                  return Container(
                                    height: height/10.85,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xfff1f1f1),
                                          width: 0.5,
                                        ),
                                        bottom: BorderSide(
                                          color: Color(0xfff1f1f1),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: width/39.02857142857143,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/7.588888888888889,
                                            child: KText(
                                              text: products[i].name!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/10.50769230769231,
                                            child: KText(
                                              text: products[i].price!.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/9.106666666666667,
                                            child: KText(
                                              text: products[i]
                                                  .quantity!
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/9.106666666666667,
                                            child: KText(
                                              text: (products[i].price! *
                                                      products[i].quantity!)
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: height/10.85,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  KText(
                                    text: "Total : ",
                                    style: TextStyle(
                                      fontSize: width/75.88888888888889,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: width/136.6),
                                  Text(
                                    getTotalAmount(products),
                                    style: TextStyle(
                                      fontSize: width/75.88888888888889,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
      },
    );
  }

  String getTotalAmount(List<Products> products){
    double amount = 0.0;
    products.forEach((element) {
      amount += element.quantity! * element.price!;
    });
    return amount.toString();
  }

  convertToCsv(List<OrdersModel> orders) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Username");
    row.add("Product");
    row.add("Amount");
    row.add("Method");
    row.add("Status");
    row.add("Address");
    rows.add(row);
    for (int i = 0; i < orders.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(orders[i].userName);
      row.add(orders[i].products);
      row.add(orders[i].amount);
      row.add(orders[i].method);
      row.add(orders[i].status);
      row.add(orders[i].address);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    saveCsvToFile(csv);
  }

  void saveCsvToFile(csvString) async {
    final blob = Blob([Uint8List.fromList(csvString.codeUnits)]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "data.csv")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<OrdersModel> orders) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Username");
    row.add("    ");
    row.add("Product");
    row.add("    ");
    row.add("Amount");
    row.add("    ");
    row.add("Method");
    row.add("    ");
    row.add("Status");
    row.add("    ");
    row.add("Address");
    rows.add(row);
    for (int i = 0; i < orders.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add(orders[i].userName);
      row.add("       ");
      row.add(orders[i].products);
      row.add("       ");
      row.add(orders[i].amount);
      row.add("       ");
      row.add(orders[i].method);
      row.add("       ");
      row.add(orders[i].status);
      row.add("       ");
      row.add(orders[i].address);
      row.add("       ");
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows,
        fieldDelimiter: null,
        eol: null,
        textEndDelimiter: null,
        delimitAllFields: false,
        textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",", "")));
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Constants().primaryAppColor),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Please fill required fields !!',
                  style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            TextButton(
                onPressed: () => debugPrint("Undid"), child: const Text("Undo"))
          ],
        )),
  );
}
