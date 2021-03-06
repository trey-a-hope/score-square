part of 'give_coins_bloc.dart';

class GiveCoinsPage extends StatefulWidget {
  const GiveCoinsPage({Key? key}) : super(key: key);

  @override
  _GiveCoinsPageState createState() => _GiveCoinsPageState();
}

class _GiveCoinsPageState extends State<GiveCoinsPage> {
  final TextEditingController _coinsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      title: 'Give Coins',
      leftIconButton: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      rightIconButton: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () async {
          int? coins = int.tryParse(_coinsController.text);

          if (coins == null) return;

          bool? confirm = await locator<ModalService>().showConfirmation(
              context: context,
              title: 'Send $coins coins to this user?',
              message: 'Are you sure?');

          if (confirm == null || confirm == false) {
            return;
          }

          context.read<GiveCoinsBloc>().add(
                SubmitEvent(
                  coins: coins,
                ),
              );
        },
      ),
      child: BlocConsumer<GiveCoinsBloc, GiveCoinsState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadedState) {
            UserModel user = state.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '${user.username} has ${user.coins} coins, how many coins do you want to give them?',
                    style: AppThemes.textTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _coinsController,
                    decoration: const InputDecoration(
                      labelText: 'Coin amount',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                  ),
                ),
              ],
            );
          }

          return Container();
        },
        listener: (context, state) {
          if (state is LoadedState) {
            if (state.snackbarMessage != null) {
              _coinsController.clear();
              locator<ModalService>().showInSnackBar(
                context: context,
                message: state.snackbarMessage!,
              );
            }
          }
        },
      ),
    );
  }
}
