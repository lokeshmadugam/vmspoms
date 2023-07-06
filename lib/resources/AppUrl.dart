class AppUrl{
  // BaseURl
  static var baseUrl = "https://ap-04.eezapps.com/vms/api/";
  // SignupUrl
  static var signUp = baseUrl + "public/PropertyUserSignup";
  //CountryUrl
  static var countryUrl = baseUrl + "public/Countries";
  // LogInUrl
  static var loginUrl = baseUrl + "users/sign-in";
  // Profile
  static var updateProfile = baseUrl + "UpdateProfile";
  //Visitor Reg.
  static var visitTypeUrL = baseUrl + "VisitType";
  static var visitReasonUrl = baseUrl + "VisitReason";
  static var vehicleTypeUrl = baseUrl + "Vehicletype";
  static var parkingUrl = baseUrl + "ParkingLayoutOccupiedAndUnOccupied";
  static var parkingTypeUrl = baseUrl + "ParkingLayout";
  static var getAllParkings = baseUrl + "ParkingLayoutOccupiedAndUnOccupiedByBayType";
  static var visitorRegistrationUrl = baseUrl + "VisitorRegistrationReq";
  static var addFavoriteUrl = baseUrl + "PropertyFavouriteVisitor";
  static var configItemsUrl = baseUrl + "public/ConfigurationItems/key";
  // static var getVisitorDetailsUrl = baseUrl+"VisitorRegistrationReq/{id}";
  static var mediaUpload = baseUrl +"public/file";
  //facility
  static var facilityBookingUrl = baseUrl + "FacilityBookings";
  static var facilityTypeUrl = baseUrl + "PropertyFacilities";
  //TrustedNeighbours
  static var trustednbghUrl = baseUrl + "TrustedNeigbours" ;
  static var trustedNbghByUserIdUrl = baseUrl + "TrustedNeigboursByUserId";
  static var trustedNbghById = baseUrl + "TrustedNeigbours/{id}";
  static var getAllTrustedNbghUrl = baseUrl + "GetTrustedNeighbours";

  static var getLoginDetailsByIdUrl = baseUrl+"PropertyUsers/{id}";
  //GreyList
  static var greyListings = baseUrl + "VisitorUserGreyList";
  // static var visitType = baseUrl + "VisitType";
  // static var vehicleType = baseUrl + "Vehicletype";
  static var submitGreyList = baseUrl + "VisitorUserGreyList";
  static var updateGreyList = baseUrl + "VisitorUserGreyList";
  //Packages
  static var deliveryService = baseUrl + "DeliveryService";
  static var packageType = baseUrl + "PackageType";
  static var createExpectedPackage = baseUrl + "PackageArriveRegistr";
  static var updateExpectedPackage = baseUrl + "PackageArriveRegistr";
  static var createReceivedPackage = baseUrl + "PackageReceipts";
  static var updateReceivedPackage = baseUrl + "PackageReceipts";
  static var packageReceiptsList = baseUrl + "PackageReceipts";
  static var packageExpectedList = baseUrl + "PackageArriveRegistr";
  //Security
  static var blockUnitNoList = baseUrl + "PropertyUsersUnitnumber";
  static var receiptStatus = baseUrl + "public/ConfigurationItems/key";
  static var securityCheckPoint = baseUrl + "PropertySecurityRoundsCheckpoints";

  static var securityRoundLogs = baseUrl + "PropertySecurityRoundsLogs";
  static var securityViewDetails = baseUrl + "PropertySecurityRoundsLogs";
  static var securityRoundLogsTemp = baseUrl + "PropertySecurityRoundsTempLogs";
  //lost&Found
  static var lostItems = baseUrl + "LostFound";
  static var submitLostItems = baseUrl + "LostFound";
  static var updateLostItems = baseUrl + "LostFound";
  static var unclaimed = baseUrl + "unclaimped";
  // static var configurationItems = baseUrl + "public/ConfigurationItems/key";
  static var submitClockIn = baseUrl + "ClockInClockOut";
  static var updateClockOut = baseUrl + "ClockInClockOut";
  static var clockInClockOutByEmployeId = baseUrl + "ClockInClockOutByEmployeIdAndClockInOutDate";
  static var submitRequestTime = baseUrl + "ClockInClockOutReqTime";
//  intercomIntercom
  static var intercomListUrl = baseUrl + "Intercom";
  static var deleteIntercom = baseUrl + "Intercom/{id}";
  // Emergency
  static var emergencyService = baseUrl + "EmergencyServices";
  static var email = baseUrl + "public/send/email";
  static var verifyEmail = baseUrl + "public/OTPValid";
//  Adds
  static var addsUrl = baseUrl + "PropertyAdsSlider";


  //Settings
  static var companyPolicy = baseUrl + "public/CompanyPolicy";
//  House Rules
static var  houserulesUrl = baseUrl + "PropertyDocumentTypes";
static var getRulesUrl = baseUrl + "PropertyDocuments";
// Announcement& NewsBulletin
static var newsBulletinUrl = baseUrl + "NewsBulletin";
//Management Security
  static var managementSecurity = baseUrl + "PropertyManagementContacts";
  //Damages Complaints
  static var complaints = baseUrl + "DamagesComplaints";
  static var submitComplaints = baseUrl + "DamagesComplaints";
  static var managementOffice = baseUrl + "GetManagementOffice";
//E Forms
  static var eFormCategoryNames = baseUrl + "PropertyEformsCategory";
  static var dynamicFormList = baseUrl + "GetAllEformsFieds";
  static var submitEForm = baseUrl + "PropertyEformsUserdata";
  static var EFormUserData = baseUrl + "PropertyEformsUserdata";
  //E Polls
  static var EPollUserData = baseUrl + "PropertyEpollingUserdata";
  static var ePollCategoryNames = baseUrl + "PropertyEpollingCategory";
  static var ePollDynamicList = baseUrl + "GetAllEpollingFieds";
  static var submitEPoll = baseUrl + "PropertyEpollingUserdata";

}