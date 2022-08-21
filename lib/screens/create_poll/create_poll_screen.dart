import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pepoll/screens/home/components/tab_bar_widget.dart';
import 'package:redux/redux.dart';

import '../../core/colors.dart';
import '../../model/poll_choice.dart';
import '../../redux/app_state.dart';
import '../../redux/navigation/navigation_action.dart';
import '../../core/input_validators.dart';
import '../../model/poll.dart';
import '../../provider/firestore.dart';
import 'components/text_field_component.dart';

enum Day {Yesterday, Today, Tomorrow}

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({Key key}) : super(key: key);
  @override
  _CreatePollScreenState createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _createPollKey = GlobalKey<FormState>();
  TextEditingController queCtrl = TextEditingController();
  TextEditingController expirationCtrl =
    TextEditingController(text: DateFormat('yMMMMd').format(DateTime.now().add(const Duration(days: 1))));
  bool showAddChoicesButton= true;
  bool showRemoveChoicesButton = false;
  List<Widget> choices = [];
  List<TextEditingController> choiceCtrls = [];
  Poll poll;

  Day isToday(DateTime date) {
    Day day;
    final diff = date.difference(DateTime.now()).inDays;
    if(diff == 0) day = Day.Today;
    if(diff > 0) day = Day.Tomorrow;
    if(diff < 0) day = Day.Yesterday;
    return day;
  }

  Widget buildQuestionTextField() {
    return TextFieldComponent(
      label: 'Question: ',
      validator: InputValidator.validateQuestionInput,
      txtCtrl: queCtrl,

    );
  }

  Widget buildChoiceTextField(String label, TextEditingController choiceCtrl) {
    return TextFieldComponent(
      label: '$label' ':' ' ',
      validator: InputValidator.validateQuestionInput,
      txtCtrl: choiceCtrl,

    );
  }

  Widget buildExpirationTextField(Function onTap, bool disableTap) {
    return InkWell(
      onTap: onTap,
      child: TextFieldComponent(
        label: 'Expiration: ',
        validator: InputValidator.validateExpirationInput,
        txtCtrl: expirationCtrl,
        onTap: onTap,
        disableTap: disableTap,
      ),
    );
  }

  Widget buildSnackBar(String text, Color color) {
    return SnackBar(content: Text(text), backgroundColor: color, duration: const Duration(seconds: 2),);
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2222),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if(date == null) return null;
    String dateString = DateFormat('yyyy-MM-dd').format(date);
    debugPrint('Picked date: $dateString');
    setState(() => expirationCtrl = TextEditingController(text: dateString));
    return date;
  }

  @override
  void initState() {
    choiceCtrls.add(TextEditingController());
    choiceCtrls.add(TextEditingController());
    choices.add(buildChoiceTextField('Choice 1', choiceCtrls[0]));
    choices.add(buildChoiceTextField('Choice 2', choiceCtrls[1]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kMatteViolet,
      body: WillPopScope(
        onWillPop: () {
          return store.dispatch(Navigation.pushHomeScreen);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _createPollKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name and email arrange vertically
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Create poll",
                          style: TextStyle(
                              fontSize: 22,
                              color: kLightMagenta,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Please provide required info to create a poll.",
                          style: TextStyle(
                              fontSize: 14,
                              color: kWhite,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Divider(thickness: 2,),
                    ),
                    // question text field
                    buildQuestionTextField(),
                    // choices
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: choices
                      ),
                    ),
                    const SizedBox(height: 10),
                    // add choices button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Visibility(
                          visible: showAddChoicesButton,
                          child: InkWell(
                            onTap: () {
                              if(choices.length <= 9) {
                                setState(() {
                                  choiceCtrls.add(TextEditingController());
                                  choices.add(buildChoiceTextField('Choice ${choices.length + 1}', choiceCtrls[choiceCtrls.length - 1]));
                                });

                                if(choices.length == 10) {
                                  showAddChoicesButton = false;
                                  showRemoveChoicesButton = true;
                                  const snackBar = SnackBar(
                                      content: Text('You reached the maximum number of choice!'),
                                      backgroundColor: Colors.redAccent
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: kPaleYellow
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // remove choice button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Visibility(
                          visible: showRemoveChoicesButton,
                          child: InkWell(
                            onTap: () {
                              if(choices.length <= 10) {
                                setState(() {
                                  choiceCtrls.remove(choiceCtrls[choiceCtrls.length - 1]);
                                  choices.remove(choices[choices.length - 1]);
                                });

                                if(choices.length == 2) {
                                  showAddChoicesButton = true;
                                  showRemoveChoicesButton = false;
                                  const snackBar = SnackBar(
                                      content: Text('You reached the minimum number of choice!'),
                                      backgroundColor: Colors.redAccent
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: kMatteOrange
                              ),
                              child: const Icon(Icons.remove),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // date picker for expiration date
                    buildExpirationTextField(() async => await pickDate(context), true),
                    const SizedBox(height: 50),
                    // cancel and submit button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          // cancel button
                          Expanded(
                            child:  ElevatedButton(
                              onPressed: () async {
                                queCtrl = TextEditingController();
                                expirationCtrl= TextEditingController();
                                for(var choiceCtrl in choiceCtrls) {
                                  choiceCtrl = TextEditingController();
                                }
                                store.dispatch(Navigation.pushHomeScreen);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: kWhite,
                                  onPrimary: kMatteOrange,
                                  minimumSize: const Size(double.infinity, 50)
                              ),
                              child: const Text('Cancel', style: TextStyle(fontSize: 18),),
                            ),
                          ),
                          const SizedBox(width: 50,),
                          Expanded(
                            child:  ElevatedButton(
                              onPressed: () async {
                                if(_createPollKey.currentState.validate()) {
                                  PollChoice pollChoice;
                                  List<PollChoice> pollChoices = [];
                                  if(expirationCtrl.text == DateFormat('yMMMMd').format(DateTime.now().add(const Duration(days: 1)))) {
                                    expirationCtrl =
                                        TextEditingController(
                                            text: DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now().add(const Duration(days: 1))
                                            )
                                        );
                                  }
                                  for(var choiceCtrl in choiceCtrls) {

                                    pollChoice = PollChoice(
                                      choice: choiceCtrl.text,
                                    );
                                    pollChoices.add(pollChoice);
                                  }
                                  poll = Poll(
                                      question: queCtrl.text,
                                      expiration: expirationCtrl.text,
                                      createdBy: store.state.localState.user.uid
                                  );
                                  await createPoll(poll, pollChoices).then((value) {
                                    final successSnackBar = buildSnackBar('Success', kLightMagenta);
                                    ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
                                    Future.delayed(const Duration(milliseconds: 250), () async {
                                      queCtrl = TextEditingController();
                                      expirationCtrl= TextEditingController();
                                      for(var choiceCtrl in choiceCtrls) {
                                        choiceCtrl = TextEditingController();
                                      }
                                      store.dispatch(Navigation.pushHomeScreen);
                                    });
                                  }).catchError((e) {
                                    final errorSnackBar = buildSnackBar('Error', kMatteOrange);
                                    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: kPaleYellow,
                                  onPrimary: kLightMagenta,
                                  minimumSize: const Size(double.infinity, 50)
                              ),
                              child: const Text('Post', style: TextStyle(fontSize: 18),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: StoreConnector<AppState , int>(
        converter: (store) => store.state.homeState.currentTabIndex,
        builder: (context, vm) {
          return TabBarWidget(currentIndex: vm);
        },
      ),
    );
  }
}
