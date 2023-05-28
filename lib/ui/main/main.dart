import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewelry_e_commerce/data/repoditory/auth_repository.dart';
import 'package:jewelry_e_commerce/data/repoditory/cart_repository.dart';
import 'package:jewelry_e_commerce/ui/cart/bloc/cart_bloc.dart';
import 'package:jewelry_e_commerce/ui/main/bloc/main_bloc.dart';
import 'package:jewelry_e_commerce/ui/root/root.dart';
import 'package:jewelry_e_commerce/util/common.dart';
import 'package:jewelry_e_commerce/util/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import '../widgets/fail_connect_to_network.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(create: (context) {
          final cartBloc = CartBloc(
            cartRepository: cartRepository,
          );
          return cartBloc;
        }),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appThemeData,
        home: Directionality(
            textDirection: TextDirection.rtl,
            child: BlocProvider<MainBloc>(
              create: (context) {
                final bloc = MainBloc();
                bloc.add(MainStarted());
                return bloc;
              },
              child: BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state is MainError) {
                    return FailConnectToNetwork();
                  } else if (state is MainSuccess) {
                    return RootScreen();
                  } else if (state is MainSLoading) {
                    return Center(child: defaulProgressIndicator);
                  } else {
                    throw Exception('state is not supported');
                  }
                },
              ),
            )),
      ),
    );
  }
}
