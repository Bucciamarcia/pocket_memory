import "home/home.dart";
import "newmemory/newmemory.dart";
import "getmemory/getmemory.dart";
import "settings/settings.dart";
import "login/login.dart";

var appRoutes = {
  "/": (context) => const HomeScreen(),
  "/newmemory": (context) => const NewMemoryScreen(),
  "/getmemory": (context) => const GetMemoryScreen(),
  "/settings": (context) => const SettingsScreen(),
  "/login": (context) => const LoginScreen(),
};