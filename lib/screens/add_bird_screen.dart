import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;
  final File image;

  //final TapPosition tapPosition;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  _AddBirdScreenState createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  String? name;
  String? description;

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      //Invalid
      return; //тут происходит возврат из метода и его (этого метода) работа дальше прекращается
    }

    _formKey.currentState!
        .save(); //сохраняет все поля в наших TextFormField(). методы onSaved: (value) в текстовых формах

    //save to cubit

    final BirdModel birdModel = BirdModel(
        birdName: name,
        birdDescription: description,
        latitude: widget.latLng.latitude,
        longitude: widget.latLng.longitude,
        image: widget.image);


    context.read<BirdPostCubit>().addBirdPost(birdModel);

    Navigator.of(context)
        .pop(); //context тут будет потому что у нас StatefulWidget. иначе пришлось бы передавать через агрументы этого метода. На всякий случай передаем и мы
  }

  final _formKey = GlobalKey<FormState>();

  late final FocusNode
      _descriptionFocusNode; //late означает, что мы его создаем позже

  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: , leading указывается слева по дефолту и там будет кнопка назад
        title: Text("Add Bird"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // по умолчанию он и так на start
              children: [
                Container(
                  width: MediaQuery.of(context)
                      .size
                      .width, //ширину Container делаем шириной вего экрана
                  height: MediaQuery.of(context).size.width /
                      1.4, //ширину делим на 1.4
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(widget.image),
                      //нужно добраться до нашего StatefulWidget? поэтому widget.image. Нам нужен не стейт, а сам виджет
                      fit: BoxFit
                          .cover, //растянет на весь размер. поэтому указываем размер Container()
                    ),
                  ),
                  //child: Text("${widget.latLng.latitude} ${widget.latLng.longitude}"), //пишем через такую фигню "${widget.latLng.longitude}" потому что нужно добраться до нашего StatefulWidget (у него есть стейт). В Stateless такое делать не нужно (у него нет стейта)
                ),
                //ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text("POP"))

                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter a bird Name",
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    //move focus
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    name = value!.trim();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please, enter a name...";
                    }
                    if (value.length < 2) {
                      return "Please, enter a longer name...";
                    }
                    return null; //return null; тут означает, что валидацию пройдено
                  },
                ),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    //_submit(birdModel, context);


                    _submit(context);
                  },
                  decoration: InputDecoration(
                    hintText: "Enter a bird description",
                  ),
                  onSaved: (value) {
                    description = value!.trim();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please, enter a description...";
                    }
                    if (value.length < 5) {
                      return "Please, enter a longer description...";
                    }
                    return null; //return null; тут означает, что валидацию пройдено
                  },
                ),
                TextField(),
                TextField(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          _submit(context);

          //TODO:- Add BirdPost to BirdPostCubit

          //Save Bird Host

          //Show Posts on Map
        },
        child: Icon(
          Icons.check,
          size: 30,
        ),
      ),
    );
  }
}
