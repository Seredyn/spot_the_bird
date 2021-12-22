import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit()..getLocation(),
        ),
        BlocProvider<BirdPostCubit>(
          create: (context) => BirdPostCubit()..loadPosts(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

            //App bar color
            primaryColor: Color(0xFF1a374d),
            colorScheme: ColorScheme.light().copyWith(
                //Textfield color
                primary: Color(0xFF6998AB),
                //Floation action button
                secondary: Color(0xFFB983FF))),
        home: MapScreen(),
      ),
    );
  }
}
