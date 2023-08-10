
class PracticalMethod implements HexaColorConvertColor{


  static int HexaColorConvertColor(String colorHex){
    return int.parse(colorHex.replaceAll('#', '0xff'));
  }

}

class HexaColorConvertColor{

  //static int ?HexaColorConvertColor(String colorHex){}
}