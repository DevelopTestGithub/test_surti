class Price {

  final double input;
  String dollars = "";
  String cents = "";


  Price(this.input){
    String duoDecimalPriceInString = (((this.input*100).round())/100).toString();
    List<String> splitDuoDecimalPriceString =  duoDecimalPriceInString.split(".");
    var dollarsInt = int.parse(splitDuoDecimalPriceString[0]);
    if(splitDuoDecimalPriceString[1].length < 2){
      splitDuoDecimalPriceString[1] = "${splitDuoDecimalPriceString[1]}0";
    }

    int priceDollars = dollarsInt;
    int priceCents = int.parse(splitDuoDecimalPriceString[1]);

     dollars = "$priceDollars";

    if(priceCents.toString().length < 2){
      cents = "0$priceCents";
    }else{
      cents = "${priceCents}";
    }
    
  }

  String getDollars (){
    return dollars;
  }
  String getCents (){
    return cents;
  }
  String getFormatted(){

    return r" $" "$dollars.$cents";
  }
}