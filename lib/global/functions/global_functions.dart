
import 'package:flutter/cupertino.dart';
import 'package:kelimeezberle/database/dao.dart';

import '../variable/global_variable.dart';

Future getLists() async {
  lists = await DB.instance.getListsAll();

  for(int i = 0; i<lists.length; ++i){
    selectedListIndex.add(false);
  }
}


void onIconPressed(isKeyboardVisible,context) {
  if (isKeyboardVisible) {
    FocusScope.of(context).unfocus();
  } else {
    Navigator.of(context).pop();
  }
}

