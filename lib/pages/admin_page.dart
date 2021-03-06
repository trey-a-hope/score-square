import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:score_square/blocs/create_game/create_game_bloc.dart'
    as create_game;
import 'package:score_square/blocs/update_game/update_game_bloc.dart'
    as update_game;
import 'package:score_square/blocs/give_coins/give_coins_bloc.dart'
    as give_coins;
import 'package:score_square/blocs/claim_winners/claim_winners_bloc.dart'
    as claim_winners_game;
import 'package:score_square/blocs/delete_game/delete_game_bloc.dart'
    as delete_game;
import 'package:score_square/models/game_model.dart';
import 'package:score_square/models/user_model.dart';
import 'package:score_square/pages/recently_active_users.page.dart';
import 'package:score_square/pages/select_item_page.dart';
import 'package:score_square/services/game_service.dart';
import 'package:score_square/services/util_service.dart';
import 'package:score_square/widgets/basic_page.dart';
import '../service_locator.dart';
import '../constants/app_themes.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  _AdminPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      title: 'Admin',
      leftIconButton: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      child: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) =>
                        create_game.CreateGameBloc()
                          ..add(create_game.LoadPageEvent()),
                    child: const create_game.CreateGamePage(),
                  ),
                ),
              );
            },
            leading: const Icon(Icons.sports_basketball),
            subtitle: const Text('Create a new game for users to bet on.'),
            title: Text(
              'Create Game',
              style: AppThemes.textTheme.headline4,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) =>
                        claim_winners_game.ClaimWinnersBloc()
                          ..add(claim_winners_game.LoadPageEvent()),
                    child: const claim_winners_game.ClaimWinnersPage(),
                  ),
                ),
              );
            },
            leading: const Icon(Icons.face),
            subtitle:
                const Text('Give coins to winners and send notification.'),
            title: Text(
              'Claim Winners',
              style: AppThemes.textTheme.headline4,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RecentlyActiveUsersPage(),
                ),
              );
            },
            leading: const Icon(MdiIcons.naturePeople),
            subtitle: const Text('See all users by most recent login.'),
            title: Text(
              'Recently Active Users',
              style: AppThemes.textTheme.headline4,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () async {
              List<GameModel> games = await locator<GameService>().list();

              Route route = MaterialPageRoute(
                builder: (BuildContext context) => SelectItemPage(
                  items: games,
                  type: 'Game',
                ),
              );

              final result = await Navigator.push(context, route);

              if (result == null) return;

              final selectedGame = result as GameModel;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) =>
                        update_game.UpdateGameBloc(gameID: selectedGame.id!)
                          ..add(update_game.LoadPageEvent()),
                    child: const update_game.UpdateGamePage(),
                  ),
                ),
              );
            },
            leading: const Icon(Icons.update),
            subtitle: const Text(
                'Modify score, status, and other details about game.'),
            title: Text(
              'Update Game',
              style: AppThemes.textTheme.headline4,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () async {
              UserModel? user =
                  await locator<UtilService>().searchForUser(context: context);

              if (user == null) {
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) =>
                        give_coins.GiveCoinsBloc(uid: user.uid!)
                          ..add(give_coins.LoadPageEvent()),
                    child: const give_coins.GiveCoinsPage(),
                  ),
                ),
              );
            },
            leading: const Icon(Icons.attach_money),
            subtitle: const Text('Add coins to a user account.'),
            title: Text(
              'Give Coins',
              style: AppThemes.textTheme.headline4,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () async {
              List<GameModel> games = await locator<GameService>().list();

              Route route = MaterialPageRoute(
                builder: (BuildContext context) => SelectItemPage(
                  items: games,
                  type: 'Game',
                ),
              );

              final result = await Navigator.push(context, route);

              if (result == null) return;

              final selectedGame = result as GameModel;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) =>
                        delete_game.DeleteGameBloc(gameID: selectedGame.id!)
                          ..add(delete_game.LoadPageEvent()),
                    child: const delete_game.DeleteGamePage(),
                  ),
                ),
              );
            },
            leading: const Icon(Icons.delete),
            subtitle: const Text('Delete a game and it\'s bets.'),
            title: Text(
              'Delete Game',
              style: AppThemes.textTheme.headline4,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
