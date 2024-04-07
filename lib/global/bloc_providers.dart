import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sample/utils/select_image/select_images_cubit.dart';

List<SingleChildWidget> blocProviders = [
  BlocProvider(create: (_) => SelectImagesCubit()),
];
