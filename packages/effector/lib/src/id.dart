typedef Id = String Function();

final Id Function() _idCount = () {
  int id = 0;
  return () => (++id).toString();
};

final Id nextUnitID = _idCount();