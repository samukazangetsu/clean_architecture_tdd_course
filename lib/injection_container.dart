import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/core/presentantion/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/cubit/number_trivia_cubit.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - NumberTrivia
  await initFeatures();

  //! Core

  //! External
}

Future<void> initFeatures() async {
  // Bloc
  serviceLocator.registerFactory(
    () => NumberTriviaCubit(
      concrete: serviceLocator(),
      random: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => GetConcreteNumberTrivia(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => GetRandomNumberTrivia(serviceLocator()),
  );

  // Repository
  serviceLocator.registerFactory<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // DataSources
  serviceLocator.registerFactory<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

  // Core
  serviceLocator.registerFactory(() => InputConverter());

  serviceLocator.registerFactory<NetworkInfo>(
    () => NetworkInfoImpl(
      serviceLocator(),
    ),
  );

  //! External
  final sharedePreferences = await SharedPreferences.getInstance();
  serviceLocator.registerFactory(() => sharedePreferences);
  serviceLocator.registerFactory(() => http.Client());
  serviceLocator.registerFactory(() => DataConnectionChecker());
}
