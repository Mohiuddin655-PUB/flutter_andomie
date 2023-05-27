import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di.dart';
import 'data_controller.dart';

class DataTest extends StatefulWidget {
  const DataTest({Key? key}) : super(key: key);

  @override
  State<DataTest> createState() => _DataTestState();
}

class _DataTestState extends State<DataTest> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<DataController>(),
      child: BlocBuilder<DataController, Response<AuthInfo>>(
        builder: (context, state) {
          var controller = context.read<DataController>();
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.insert(
                            AuthInfo(
                              id: "1",
                              email: "example@gmail.com",
                              password: "123456",
                            ),
                          );
                        },
                        child: const RawTextView(text: "Insert"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.inserts(
                            [
                              AuthInfo(
                                id: "2",
                                email: "example@gmail.com",
                                password: "123456",
                              ),
                              AuthInfo(
                                id: "3",
                                email: "example@gmail.com",
                                password: "123456",
                              ),
                            ],
                          );
                        },
                        child: const RawTextView(text: "Inserts"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.update(
                            AuthInfo(
                              id: "1",
                              email: "example.updated@gmail.com",
                              password: "123456.updated",
                            ),
                          );
                        },
                        child: const RawTextView(text: "Update"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.delete("1");
                        },
                        child: const RawTextView(text: "Delete"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.clear();
                        },
                        child: const RawTextView(text: "Clear"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.get("1");
                        },
                        child: const RawTextView(text: "Get"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.gets();
                        },
                        child: const RawTextView(text: "Gets"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.isAvailable("1");
                        },
                        child: const RawTextView(text: "Available"),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    color: Colors.grey.withAlpha(50),
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: RawTextView(
                      text: "Successful: ${state.isSuccessful},\n"
                          "No Internet: ${state.isInternetError},\n"
                          "Error: ${state.exception},\n"
                          "Message: ${state.message},\n"
                          "Feedback: ${state.feedback},\n"
                          "Snapshot: ${state.snapshot},\n"
                          "Data: ${state.data},\n"
                          "Result: ${state.result},\n",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    color: Colors.grey.withAlpha(50),
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: StreamBuilder(
                        stream: controller.live("1"),
                        builder: (context, snapshot) {
                          var value = snapshot.data ?? Response();
                          return RawTextView(
                            text: value.data.toString(),
                            textAlign: TextAlign.center,
                          );
                        }),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    color: Colors.grey.withAlpha(50),
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: StreamBuilder(
                        stream: controller.lives(),
                        builder: (context, snapshot) {
                          var value = snapshot.data ?? Response();
                          return RawTextView(
                            text: value.result.toString(),
                            textAlign: TextAlign.center,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
