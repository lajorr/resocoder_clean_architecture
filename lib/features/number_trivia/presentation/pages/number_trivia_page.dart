// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:resocoder_clean_architecture/injection_container.dart';

import '../widgets/trivia_controls.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Builder(
        builder: (context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  //* top half
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return const MessageDisplay(
                          message: 'Start Searching!!',
                        );
                      } else if (state is Loading) {
                        return const LoadingWidget();
                      } else if (state is Error) {
                        return MessageDisplay(message: state.message);
                      } else if (state is Loaded) {
                        // loaded state
                        return TriviaDisplay(numberTrivia: state.numberTrivia);
                      }
                      return Container();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Bottom Half
                  const TriviaControls()
               
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

