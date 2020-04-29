class DelegateCardModel {
  final int id;
  final String name;
  final String desc;
  final int mahePrice;
  final int nonMahePrice;
  final int forSale;
  final int paymentMode;
  final String type;

  DelegateCardModel(
      {this.id,
      this.name,
      this.desc,
      this.mahePrice,
      this.nonMahePrice,
      this.forSale,
      this.paymentMode,
      this.type});
}
