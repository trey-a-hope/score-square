import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:score_square/blocs/home/home_bloc.dart';
import 'package:score_square/blocs/games/games_bloc.dart';
import 'package:score_square/services/auth_service.dart';
import 'package:score_square/services/modal_service.dart';
import '../service_locator.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Hello there!'),
                  ),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: const NetworkImage(
                        'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg'),
                    backgroundColor: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (BuildContext context) => HomeBloc()
                        ..add(
                          HomeLoadPageEvent(),
                        ),
                      child: const HomePage(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.gamepad),
              title: const Text('Games'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (BuildContext context) => GamesBloc()
                        ..add(
                          GamesLoadPageEvent(),
                        ),
                      child: const GamesPage(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                bool? confirm = await locator<ModalService>().showConfirmation(
                    context: context,
                    title: 'Logout',
                    message: 'Are you sure?');

                if (confirm == null || confirm == false) return;

                while (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                }
                await locator<AuthService>().signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
