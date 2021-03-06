import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:score_square/blocs/game/game_bloc.dart' as game_bloc;
import 'package:score_square/models/game_model.dart';
import 'package:score_square/models/user_model.dart';
import 'package:score_square/services/game_service.dart';
import 'package:score_square/services/modal_service.dart';
import 'package:score_square/widgets/basic_page.dart';
import 'package:score_square/widgets/list_tiles/game_list_tile.dart';

import '../../service_locator.dart';

part 'claim_winners_event.dart';
part 'claim_winners_page.dart';
part 'claim_winners_state.dart';

class ClaimWinnersBloc extends Bloc<ClaimWinnersEvent, ClaimWinnersState> {
  List<GameModel> _games = [];

  ClaimWinnersBloc() : super(ClaimWinnersInitial()) {
    on<LoadPageEvent>((event, emit) async {
      emit(LoadingState());

      try {
        _games =
            await locator<GameService>().list(closed: true, claimed: false);
        emit(LoadedState(
          games: _games,
          showMessage: false,
        ));
      } catch (error) {
        emit(ErrorState(error: error));
      }
    });
    on<ClaimEvent>((event, emit) async {
      GameModel game = event.game;

      emit(LoadingState());

      try {
        //Fetch all participants. //TODO: Find more efficient way to get losers and winners.
        List<UserModel> participants =
            await locator<GameService>().getParticipants(game: game);

        //Fetch current winners.
        List<UserModel> currentWinners =
            await locator<GameService>().getWinners(
          game: event.game,
        );

        //Remove winners from participants, making this list for losers only.
        for (int i = 0; i < currentWinners.length; i++) {
          participants.removeWhere(
              (participant) => participant.uid == currentWinners[i].uid);
        }

        //Award the winners.
        await locator<GameService>().claimGame(
          winners: currentWinners,
          losers: participants,
          game: game,
        );

        //Show success message and get new list of games.
        _games =
            await locator<GameService>().list(closed: true, claimed: false);
        emit(LoadedState(
          games: _games,
          showMessage: true,
        ));
      } catch (error) {
        emit(ErrorState(error: error));
      }
    });
  }
}
