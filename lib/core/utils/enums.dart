// ignore_for_file: constant_identifier_names

enum LanguageCode { en, ar }

enum Themes { light, dark }

enum UserCycle {
  firstOpen, // WelcomeScreen / Onboarding
  login, // Not logged in (saw onboarding)
  auth, // Logged in
  guest, // Continue as guest
}

enum UserType {
  pending, // FlowScreen
  refused, // FlowScreen
  approved,
  user,
  provider,
  delegate,
}

enum UserStatus { pending, approved, refused }

enum SettleType { deposit, withdrawal, no_settle }

enum Modules { settlement, booking }

enum AppUpdateType { flexible, immediately }

enum ExpansionTypes {
  doctorTitles,
  supSpecialities,
  availableTimes,
  entryMethod,
  building,
  gender,
  status,
}

enum VerifyTypes { email, phone, reset }

enum AvailableTimes { anyDay, today, tomorrow }

enum Building { hospital, clinic }

enum MyError { saerch, fourZeroFour, defaultError }

enum SortingOptions {
  mostCompatible('most_compatible'),
  ratings('ratings'),
  cost('cost'),
  lessWaitingTime('waiting_time');

  final String value;
  const SortingOptions(this.value);
}

enum ReviewSorting { newest, ratings }

enum DoctorTypes {
  doctors('assets/icons/doctor_sheet.svg'),
  hospitals('assets/icons/hospital_sheet.svg');

  final String icon;
  const DoctorTypes(this.icon);
}

enum SearchType {
  autocomplete('autocomplete'),
  citySpeciality('city_speciality'),
  autocompleteClinics('autocomplete_clinics'),
  autocompleteHospitals('autocomplete_hospitals');

  final String value;
  const SearchType(this.value);
}

enum MyOrderStatus {
  pending('pending'),
  current('current'),
  accepted('accepted'),
  refuse('refuse'),
  canceled('cancel'),
  completed('completed'),
  acceptedDelegate('accepted_delegate'),
  refuseDelegate('refuse_delegate'),
  delegateReceiveFromProvider('delegate_receive_order'),
  delegateDeliveryOrder('delegate_delivery_order'),
  acceptedUserDelegateReceiveOrder('accepted_user_delegate_receive_order'),
  receivedOrderProvider('received_order_provider'),
  deliveryOrderClient('delivery_order_client'),
  delegateReceiveOrderFromUser('delegate_receive_order_from_user'),
  receiveCustomer('receive_customer');

  final String value;
  const MyOrderStatus(this.value);
}

enum StatusLevel { natural, careful, dangerous }

enum BookingStatusEnum { canceled, completed, upcoming }

enum MedicalHistorySortingEnum { newestMedical, oldest }

enum BookingSortingEnum { newestMedical, oldest }

enum ImgPath { file, mediaPath, noKey }

enum BillTypes {
  sale("sale"),
  teleSales("phone"),
  ads("ads"),
  mySelf("mySelf");

  final String value;
  const BillTypes(this.value);
}

enum Gender {
  male("male"),
  female("female");

  final String value;
  const Gender(this.value);
}
