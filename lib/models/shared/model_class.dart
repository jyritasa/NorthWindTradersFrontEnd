abstract class Model {
  //! Dart does not allow for inherited Constructors, so we cannot enforce this,
  //! But this is required to be used in [Controller] class.
  //Model.FromJson(Map<String, dynamic> json)
  Map<String, dynamic> toJson();
}
