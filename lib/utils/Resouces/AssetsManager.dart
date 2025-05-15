import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

const String _IMAGE_PATH = "assets/images";
const String _content = "assets/Content";

mixin ImageAssetsManager {
  static const String logo = "$_IMAGE_PATH/Logo.png";
  static const String scaffoldBackground = "$_IMAGE_PATH/Logo.png";
  static const String defaultProfileImage =
      "$_IMAGE_PATH/defaultProfileImage.jpg";
  static const String loginBackground = "$_IMAGE_PATH/LoginBackground.jpg";
  static const String contentResortsBackground =
      "$_content/resortsBackground.jpg";
  static const String contentArchaeologicalVillagesBackground =
      "$_content/archaeologicalVillagesBackground.jpg";
  static const String contentCafesBackground = "$_content/cafesBackground.jpg";
  static const String contentHotelsBackground =
      "$_content/hotelsBackground.jpg";
  static const String contentFestivalsBackground =
      "$_content/festivalsBackground.jpg";
  static const String contentParksBackground = "$_content/parksBackground.jpg";
  static const String contentFarmsBackground = "$_content/farmsBackground.jpg";
  static const String contentForestsBackground =
      "$_content/forestsBackground.jpg";
}

mixin IconsAssetsManager {
  static const IconData addProduct = Icons.add_link;
  static const IconData addToCart = Icons.add_shopping_cart;
  static const IconData profile = Icons.person;
  static const IconData myOrders = Icons.shopping_basket_rounded;
  static const IconData cart = Icons.shopping_cart;
  static const IconData allShops = Icons.people_alt_rounded;
  static const IconData market = Icons.home;
  static const IconData signOut = Icons.logout_rounded;
  static const IconData name = Icons.person_4_rounded;
  static const IconData email = Icons.alternate_email;
  static const IconData phoneNumber = Icons.numbers;
  static const IconData whatsAppPhoneNumber = Ionicons.logo_whatsapp;
  static const IconData address = Icons.location_on;
  static const IconData shopType = Icons.people_alt;
  static const IconData language = Icons.language;
  static const IconData delete = Icons.delete;
  static const IconData date = Icons.date_range;
  static const IconData touristGuides = Icons.assistant_navigation;
  static const IconData addContent = Icons.add_home_work_rounded;
  static const IconData allContentTypes = Icons.home_work_rounded;
  static const IconData cameraIcon = Icons.camera_alt;
  static const IconData addressURLOnMap = Icons.my_location;
  static const IconData imageNotAvailable = Icons.hide_image_rounded;
  static const IconData emailVerificationMessage = Icons.email;
  static const IconData serviceProviderDescription = Icons.description;
  static const IconData send = Icons.send;
  static const IconData edit = Icons.edit;
  static const IconData openCloseTimes = Icons.access_time_filled_rounded;
  static const IconData emergencyNumbers = Icons.emergency;
  static const IconData call = Icons.call;
}
