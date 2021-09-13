import 'package:firebase_auth/firebase_auth.dart';
import 'package:milvik_flutter_app/repository/dashboard_repository.dart';
import 'package:milvik_flutter_app/repository/login_repository.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final LoginRepository loginRepository = LoginRepository();
String verificationToken = "";
final DashboardRepository dashboardRepository = DashboardRepository();