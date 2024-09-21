import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findit_admin_app/controllers/db_service.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categories = [];
  StreamSubscription<QuerySnapshot>? _categorySubscription;
  List<QueryDocumentSnapshot> products = [];
  StreamSubscription<QuerySnapshot>? _productsSubscription;
  List<QueryDocumentSnapshot> orders = [];
  StreamSubscription<QuerySnapshot>? _ordersSubscription;

  int totalCategories = 0;
  int totalProducts = 0;
  int totalOrders = 0;
  int ordersDelivered = 0;
  int ordersOnTheWay = 0;
  int ordersCancelled = 0;
  int ordersPendingProcess = 0;

  AdminProvider() {
    getCategories();
    getProducts();
    readOrders();
  }

  //get all the categories
  void getCategories() {
    _categorySubscription?.cancel();
    _categorySubscription = DbService().readCategories().listen(
      (snapshot) {
        categories = snapshot.docs;
        totalCategories = snapshot.docs.length;
        notifyListeners();
      },
    );
  }

  //get all the products
  void getProducts() {
    _productsSubscription?.cancel();
    _productsSubscription = DbService().readProducts().listen(
      (snapshot) {
        products = snapshot.docs;
        totalProducts = snapshot.docs.length;
        notifyListeners();
      },
    );
  }

  //read all the orders
  void readOrders() {
    _ordersSubscription?.cancel();
    _ordersSubscription = DbService().readOrders().listen(
      (snapshot) {
        orders = snapshot.docs;
        totalOrders = snapshot.docs.length;
        setOrderStatusCount();
        notifyListeners();
      },
    );
  }

  //order types details
  void setOrderStatusCount() {
    ordersDelivered = 0;
    ordersOnTheWay = 0;
    ordersCancelled = 0;
    ordersPendingProcess = 0;

    for (int i = 0; i < orders.length; i++) {
      if (orders[i]["status"] == "DELIVERED") {
        ordersDelivered++;
      } else if (orders[i]["status"] == "CANCELLED") {
        ordersCancelled++;
      } else if (orders[i]["status"] == "ON_THE_WAY") {
        ordersOnTheWay++;
      }else{
        ordersPendingProcess++;
      }
    }

    notifyListeners();
  }

  void cancelProviders(){
     _categorySubscription?.cancel();
     _productsSubscription?.cancel();
     _ordersSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProviders();
    super.dispose();
  }
}
