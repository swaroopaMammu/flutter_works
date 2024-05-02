import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:march09/home/ui/home_screen.dart';
import 'package:march09/widgets/card_item_widget.dart';
import 'package:march09/wishlist/bloc/wishlist_bloc.dart';

import '../bloc/wishlist_event.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

WishlistBloc wishlistBloc = WishlistBloc();

class _WishListScreenState extends State<WishListScreen> {

  @override
  void initState() {
    wishlistBloc.add(WishListLoadedSuccessEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Yours Wishlist'),
        actions: [
          IconButton(onPressed: (){
            wishlistBloc.add(WishListNavToHomeSuccessEvent());
          }, icon: const Icon(Icons.home))
        ],
      ),
      body: BlocConsumer<WishlistBloc, WishlistState>(
        buildWhen: (prev,current) => current is !WishlistActionState,
        listenWhen: (prev,current) => current is WishlistActionState,
        bloc: wishlistBloc,
        listener: (context, state) {
            if( state is WishListToHomeNavSuccessState){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return const HomeScreen();
              }));
            }
        },
        builder: (context, state) {
          switch(state.runtimeType){
            case WishlistLoadSuccessState:
              final successstate = state as WishlistLoadSuccessState;
              return ListView.builder(
                itemCount: successstate.groceryItemList.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardItemWidget(groceryItem:successstate.groceryItemList[index],bloc: wishlistBloc,),
                    );
                  }
              );
            default: const SizedBox();
          }
          return Container();
        },
      ),
    );
  }
}
