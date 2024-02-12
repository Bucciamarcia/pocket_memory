import "home/home.dart";
import "newmemory/newmemory.dart";
import "getmemory/getmemory.dart";

var appRoutes = {
  "/": (context) => const HomeScreen(),
  "/newmemory": (context) => const NewMemory(),
  "/getmemory": (context) => const GetMemory()
};