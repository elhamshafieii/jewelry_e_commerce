import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jewelry_e_commerce/util/common.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainSLoading()) {
    on<MainEvent>((event, emit) async {
      final bool isConnectedToNetwork = await checkNetworkConectivity();
      if (isConnectedToNetwork) {
        emit(MainSuccess());
      } else {
        emit(MainError());
      }
    });
  }
}
