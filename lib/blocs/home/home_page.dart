part of 'home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    //Setup Flutter Local Notifications
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    //Initialize Flutter Local Notifications Plugin.
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    //Register Firebase onMessage.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String title = message.notification!.title!;
        String body = message.notification!.body!;
        showNotification(
          title,
          body,
        );
      }
    });

    //Register Firebase onMessageOpenedApp.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        String title = message.notification!.title!;
        String body = message.notification!.body!;
        showNotification(
          title,
          body,
        );
      }
    });

    //Register Firebase onBackgroundMessage.
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      String title = message.notification!.title!;
      String body = message.notification!.body!;
      showNotification(
        title,
        body,
      );
    });
  }

  Future<String?> onSelectNotification(String? payload) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID', 'channel name',
      importance: Importance.max,
      playSound: true,
      //sound: AndroidNotificationSound.,
      showProgress: true,
      priority: Priority.high,
      ticker: 'test ticker',
    );

    const iOSChannelSpecifics = IOSNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      title: 'Home',
      scaffoldKey: _scaffoldKey,
      leftIconButton: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      rightIconButton: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          context.read<HomeBloc>().add(LoadPageEvent());
        },
      ),
      drawer: const CustomAppDrawer(
        pushNewRoute: false,
      ),
      child: BlocConsumer<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadedState) {
            UserModel user = state.user;
            List<BetModel> bets = state.bets;

            return Column(
              children: [
                UserListTile(user: user),
                Text(
                  'My Active Bets - ${bets.length}',
                  style: textTheme.headline4,
                ),
                bets.isEmpty
                    ? const Text('No bets.')
                    : SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: bets.length,
                          itemBuilder: (context, index) {
                            return BetView(bet: bets[index]);
                          },
                        ),
                      ),
                const Spacer(),
                Text(
                  '${locator<UtilService>().getGreeting()}, and welcome to Score Square!',
                  style: textTheme.headline4,
                ),
              ],
            );
          }

          return Container();
        },
        listener: (context, state) {},
      ),
    );
  }
}
